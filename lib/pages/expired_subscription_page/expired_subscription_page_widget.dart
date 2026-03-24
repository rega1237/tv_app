import 'package:cloud_firestore/cloud_firestore.dart';
import '/auth/custom_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'expired_subscription_page_model.dart';
export 'expired_subscription_page_model.dart';

class ExpiredSubscriptionPageWidget extends StatefulWidget {
  const ExpiredSubscriptionPageWidget({super.key});

  static String routeName = 'ExpiredSubscriptionPage';
  static String routePath = '/expiredSubscription';

  @override
  State<ExpiredSubscriptionPageWidget> createState() =>
      _ExpiredSubscriptionPageWidgetState();
}

class _ExpiredSubscriptionPageWidgetState
    extends State<ExpiredSubscriptionPageWidget> {
  late ExpiredSubscriptionPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ExpiredSubscriptionPageModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    final rotationAngle = FFAppState().rotationAngle;
    int quarterTurns = 0;
    if (rotationAngle == 90.0) {
      quarterTurns = 1;
    } else if (rotationAngle == 270.0) {
      quarterTurns = 3;
    }

    final content = Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryText,
      body: SafeArea(
        top: true,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logoxpro-01.png',
                width: MediaQuery.sizeOf(context).width * 0.5,
                fit: BoxFit.contain,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Your subscription has expired.\nContact us via WhatsApp: +1 (301) 532-7560',
                  textAlign: TextAlign.center,
                  style: FlutterFlowTheme.of(context).headlineSmall.override(
                        font: GoogleFonts.interTight(),
                        color: Colors.white,
                      ),
                ),
              ),
              const SizedBox(height: 24),
              FFButtonWidget(
                onPressed: () async {
                  // Acción manual de emergencia por si el stream falla
                  final sucursalRef = FFAppState().loggedSucursal;
                  if (sucursalRef != null) {
                    final subSnap = await FirebaseFirestore.instance
                        .collection('subscription')
                        .where('sucursalRef', isEqualTo: sucursalRef)
                        .get();
                    final doc = subSnap.docs.firstOrNull;
                    if (doc != null) {
                      final data = doc.data();
                      final fieldIsActive = data['isActive'] as bool? ?? true;
                      final endDate = data['endDate'] as Timestamp?;
                      bool isActive = fieldIsActive;
                      if (fieldIsActive && endDate != null) {
                        isActive = endDate.toDate().isAfter(DateTime.now());
                      }
                      
                      FFAppState().isSubscriptionActive = isActive;
                      AppStateNotifier.instance.updateSubscriptionStatus(isActive);
                      
                      if (isActive && context.mounted) {
                        context.goNamed('Inicio');
                      }
                    }
                  }
                },
                text: 'Check Now',
                options: FFButtonOptions(
                  width: 200,
                  height: 44,
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                  iconPadding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                  color: Colors.transparent,
                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        fontFamily: 'Inter Tight',
                        color: const Color(0xFFA1F010),
                        letterSpacing: 0,
                      ),
                  elevation: 0,
                  borderSide: const BorderSide(
                    color: Color(0xFFA1F010),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(height: 16),
              FFButtonWidget(
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: FlutterFlowTheme.of(context).darkGray,
                      title: Text(
                        'Log Out',
                        style: FlutterFlowTheme.of(context).headlineSmall.override(
                              fontFamily: 'Inter Tight',
                              color: Colors.white,
                            ),
                      ),
                      content: Text(
                        'Are you sure you want to log out?',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              color: Colors.white,
                            ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: FlutterFlowTheme.of(context).secondaryText),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text(
                            'Log Out',
                            style: TextStyle(color: Color(0xFFA1F010), fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    GoRouter.of(context).prepareAuthEvent();
                    await authManager.signOut();
                    if (context.mounted) {
                      context.goNamedAuth('login', context.mounted);
                    }
                  }
                },
                text: 'Log Out',
                options: FFButtonOptions(
                  width: 200,
                  height: 44,
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                  iconPadding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                  color: const Color(0xFFA1F010),
                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        fontFamily: 'Inter Tight',
                        color: Colors.black,
                        letterSpacing: 0,
                      ),
                  elevation: 2,
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return quarterTurns != 0
        ? RotatedBox(quarterTurns: quarterTurns, child: content)
        : content;
  }
}
