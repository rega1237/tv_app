import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'orientation_selection_page_model.dart';
export 'orientation_selection_page_model.dart';

class OrientationSelectionPageWidget extends StatefulWidget {
  const OrientationSelectionPageWidget({super.key});

  static String routeName = 'OrientationSelectionPage';
  static String routePath = '/orientationSelectionPage';

  @override
  State<OrientationSelectionPageWidget> createState() =>
      _OrientationSelectionPageWidgetState();
}

class _OrientationSelectionPageWidgetState
    extends State<OrientationSelectionPageWidget> {
  late OrientationSelectionPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OrientationSelectionPageModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryText,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: MediaQuery.sizeOf(context).height * 0.7,
                decoration: BoxDecoration(),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        'assets/images/logoxpro-01.png',
                        height: MediaQuery.sizeOf(context).height * 0.2,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Text(
                      'Welcome to XPRO please select your TV orientation',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.inter(
                              fontWeight: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                            color: FlutterFlowTheme.of(context).vividGreen,
                            fontSize: 20.0,
                            letterSpacing: 0.0,
                            fontWeight: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                    ),
                    Container(
                      width: MediaQuery.sizeOf(context).width * 0.8,
                      decoration: BoxDecoration(),
                      child: FocusTraversalGroup(
                        policy: OrderedTraversalPolicy(),
                        child: Wrap(
                          spacing: 0.0,
                          runSpacing: 0.0,
                          alignment: WrapAlignment.spaceEvenly,
                          crossAxisAlignment: WrapCrossAlignment.start,
                          direction: Axis.horizontal,
                          runAlignment: WrapAlignment.start,
                          verticalDirection: VerticalDirection.down,
                          clipBehavior: Clip.none,
                          children: [
                            FocusTraversalGroup(
                              policy: OrderedTraversalPolicy(),
                              child: FocusTraversalOrder(
                                order: const NumericFocusOrder(1.0),
                                child: FFButtonWidget(
                                  onPressed: () async {
                                    FFAppState().vertical = true;
                                    safeSetState(() {});
                                    await Future.delayed(
                                      Duration(
                                        milliseconds: 100,
                                      ),
                                    );

                                    context.pushNamed(LoginWidget.routeName);
                                  },
                                  text: 'Vertical',
                                  icon: Icon(
                                    Icons.crop_portrait,
                                    size: 40.0,
                                  ),
                                  options: FFButtonOptions(
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.3,
                                    height:
                                        MediaQuery.sizeOf(context).height * 0.3,
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 0.0, 16.0, 0.0),
                                    iconPadding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    color:
                                        FlutterFlowTheme.of(context).darkGreen,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                          font: GoogleFonts.interTight(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .titleSmall
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleSmall
                                                    .fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(context)
                                              .vividGreen,
                                          fontSize: 30.0,
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .titleSmall
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleSmall
                                                  .fontStyle,
                                        ),
                                    elevation: 0.0,
                                    borderRadius: BorderRadius.circular(8.0),
                                    hoverColor:
                                        FlutterFlowTheme.of(context).vividGreen,
                                    hoverTextColor:
                                        FlutterFlowTheme.of(context).darkGreen,
                                    focusBorderSide: BorderSide(
                                      color: FlutterFlowTheme.of(context)
                                          .vividGreen,
                                      width: 4.0,
                                    ),
                                    focusBorderRadius:
                                        BorderRadius.circular(3.0),
                                  ),
                                ),
                              ),
                            ),
                            FocusTraversalGroup(
                              policy: OrderedTraversalPolicy(),
                              child: FocusTraversalOrder(
                                order: const NumericFocusOrder(2.0),
                                child: FFButtonWidget(
                                  onPressed: () async {
                                    FFAppState().vertical = false;
                                    safeSetState(() {});
                                    await Future.delayed(
                                      Duration(
                                        milliseconds: 100,
                                      ),
                                    );

                                    context.pushNamed(LoginWidget.routeName);
                                  },
                                  text: 'Horizontal',
                                  icon: Icon(
                                    Icons.crop_landscape,
                                    size: 40.0,
                                  ),
                                  options: FFButtonOptions(
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.3,
                                    height:
                                        MediaQuery.sizeOf(context).height * 0.3,
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 0.0, 16.0, 0.0),
                                    iconPadding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    color:
                                        FlutterFlowTheme.of(context).darkGreen,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                          font: GoogleFonts.interTight(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .titleSmall
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleSmall
                                                    .fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(context)
                                              .vividGreen,
                                          fontSize: 30.0,
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .titleSmall
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleSmall
                                                  .fontStyle,
                                        ),
                                    elevation: 0.0,
                                    borderRadius: BorderRadius.circular(8.0),
                                    hoverColor:
                                        FlutterFlowTheme.of(context).vividGreen,
                                    hoverTextColor:
                                        FlutterFlowTheme.of(context).darkGreen,
                                    focusBorderSide: BorderSide(
                                      color: FlutterFlowTheme.of(context)
                                          .vividGreen,
                                      width: 4.0,
                                    ),
                                    focusBorderRadius:
                                        BorderRadius.circular(2.0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ].divide(SizedBox(height: 10.0)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
