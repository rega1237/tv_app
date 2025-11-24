import 'dart:async';
import 'package:provider/provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'auth/custom_auth/auth_util.dart';
import 'auth/custom_auth/custom_auth_user_provider.dart';

import 'backend/firebase/firebase_config.dart';
import '/backend/backend.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'flutter_flow/nav/nav.dart';
import 'index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  usePathUrlStrategy();

  await initFirebase();

  final initialUser = await authManager.initialize();

  final appState = FFAppState();
  await appState.initializePersistedState();

  if (initialUser != null && initialUser.loggedIn) {
    print('[Startup] User is logged in. Checking subscription...');
    final sucursalRef = appState.loggedSucursal;
    if (sucursalRef != null) {
      try {
        final subs = await querySubscriptionRecordOnce(
          queryBuilder: (q) => q.where('sucursalRef', isEqualTo: sucursalRef),
          singleRecord: true,
        );
        final sub = subs.firstOrNull;
        if (sub == null ||
            (functions.daysUntilSubscriptionEnds(sub.endDate!) ?? 0) <= 0) {
          print('[Startup] Subscription is EXPIRED or not found.');
          appState.isSubscriptionActive = false;
        } else {
          print('[Startup] Subscription is ACTIVE.');
          appState.isSubscriptionActive = true;
        }
      } catch (e) {
        print('[Startup] Error checking subscription: $e');
        appState.isSubscriptionActive = false;
      }
    } else {
      print('[Startup] No sucursal reference found. Subscription is INACTIVE.');
      appState.isSubscriptionActive = false;
    }
  } else {
    print('[Startup] No user logged in.');
  }

  runApp(ChangeNotifierProvider(
    create: (context) => appState,
    child: MyApp(initialUser: initialUser),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, this.initialUser});
  final Proyecto1608XproDigitalTVAuthUser? initialUser;

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class MyAppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;

  late Stream<Proyecto1608XproDigitalTVAuthUser> userStream;
  
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

    _appStateNotifier = AppStateNotifier.instance;

    if (widget.initialUser != null) {
      _appStateNotifier.update(widget.initialUser!);
    }

    _router = createRouter(_appStateNotifier);
    
    userStream = proyecto1608XproDigitalTVAuthUserStream()
      ..listen((user) {
        _appStateNotifier.update(user);
        if (user.loggedIn) {
          _startSubscriptionMonitoring();
        } else {
          _stopSubscriptionMonitoring();
        }
      });

    if (loggedIn) {
      _startSubscriptionMonitoring();
    }

    Future.delayed(
      Duration(milliseconds: 1000),
      () => _appStateNotifier.stopShowingSplashImage(),
    );
  }

  void _startSubscriptionMonitoring() {
    print('[Subscription] Starting monitoring...');
    _stopSubscriptionMonitoring();

    final sucursalRef = FFAppState().loggedSucursal;
    if (sucursalRef == null) {
      print('[Subscription] Monitoring stopped: sucursalRef is null.');
      return;
    }

    final subscriptionQuery = querySubscriptionRecord(
      queryBuilder: (q) => q.where('sucursalRef', isEqualTo: sucursalRef),
      singleRecord: true,
    );

    _subscriptionListener = subscriptionQuery.listen((subs) {
      final sub = subs.firstOrNull;
      bool isActive = false;
      if (sub != null && sub.endDate != null) {
        isActive = (functions.daysUntilSubscriptionEnds(sub.endDate!) ?? 0) > 0;
      }
      print('[Subscription] Real-time update. Subscription active: $isActive');
      if (FFAppState().isSubscriptionActive != isActive) {
        FFAppState().isSubscriptionActive = isActive;
        // --- LA CORRECCIÓN ---
        // Notificamos manualmente al listener del router para forzar la redirección.
        _appStateNotifier.notifyListeners();
        print('[Subscription] Notifying router of state change.');
      }
    });

    _scheduleNextDailyCheck();
  }

  void _stopSubscriptionMonitoring() {
    print('[Subscription] Stopping monitoring...');
    _subscriptionListener?.cancel();
    _dailyCheckTimer?.cancel();
  }

  void _performDailyCheck() {
    print('[Subscription] Performing daily check...');
    final sucursalRef = FFAppState().loggedSucursal;
    if (sucursalRef != null) {
       querySubscriptionRecordOnce(
        queryBuilder: (q) => q.where('sucursalRef', isEqualTo: sucursalRef),
        singleRecord: true,
      ).then((subs) {
        final sub = subs.firstOrNull;
        bool isActive = false;
        if (sub != null && sub.endDate != null) {
          isActive = (functions.daysUntilSubscriptionEnds(sub.endDate!) ?? 0) > 0;
        }
        if (FFAppState().isSubscriptionActive != isActive) {
          FFAppState().isSubscriptionActive = isActive;
          // --- LA CORRECCIÓN ---
          _appStateNotifier.notifyListeners();
          print('[Subscription] Notifying router of daily check state change.');
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

    print('[Subscription] Next daily check scheduled in ${timeUntilTarget.inHours} hours.');
    _dailyCheckTimer = Timer(timeUntilTarget, _performDailyCheck);
  }

  @override
  void dispose() {
    _stopSubscriptionMonitoring();
    super.dispose();
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
      localizationsDelegates: [
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
