import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: const String.fromEnvironment('FIREBASE_API_KEY', defaultValue: ''),
            authDomain: const String.fromEnvironment('FIREBASE_AUTH_DOMAIN', defaultValue: ''),
            projectId: const String.fromEnvironment('FIREBASE_PROJECT_ID', defaultValue: ''),
            storageBucket: const String.fromEnvironment('FIREBASE_STORAGE_BUCKET', defaultValue: ''),
            messagingSenderId: const String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID', defaultValue: ''),
            appId: const String.fromEnvironment('FIREBASE_APP_ID', defaultValue: '')));
  } else {
    await Firebase.initializeApp();
  }
}