// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_util.dart';
// Imports other custom actions
// Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:convert';
import 'package:http/http.dart' as http;

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
Future<dynamic> loginSucursalAction(
  String idManual,
  String passwordManual,
) async {
  // 1. DEFINE TU URL
  final url = Uri.parse('https://loginsucursal-zwjgprz5aq-uc.a.run.app');

  // 2. PREPARA EL CUERPO DE LA PETICIÓN
  final body = jsonEncode({
    'data': {
      'id_manual': idManual,
      'password_manual': passwordManual,
    }
  });

  // 3. REALIZA LA LLAMADA POST
  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        // No hay 'Authorization' header aquí
      },
      body: body,
    );

    // 4. MANEJA LA RESPUESTA
    if (response.statusCode == 200) {
      // Éxito: Decodifica la respuesta JSON y devuélvela
      final responseData = jsonDecode(response.body);
      // 'responseData' será un Map (JSON) que contiene:
      // { "message": "Login exitoso", "sucursalId": "...", "data": {...} }
      return responseData;
    } else {
      // Error (401, 404, 500, etc.)
      return null; // Devuelve null si el login falla
    }
  } catch (e) {
    // Error de red u otra excepción
    return null;
  }
}
