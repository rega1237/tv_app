import 'dart:io';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:in_app_update/in_app_update.dart';
import '/backend/backend.dart';
import '/components/update_available_dialog.dart';
import '/flutter_flow/nav/nav.dart';

class UpdateService {
  static Future<void> checkForUpdates() async {
    if (!Platform.isAndroid) return;

    debugPrint('UpdateService: Iniciando chequeo de actualizaciones...');

    try {
      // 1. Intentar primero con la API nativa de Google Play
      final info = await InAppUpdate.checkForUpdate();
      debugPrint(
          'UpdateService: Google Play update availability: ${info.updateAvailability}');

      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        debugPrint(
            'UpdateService: Actualización nativa disponible, iniciando actualización inmediata.');
        await InAppUpdate.performImmediateUpdate();
        return;
      }
    } catch (e) {
      debugPrint('UpdateService: Error en In-App Update (Google Play): $e');
      // Si falla (ej: No hay Google Play Services), continuamos con el respaldo de Firestore.
    }

    // 2. Respaldo via Firestore (Para Amazon Fire Stick o si Google Play falla)
    try {
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      final int currentBuildNumber = int.parse(packageInfo.buildNumber);
      debugPrint(
          'UpdateService: Versión actual del build: $currentBuildNumber');

      // Consultamos la colección app_versions para 'android'
      final updateRecords = await queryAppVersionsRecordOnce(
        queryBuilder: (q) => q.where('platform', isEqualTo: 'android'),
        singleRecord: true,
      );

      if (updateRecords.isNotEmpty) {
        final remoteUpdate = updateRecords.first;
        debugPrint(
            'UpdateService: Versión remota en Firestore: ${remoteUpdate.buildNumber}');

        if (remoteUpdate.buildNumber > currentBuildNumber) {
          debugPrint(
              'UpdateService: ¡Nueva versión detectada! Mostrando diálogo.');

          final context = appNavigatorKey.currentContext;
          if (context == null || !context.mounted) {
            debugPrint(
                'UpdateService: Error - El contexto del navegador no está listo o no es válido.');
            return;
          }

          showDialog(
            context: context,
            barrierDismissible: !remoteUpdate.forceUpdate,
            builder: (context) => UpdateAvailableDialog(
              latestVersion: remoteUpdate.latestVersion,
              storeUrl: remoteUpdate.storeUrl,
              forceUpdate: remoteUpdate.forceUpdate,
            ),
          );
        } else {
          debugPrint('UpdateService: El app está al día.');
        }
      } else {
        debugPrint(
            'UpdateService: No se encontró registro de versión para android en Firestore.');
      }
    } catch (e) {
      debugPrint(
          'UpdateService: Error en chequeo de actualización Firestore: $e');
    }
  }
}
