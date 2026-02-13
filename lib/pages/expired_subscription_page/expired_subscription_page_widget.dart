import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
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
