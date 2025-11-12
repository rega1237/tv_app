// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:firebase_auth/firebase_auth.dart';

/// Set your action name, define your arguments and return parameter, and then
/// add the boilerplate code using the green button on the right!
Future<bool> signInWithFirebaseCustomToken(String customToken) async {
  try {
    // Verifica si el token no está vacío
    if (customToken == null || customToken.isEmpty) {
      print('Custom token provided is null or empty.');
      return false;
    }

    // Intenta iniciar sesión con el Custom Token usando el SDK de Firebase
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCustomToken(customToken);

    // Verifica si el inicio de sesión fue exitoso y si el UID está disponible
    if (userCredential.user != null && userCredential.user!.uid.isNotEmpty) {
      print(
          'Successfully signed in with Custom Token. UID: ${userCredential.user!.uid}');
      return true; // Éxito
    } else {
      print(
          'Sign in with Custom Token completed, but user or UID is null/empty.');
      return false; // Fallo
    }
  } catch (e) {
    // Captura cualquier error durante el inicio de sesión
    print('Error signing in with Custom Token: $e');
    return false; // Fallo
  }
}
