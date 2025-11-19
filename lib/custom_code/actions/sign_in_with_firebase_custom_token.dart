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
import '/auth/custom_auth/auth_util.dart'; // Import auth_util para acceder a authManager

/// This action signs in with a Firebase custom token and then updates the
/// app's custom auth manager to reflect the new session state.
Future<bool> signInWithFirebaseCustomToken(String customToken) async {
  try {
    if (customToken.isEmpty) {
      print('[CustomAction] Custom token provided is empty.');
      return false;
    }

    // Step 1: Sign in to Firebase Auth with the custom token.
    // This authenticates the user with Firebase's backend.
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCustomToken(customToken);

    final user = userCredential.user;

    // Check if the Firebase sign-in was successful.
    if (user != null && user.uid.isNotEmpty) {
      print('[CustomAction] Successfully signed in to Firebase. UID: ${user.uid}');

      // --- THE FIX ---
      // Step 2: Update the app's custom auth manager with the new state.
      // This updates the global `currentUser`, notifies listeners, and persists
      // the session data to SharedPreferences for future app launches.
      await authManager.signIn(
        authenticationToken: customToken,
        authUid: user.uid,
      );
      print('[CustomAction] CustomAuthManager updated successfully.');
      
      return true; // Return true indicating full success.
    } else {
      print('[CustomAction] Firebase sign in completed, but user or UID is null/empty.');
      return false;
    }
  } catch (e) {
    print('[CustomAction] Error in signInWithFirebaseCustomToken: $e');
    // If anything fails, make sure to sign out to prevent inconsistent states.
    await authManager.signOut();
    return false;
  }
}