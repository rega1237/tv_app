import '/auth/custom_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/firebase/firebase_config.dart';
import '/pages/expired_subscription_page/expired_subscription_page_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'loading_page_model.dart';
export 'loading_page_model.dart';

class LoadingPageWidget extends StatefulWidget {
  const LoadingPageWidget({super.key});

  static String routeName = 'LoadingPage';
  static String routePath = '/loading'; // Although we map '/' to this, we can give it a name

  @override
  State<LoadingPageWidget> createState() => _LoadingPageWidgetState();
}

class _LoadingPageWidgetState extends State<LoadingPageWidget> {
  late LoadingPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool _didBoot = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LoadingPageModel());

    SchedulerBinding.instance.addPostFrameCallback((_) => _boot());
  }

  Future<void> _boot() async {
    if (_didBoot || !mounted) return;
    _didBoot = true;

    await initFirebase();

    final authUser = await authManager.initialize();
    await FFAppState().initializePersistedState();

    final isLoggedIn = authUser?.loggedIn ?? false;
    if (!isLoggedIn) {
      if (!mounted) return;
      context.goNamed(OrientationSelectionPageWidget.routeName);
      return;
    }

    await _checkSubscription();
    if (!mounted) return;

    if (FFAppState().isSubscriptionActive) {
      context.goNamed(InicioWidget.routeName);
    } else {
      context.goNamed(ExpiredSubscriptionPageWidget.routeName);
    }
  }

  Future<void> _checkSubscription() async {
    final appState = FFAppState();
    final sucursalRef = appState.loggedSucursal;
    if (sucursalRef == null) {
      appState.isSubscriptionActive = false;
      return;
    }

    try {
      final subs = await querySubscriptionRecordOnce(
        queryBuilder: (q) => q.where('sucursalRef', isEqualTo: sucursalRef),
        singleRecord: true,
      );
      final sub = subs.firstOrNull;
      if (sub == null ||
          (functions.daysUntilSubscriptionEnds(sub.endDate!) ?? 0) <= 0) {
        appState.isSubscriptionActive = false;
      } else {
        appState.isSubscriptionActive = true;
      }
    } catch (_) {
      appState.isSubscriptionActive = false;
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryText,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logoxpro-01.png',
                width: MediaQuery.sizeOf(context).width * 0.5,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 24),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  FlutterFlowTheme.of(context).primary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Cargando...',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Readex Pro',
                      fontSize: 18,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
