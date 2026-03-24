import 'dart:async';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'auth/custom_auth/auth_util.dart';
import 'auth/custom_auth/custom_auth_user_provider.dart';

import '/backend/backend.dart';
import '/backend/update_service.dart';
import '/backend/firebase/firebase_config.dart';
import 'flutter_flow/flutter_flow_util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  usePathUrlStrategy();

  await initFirebase();

  final initialUser = Proyecto1608XproDigitalTVAuthUser(loggedIn: false);
  final appState = FFAppState();
  await appState.initializePersistedState();

  runApp(ChangeNotifierProvider(
    create: (context) => appState,
    child: MyApp(initialUser: initialUser),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, this.initialUser});
  final Proyecto1608XproDigitalTVAuthUser? initialUser;

  @override
  State<MyApp> createState() => MyAppState();

  static MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<MyAppState>()!;
}

class MyAppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  ThemeMode _themeMode = ThemeMode.system;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;

  late Stream<Proyecto1608XproDigitalTVAuthUser> userStream;

  late StreamSubscription<Proyecto1608XproDigitalTVAuthUser> authUserSub;
  StreamSubscription? _subscriptionListener;
  Timer? _dailyCheckTimer;

  String getRoute([RouteMatch? routeMatch]) {
    final RouteMatch lastMatch =
        routeMatch ?? _router.routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : _router.routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }

  List<String> getRouteStack() =>
      _router.routerDelegate.currentConfiguration.matches
          .map((e) => getRoute(e))
          .toList();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _appStateNotifier = AppStateNotifier.instance;

    if (widget.initialUser != null) {
      _appStateNotifier.update(widget.initialUser!);
    }

    _router = createRouter(_appStateNotifier);

    userStream = proyecto1608XproDigitalTVAuthUserStream();
    authUserSub = userStream.listen((user) {
      _appStateNotifier.update(user);
      if (user.loggedIn) {
        // --- SEGURO ANTI-REINICIO ---
        // Solo iniciamos si no hay un listener activo ya.
        if (_subscriptionListener == null) {
          _startSubscriptionMonitoring();
        }
        // Trigger update check when user logs in successfully
        UpdateService.checkForUpdates(source: 'Login');
      } else {
        // Si cerramos sesión, limpiamos el monitor por seguridad
        _subscriptionListener?.cancel();
        _subscriptionListener = null;
      }
    });

    if (loggedIn) {
      _startSubscriptionMonitoring();
    }

    // Check for updates on startup with a 5s delay to ensure navigator is fully settled
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) UpdateService.checkForUpdates(source: 'Startup');
    });

    _appStateNotifier.stopShowingSplashImage();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    authUserSub.cancel();
    _stopSubscriptionMonitoring();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint('App Lifecycle: State changed to ${state.name}');
    if (state == AppLifecycleState.resumed) {
      debugPrint(
          'App Lifecycle: Resumed - Waiting 5s before checking for updates...');
      Future.delayed(const Duration(seconds: 5), () {
        if (mounted) UpdateService.checkForUpdates(source: 'Resume');
      });
    }
  }

  void _startSubscriptionMonitoring() {
    // Si ya existe un listener, no hacemos nada más (conexión de hierro)
    if (_subscriptionListener != null) return;

    final sucursalRef = FFAppState().loggedSucursal;
    if (sucursalRef == null) {
      print('[XPRO_SUBSCRIPTION] Sucursal es NULL. No se puede monitorear.');
      return;
    }

    print('[XPRO_SUBSCRIPTION] Iniciando monitoreo nativo para sucursal: ${sucursalRef.id}');
    
    // Usamos snapshots nativos para asegurar que la conexión no se pierda entre navegaciones
    _subscriptionListener = FirebaseFirestore.instance
        .collection('subscription')
        .where('sucursalRef', isEqualTo: sucursalRef)
        .snapshots()
        .listen((snapshot) {
      final doc = snapshot.docs.firstOrNull;
      bool isActive = false;

      print('[XPRO_SUBSCRIPTION] Update recibido. ¿Documento existe?: ${doc != null}');

      if (doc != null) {
        final data = doc.data();
        final fieldIsActive = data['isActive'] as bool? ?? true;
        final endDate = data['endDate'] as Timestamp?;
        final now = DateTime.now();

        // REGLA SIMPLE: Activa si el admin dice true Y la fecha no ha pasado (ni 1 segundo)
        if (fieldIsActive == false) {
          isActive = false;
        } else if (endDate != null) {
          isActive = endDate.toDate().isAfter(now);
        } else {
          isActive = true; // Si no hay fecha pero el admin dice que sí, pasa
        }
      }

      print('[SUBSCRIPCIÓN] Estado: ${isActive ? "ACTIVO" : "EXPIRADO"}');

      if (FFAppState().isSubscriptionActive != isActive) {
        FFAppState().isSubscriptionActive = isActive;
        _appStateNotifier.updateSubscriptionStatus(isActive);
      }
    }, onError: (e) => print('[SUBSCRIPCIÓN] Error: $e'));

    _scheduleNextDailyCheck();
  }

  void _stopSubscriptionMonitoring() {
    _subscriptionListener?.cancel();
    _dailyCheckTimer?.cancel();
  }

  void _performDailyCheck() {
    final sucursalRef = FFAppState().loggedSucursal;
    if (sucursalRef != null) {
      querySubscriptionRecordOnce(
        queryBuilder: (q) => q.where('sucursalRef', isEqualTo: sucursalRef),
        singleRecord: true,
      ).then((subs) {
        final sub = subs.firstOrNull;
        bool isActive = false;
        if (sub != null) {
          if (sub.hasIsActive() && !sub.isActive) {
            isActive = false;
          } else if (sub.hasEndDate()) {
            isActive = sub.endDate!.isAfter(DateTime.now());
          }
        }
        if (FFAppState().isSubscriptionActive != isActive) {
          FFAppState().isSubscriptionActive = isActive;
          _appStateNotifier.updateSubscriptionStatus(isActive);
        }
      });
    }
    _scheduleNextDailyCheck();
  }

  void _scheduleNextDailyCheck() {
    _dailyCheckTimer?.cancel();
    final now = DateTime.now();
    final targetTime = DateTime(now.year, now.month, now.day + 1, 0, 1);
    final timeUntilTarget = targetTime.difference(now);

    _dailyCheckTimer = Timer(timeUntilTarget, _performDailyCheck);
  }

  void setThemeMode(ThemeMode mode) => safeSetState(() {
        _themeMode = mode;
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Proyecto 1608 XproDigital - TV',
      scrollBehavior: MyAppScrollBehavior(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', '')],
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: false,
      ),
      themeMode: _themeMode,
      routerConfig: _router,
    );
  }
}
