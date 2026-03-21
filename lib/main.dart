import 'dart:async';
import 'package:provider/provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'auth/custom_auth/auth_util.dart';
import 'auth/custom_auth/custom_auth_user_provider.dart';

import '/backend/backend.dart';
import '/backend/update_service.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'flutter_flow/flutter_flow_util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  usePathUrlStrategy();

  final initialUser = Proyecto1608XproDigitalTVAuthUser(loggedIn: false);
  final appState = FFAppState();

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

class MyAppState extends State<MyApp> {
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
          // Trigger update check when user logs in successfully
          UpdateService.checkForUpdates();
        } else {
          _stopSubscriptionMonitoring();
        }
      });

    if (loggedIn) {
      _startSubscriptionMonitoring();
    }

    // Check for updates on startup with a slight delay to ensure navigator is ready
    Future.delayed(const Duration(seconds: 1), () {
      UpdateService.checkForUpdates();
    });

    _appStateNotifier.stopShowingSplashImage();
  }

  void _startSubscriptionMonitoring() {
    _stopSubscriptionMonitoring();

    final sucursalRef = FFAppState().loggedSucursal;
    if (sucursalRef == null) {
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
      if (FFAppState().isSubscriptionActive != isActive) {
        FFAppState().isSubscriptionActive = isActive;
        // --- LA CORRECCIÓN ---
        // Notificamos manualmente al listener del router para forzar la redirección.
        // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
        _appStateNotifier.notifyListeners();
      }
    });

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
        if (sub != null && sub.endDate != null) {
          isActive =
              (functions.daysUntilSubscriptionEnds(sub.endDate!) ?? 0) > 0;
        }
        if (FFAppState().isSubscriptionActive != isActive) {
          FFAppState().isSubscriptionActive = isActive;
          // --- LA CORRECCIÓN ---
          // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
          _appStateNotifier.notifyListeners();
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
