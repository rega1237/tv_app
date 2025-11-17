import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Importamos el nuevo widget que hemos creado
import 'pairing_login_widget.dart';
import 'login_model.dart';
export 'login_model.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  static String routeName = 'login';
  static String routePath = '/login';

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  late LoginModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // Mantenemos el modelo para no romper la estructura de FlutterFlow,
    // aunque los textfields ya no se usen.
    _model = createModel(context, () => LoginModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // FFAppState es usado por el PairingLoginWidget para determinar la orientación
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        // Mantenemos el unfocus por si acaso
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryText,
        // El cuerpo del Scaffold ahora es simplemente nuestro nuevo widget.
        // Ya no hay `Builder` ni `if/else` para la orientación, porque
        // el `PairingLoginWidget` maneja eso internamente.
        body: PairingLoginWidget(),
      ),
    );
  }
}