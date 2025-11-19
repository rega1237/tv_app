import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/custom_code/actions/index.dart';
import '/index.dart';

class PairingLoginWidget extends StatefulWidget {
  const PairingLoginWidget({Key? key}) : super(key: key);

  @override
  _PairingLoginWidgetState createState() => _PairingLoginWidgetState();
}

class _PairingLoginWidgetState extends State<PairingLoginWidget> {
  String? _sessionCode;
  Stream<DocumentSnapshot>? _sessionStream;
  bool _isLoading = true;
  String? _errorMessage;

  final String _linkingUrlBase = 'https://poyecto1592-firemex-sou-t7ugew.web.app/link';

  @override
  void initState() {
    super.initState();
    _createSession();
  }

  Future<void> _createSession() async {
    try {
      final callable =
          FirebaseFunctions.instance.httpsCallable('createPairingSession');
      final result = await callable.call();
      final code = result.data['code'];

      if (mounted) {
        setState(() {
          _sessionCode = code;
          _sessionStream = FirebaseFirestore.instance
              .collection('pairing_sessions')
              .doc(_sessionCode)
              .snapshots();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = "Error creating session. Restart the app.";
        });
      }
    }
  }

  void _handleSessionUpdate(DocumentSnapshot snapshot) async {
    if (!snapshot.exists || !mounted) return;

    final data = snapshot.data() as Map<String, dynamic>;

    if (data['status'] == 'claimed') {
      final authToken = data['authToken'];

      if (authToken != null) {
        setState(() {
          _sessionStream = null; 
          _isLoading = true;
        });

        bool success = await signInWithFirebaseCustomToken(authToken);
        
        if (success) {
          FFAppState().loggedSucursal = FirebaseFirestore.instance
              .collection('sucursal')
              .doc(data['sucursalId']);
          
          safeSetState(() {});

          context.goNamed(InicioWidget.routeName);
        } else {
          if (mounted) {
            setState(() => _errorMessage = "Login with token failed. Try again.");
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Usamos RotatedBox para un manejo de layout correcto en la rotación.
    final rotationAngle = FFAppState().rotationAngle;
    int quarterTurns = 0;
    if (rotationAngle == 90.0) {
      quarterTurns = 1;
    } else if (rotationAngle == 270.0) {
      quarterTurns = 3;
    }

    final content = _buildContent(context);

    // Aplicamos RotatedBox solo si es necesario
    return quarterTurns != 0
        ? RotatedBox(quarterTurns: quarterTurns, child: content)
        : content;
  }

  Widget _buildContent(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryText,
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    FlutterFlowTheme.of(context).info),
              )
            : _errorMessage != null
                ? Text(_errorMessage!,
                    style: TextStyle(color: Colors.red, fontSize: 24))
                : _sessionCode != null
                    ? SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // 1. LOGO AÑADIDO
                            Image.asset(
                              'assets/images/logoxpro-01.png',
                              height: MediaQuery.of(context).size.height * 0.15,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(height: 20),

                            // 2. BOTÓN DE ROTACIÓN QUE USA EL ESTADO GLOBAL
                            // Solo se muestra en modo vertical
                            if (FFAppState().rotationAngle != 0.0)
                              TextButton.icon(
                                icon: Icon(Icons.rotate_90_degrees_ccw, color: Colors.white),
                                label: Text('Rotate', style: TextStyle(color: Colors.white)),
                                onPressed: () {
                                  // Actualizamos el estado global directamente
                                  setState(() {
                                    FFAppState().rotationAngle =
                                        FFAppState().rotationAngle == 90.0 ? 270.0 : 90.0;
                                  });
                                },
                              ),
                            
                            SizedBox(height: 20),

                            Text('Scan the QR or go to:',
                                style:
                                    TextStyle(color: Colors.white, fontSize: 22)),
                            Text(_linkingUrlBase,
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 18)),
                            SizedBox(height: 20),
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: QrImageView(
                                data: '$_linkingUrlBase?code=$_sessionCode',
                                version: QrVersions.auto,
                                size: 200.0,
                              ),
                            ),
                            SizedBox(height: 20),
                            Text('Or enter the code manually:',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 18)),
                            SizedBox(height: 10),
                            Text(
                              _sessionCode!,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 8,
                              ),
                            ),
                            if (_sessionStream != null)
                              StreamBuilder<DocumentSnapshot>(
                                stream: _sessionStream,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.active && snapshot.hasData) {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      if (mounted) {
                                        _handleSessionUpdate(snapshot.data!);
                                      }
                                    });
                                  }
                                  return Container();
                                },
                              ),
                          ],
                        ),
                      )
                    : Text('Could not generate login code.',
                        style: TextStyle(color: Colors.red)),
      ),
    );
  }
}