import '/backend/backend.dart';
import '/auth/custom_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'inicio_model.dart';
export 'inicio_model.dart';

class InicioWidget extends StatefulWidget {
  const InicioWidget({super.key});

  static String routeName = 'Inicio';
  static String routePath = '/inicio';

  @override
  State<InicioWidget> createState() => _InicioWidgetState();
}

class _InicioWidgetState extends State<InicioWidget> {
  late InicioModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => InicioModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.sucursal = await queryChannelsBranchRecordOnce(
        queryBuilder: (channelsBranchRecord) => channelsBranchRecord.where(
          'branch_ref',
          isEqualTo: FFAppState().loggedSucursal,
        ),
        singleRecord: true,
      ).then((s) => s.firstOrNull);
      _model.channels = await queryChannelsRecordOnce(
        parent: _model.sucursal?.reference,
      );
      FFAppState().channelsData = <dynamic>[];
      safeSetState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return StreamBuilder<SucursalRecord>(
      stream: SucursalRecord.getDocument(FFAppState().loggedSucursal!),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).primaryText,
            body: Center(
              child: SizedBox(
                width: 50.0,
                height: 50.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    FlutterFlowTheme.of(context).primary,
                  ),
                ),
              ),
            ),
          );
        }

        final inicioSucursalRecord = snapshot.data!;

        final mainContent = GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).primaryText,
            body: SafeArea(
              top: true,
              child: Align(
                alignment: AlignmentDirectional(0.0, 0.0),
                child: Padding(
                  padding: EdgeInsets.all(valueOrDefault<double>(
                    FFAppState().rotationAngle != 0.0 ? 20.0 : 40.0,
                    0.0,
                  )),
                  child: StreamBuilder<List<ChannelsBranchRecord>>(
                    stream: queryChannelsBranchRecord(
                      queryBuilder: (channelsBranchRecord) =>
                          channelsBranchRecord.where(
                        'branch_ref',
                        isEqualTo: inicioSucursalRecord.reference,
                      ),
                      singleRecord: true,
                    ),
                    builder: (context, snapshot) {
                      // Customize what your widget looks like when it's loading.
                      if (!snapshot.hasData) {
                        return Center(
                          child: SizedBox(
                            width: 50.0,
                            height: 50.0,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                FlutterFlowTheme.of(context).primary,
                              ),
                            ),
                          ),
                        );
                      }
                      List<ChannelsBranchRecord>
                          containerChannelsBranchRecordList = snapshot.data!;
                      // Return an empty Container when the item does not exist.
                      if (snapshot.data!.isEmpty) {
                        return Container();
                      }
                      final containerChannelsBranchRecord =
                          containerChannelsBranchRecordList.isNotEmpty
                              ? containerChannelsBranchRecordList.first
                              : null;

                      return Container(
                        decoration: BoxDecoration(),
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: StreamBuilder<List<ChannelsRecord>>(
                            stream: queryChannelsRecord(
                              parent: containerChannelsBranchRecord?.reference,
                            ),
                            builder: (context, snapshot) {
                              // Customize what your widget looks like when it's loading.
                              if (!snapshot.hasData) {
                                return Center(
                                  child: SizedBox(
                                    width: 50.0,
                                    height: 50.0,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        FlutterFlowTheme.of(context).primary,
                                      ),
                                    ),
                                  ),
                                );
                              }
                              List<ChannelsRecord>
                                  conditionalBuilderChannelsRecordList =
                                  snapshot.data!;

                              return Builder(
                                builder: (context) {
                                  if (FFAppState().rotationAngle == 0.0) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image.asset(
                                            'assets/images/logoxpro-01.png',
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                0.3,
                                            height: MediaQuery.sizeOf(context)
                                                    .height *
                                                0.2,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        TextButton.icon(
                                          icon: Icon(Icons.screen_rotation_alt_outlined, color: Colors.white),
                                          label: Text('Rotate Screen', style: TextStyle(color: Colors.white)),
                                          onPressed: () {
                                            setState(() {
                                              double currentAngle = FFAppState().rotationAngle;
                                              if (currentAngle == 0.0) {
                                                FFAppState().rotationAngle = 270.0;
                                              } else if (currentAngle == 270.0) {
                                                FFAppState().rotationAngle = 90.0;
                                              } else {
                                                FFAppState().rotationAngle = 0.0;
                                              }
                                            });
                                          },
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(
                                              'Welcome ${inicioSucursalRecord.name}!',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .headlineMedium
                                                  .override(
                                                    font:
                                                        GoogleFonts.interTight(
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .headlineMedium
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .headlineMedium
                                                              .fontStyle,
                                                    ),
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .vividGreen,
                                                    fontSize: 13.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .headlineMedium
                                                            .fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .headlineMedium
                                                            .fontStyle,
                                                  ),
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(
                                                  'Time:',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .headlineMedium
                                                      .override(
                                                        font: GoogleFonts
                                                            .interTight(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .headlineMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .headlineMedium
                                                                  .fontStyle,
                                                        ),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .lightGray,
                                                        fontSize: 13.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .headlineMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .headlineMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                                Text(
                                                  dateTimeFormat("M/d h:mm a",
                                                      getCurrentTimestamp),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .headlineMedium
                                                      .override(
                                                        font: GoogleFonts
                                                            .interTight(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .headlineMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .headlineMedium
                                                                  .fontStyle,
                                                        ),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .vividGreen,
                                                        fontSize: 13.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .headlineMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .headlineMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                              ].divide(SizedBox(width: 5.0)),
                                            ),
                                            StreamBuilder<
                                                List<SubscriptionRecord>>(
                                              stream: querySubscriptionRecord(
                                                queryBuilder:
                                                    (subscriptionRecord) =>
                                                        subscriptionRecord
                                                            .where(
                                                  'sucursalRef',
                                                  isEqualTo:
                                                      inicioSucursalRecord
                                                          .reference,
                                                ),
                                                singleRecord: true,
                                              ),
                                              builder: (context, snapshot) {
                                                // Customize what your widget looks like when it's loading.
                                                if (!snapshot.hasData) {
                                                  return Center(
                                                    child: SizedBox(
                                                      width: 50.0,
                                                      height: 50.0,
                                                      child:
                                                          CircularProgressIndicator(
                                                        valueColor:
                                                            AlwaysStoppedAnimation<
                                                                Color>(
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primary,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }
                                                List<SubscriptionRecord>
                                                    rowSubscriptionRecordList =
                                                    snapshot.data!;
                                                // Return an empty Container when the item does not exist.
                                                if (snapshot.data!.isEmpty) {
                                                  return Container();
                                                }
                                                final rowSubscriptionRecord =
                                                    rowSubscriptionRecordList
                                                            .isNotEmpty
                                                        ? rowSubscriptionRecordList
                                                            .first
                                                        : null;

                                                return Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Text(
                                                      'Days left: ',
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .headlineMedium
                                                              .override(
                                                                font: GoogleFonts
                                                                    .interTight(
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .headlineMedium
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .headlineMedium
                                                                      .fontStyle,
                                                                ),
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .lightGray,
                                                                fontSize: 13.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight: FlutterFlowTheme.of(
                                                                        context)
                                                                    .headlineMedium
                                                                    .fontWeight,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .headlineMedium
                                                                    .fontStyle,
                                                              ),
                                                    ),
                                                    Text(
                                                      '${functions.daysUntilSubscriptionEnds(rowSubscriptionRecord!.endDate!).toString()} Days',
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .headlineMedium
                                                              .override(
                                                                font: GoogleFonts
                                                                    .interTight(
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .headlineMedium
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .headlineMedium
                                                                      .fontStyle,
                                                                ),
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .vividGreen,
                                                                fontSize: 13.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight: FlutterFlowTheme.of(
                                                                        context)
                                                                    .headlineMedium
                                                                    .fontWeight,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .headlineMedium
                                                                    .fontStyle,
                                                              ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                        Flexible(
                                          child: Builder(
                                            builder: (context) {
                                              final horizontalGrid =
                                                  conditionalBuilderChannelsRecordList
                                                      .toList();

                                              return FocusTraversalGroup(
                                                policy:
                                                    OrderedTraversalPolicy(),
                                                child: GridView.builder(
                                                  padding: EdgeInsets.zero,
                                                  gridDelegate:
                                                      SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 2,
                                                    crossAxisSpacing: 10.0,
                                                    mainAxisSpacing: 10.0,
                                                    childAspectRatio: 2.5,
                                                  ),
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  itemCount:
                                                      horizontalGrid.length,
                                                  itemBuilder: (context,
                                                      horizontalGridIndex) {
                                                    final horizontalGridItem =
                                                        horizontalGrid[
                                                            horizontalGridIndex];
                                                    return Container(
                                                      width: MediaQuery.sizeOf(
                                                                  context)
                                                              .width *
                                                          1.0,
                                                      height: MediaQuery.sizeOf(
                                                                  context)
                                                              .height *
                                                          1.0,
                                                      child: custom_widgets
                                                          .FocusableHighlightBox(
                                                        width:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .width *
                                                                1.0,
                                                        height:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .height *
                                                                1.0,
                                                        iconName: 'live_tv',
                                                        iconSize: 50.0,
                                                        textLabel:
                                                            horizontalGridItem
                                                                .name,
                                                        normalColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .darkGreen,
                                                        focusColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .vividGreen,
                                                        textColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .lightGray,
                                                        iconColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .lightGray,
                                                        autofocus: false,
                                                        fontSize: 30.0,
                                                        focusIconTextColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .darkGray,
                                                        rotate:
                                                            horizontalGridItem
                                                                .vertical,
                                                        onTapAction: () async {
                                                          context.pushNamed(
                                                            'PlayerPage',
                                                            queryParameters: {
                                                              'channelRef': serializeParam(
                                                                horizontalGridItem.reference,
                                                                ParamType.DocumentReference,
                                                              ),
                                                            }.withoutNulls,
                                                            extra: <String, dynamic>{
                                                              kTransitionInfoKey:
                                                                  TransitionInfo(
                                                                hasTransition: true,
                                                                transitionType:
                                                                    PageTransitionType
                                                                        .fade,
                                                                duration: Duration(
                                                                    milliseconds:
                                                                        0),
                                                              ),
                                                            },
                                                          );
                                                        },
                                                      ),
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ].divide(SizedBox(height: 5.0)),
                                    );
                                  } else {
                                    final rotationAngle = FFAppState().rotationAngle;
                                    int quarterTurns = 3; // Default to 3 for safety
                                    if (rotationAngle == 90.0) {
                                      quarterTurns = 1;
                                    } else if (rotationAngle == 270.0) {
                                      quarterTurns = 3;
                                    }
                                    return RotatedBox(
                                      quarterTurns: quarterTurns,
                                      child: Container(
                                        width: MediaQuery.sizeOf(context).width * 0.9,
                                        height: MediaQuery.sizeOf(context).height * 0.9,
                                        decoration: BoxDecoration(),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                ClipRRect(
                                                  borderRadius: BorderRadius.circular(8.0),
                                                  child: Image.asset(
                                                    'assets/images/logoxpro-01.png',
                                                    width: MediaQuery.sizeOf(context).width * 0.3,
                                                    height: MediaQuery.sizeOf(context).height * 0.2,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                TextButton.icon(
                                                  icon: Icon(Icons.screen_rotation_alt_outlined, color: Colors.white),
                                                  label: Text('Rotate Screen', style: TextStyle(color: Colors.white)),
                                                  onPressed: () {
                                                    setState(() {
                                                      double currentAngle = FFAppState().rotationAngle;
                                                      if (currentAngle == 0.0) {
                                                        FFAppState().rotationAngle = 270.0;
                                                      } else if (currentAngle == 270.0) {
                                                        FFAppState().rotationAngle = 90.0;
                                                      } else {
                                                        FFAppState().rotationAngle = 0.0;
                                                      }
                                                    });
                                                  },
                                                ),
                                                Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Welcome ${inicioSucursalRecord.name}!',
                                                      style: FlutterFlowTheme.of(context).headlineMedium.override(
                                                            font: GoogleFonts.interTight(
                                                              fontWeight: FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                                                              fontStyle: FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                                                            ),
                                                            color: FlutterFlowTheme.of(context).vividGreen,
                                                            fontSize: 15.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight: FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                                                            fontStyle: FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                                                          ),
                                                    ),
                                                    Row(
                                                      mainAxisSize: MainAxisSize.max,
                                                      children: [
                                                        Text(
                                                          'Time:',
                                                          style: FlutterFlowTheme.of(context).headlineMedium.override(
                                                                font: GoogleFonts.interTight(
                                                                  fontWeight: FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                                                                ),
                                                                color: FlutterFlowTheme.of(context).lightGray,
                                                                fontSize: 15.0,
                                                                letterSpacing: 0.0,
                                                                fontWeight: FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                                                                fontStyle: FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                                                              ),
                                                        ),
                                                                                                                  Text(
                                                                                                                    DateFormat('MMM d h:mm a').format(getCurrentTimestamp),
                                                                                                                    style: FlutterFlowTheme.of(context).headlineMedium.override(
                                                                                                                          font: GoogleFonts.interTight(
                                                                                                                            fontWeight: FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                                                                                                                            fontStyle: FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                                                                                                                          ),
                                                                                                                          color: FlutterFlowTheme.of(context).vividGreen,
                                                                                                                          fontSize: 15.0,
                                                                                                                          letterSpacing: 0.0,
                                                                                                                          fontWeight: FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                                                                                                                          fontStyle: FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                                                                                                                        ),
                                                                                                                  ),                                                      ].divide(SizedBox(width: 5.0)),
                                                    ),
                                                    StreamBuilder<List<SubscriptionRecord>>(
                                                      stream: querySubscriptionRecord(
                                                        queryBuilder: (subscriptionRecord) => subscriptionRecord.where(
                                                          'sucursalRef',
                                                          isEqualTo: inicioSucursalRecord.reference,
                                                        ),
                                                        singleRecord: true,
                                                      ),
                                                      builder: (context, snapshot) {
                                                        // Customize what your widget looks like when it's loading.
                                                        if (!snapshot.hasData) {
                                                          return Center(
                                                            child: SizedBox(
                                                              width: 50.0,
                                                              height: 50.0,
                                                              child: CircularProgressIndicator(
                                                                valueColor: AlwaysStoppedAnimation<Color>(
                                                                  FlutterFlowTheme.of(context).primary,
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        }
                                                        List<SubscriptionRecord> rowSubscriptionRecordList = snapshot.data!;
                                                        // Return an empty Container when the item does not exist.
                                                        if (snapshot.data!.isEmpty) {
                                                          return Container();
                                                        }
                                                        final rowSubscriptionRecord = rowSubscriptionRecordList.isNotEmpty
                                                            ? rowSubscriptionRecordList.first
                                                            : null;

                                                        return Row(
                                                          mainAxisSize: MainAxisSize.max,
                                                          children: [
                                                            Text(
                                                              'Days left: ',
                                                              style: FlutterFlowTheme.of(context).headlineMedium.override(
                                                                    font: GoogleFonts.interTight(
                                                                      fontWeight: FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                                                                    ),
                                                                    color: FlutterFlowTheme.of(context).lightGray,
                                                                    fontSize: 15.0,
                                                                    letterSpacing: 0.0,
                                                                    fontWeight: FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                                                                  ),
                                                            ),
                                                            Text(
                                                              '${functions.daysUntilSubscriptionEnds(rowSubscriptionRecord!.endDate!).toString()} Days',
                                                              style: FlutterFlowTheme.of(context).headlineMedium.override(
                                                                    font: GoogleFonts.interTight(
                                                                      fontWeight: FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                                                                    ),
                                                                    color: FlutterFlowTheme.of(context).vividGreen,
                                                                    fontSize: 15.0,
                                                                    letterSpacing: 0.0,
                                                                    fontWeight: FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                                                                  ),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    ),
                                                  ].divide(SizedBox(width: 20.0)),
                                                ),
                                              ].divide(SizedBox(height: 5.0)),
                                            ),
                                            Expanded(
                                              child: StreamBuilder<List<ChannelsRecord>>(
                                                stream: queryChannelsRecord(
                                                  parent: containerChannelsBranchRecord?.reference,
                                                ),
                                                builder: (context, snapshot) {
                                                  // Customize what your widget looks like when it's loading.
                                                  if (!snapshot.hasData) {
                                                    return Center(
                                                      child: SizedBox(
                                                        width: 50.0,
                                                        height: 50.0,
                                                        child: CircularProgressIndicator(
                                                          valueColor: AlwaysStoppedAnimation<Color>(
                                                            FlutterFlowTheme.of(context).primary,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                  List<ChannelsRecord> containerChannelsRecordList = snapshot.data!;

                                                  return Container(
                                                    decoration: BoxDecoration(),
                                                    child: Container(
                                                      width: MediaQuery.sizeOf(context).width * 0.9,
                                                      height: MediaQuery.sizeOf(context).height * 0.9,
                                                      child: custom_widgets.VerticalFocusGrid(
                                                        width: MediaQuery.sizeOf(context).width * 0.9,
                                                        height: MediaQuery.sizeOf(context).height * 0.9,
                                                        iconSize: 20.0,
                                                        fontSize: 20.0,
                                                        normalColor: FlutterFlowTheme.of(context).darkGreen,
                                                        focusColor: FlutterFlowTheme.of(context).vividGreen,
                                                        textColor: FlutterFlowTheme.of(context).lightGray,
                                                        iconColor: FlutterFlowTheme.of(context).lightGray,
                                                        focusIconTextColor: FlutterFlowTheme.of(context).darkGray,
                                                        crossAxisCount: 2,
                                                        crossAxisSpacing: 10.0,
                                                        mainAxisSpacing: 10.0,
                                                        childAspectRatio: 2.0,
                                                        iconName: 'live_tv',
                                                        items: containerChannelsRecordList,
                                                        onItemTap: (item) async {
                                                          final channelRecord = item as ChannelsRecord?;
                                                          if (channelRecord == null) return;
                                                          context.pushNamed(
                                                            'PlayerPage',
                                                            queryParameters: {
                                                              'channelRef': serializeParam(
                                                                channelRecord.reference,
                                                                ParamType.DocumentReference,
                                                              ),
                                                            }.withoutNulls,
                                                            extra: <String, dynamic>{
                                                              kTransitionInfoKey:
                                                                  TransitionInfo(
                                                                hasTransition: true,
                                                                transitionType:
                                                                    PageTransitionType
                                                                        .fade,
                                                                duration: Duration(
                                                                    milliseconds:
                                                                        0),
                                                              ),
                                                            },
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                },
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );

        return mainContent;
      },
    );
  }
}