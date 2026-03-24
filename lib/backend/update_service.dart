import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:go_router/go_router.dart';
import '/backend/backend.dart';
import '/components/update_available_dialog.dart';
import '/flutter_flow/nav/nav.dart';

class UpdateService {
  static bool _isDialogShowing = false;
  static const String _storeType =
      String.fromEnvironment('STORE', defaultValue: 'google');

  static Future<void> checkForUpdates({String source = 'Unknown'}) async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;

    // Reset de seguridad si volvemos del fondo para evitar bloqueos
    if (source == 'Resume') {
      _isDialogShowing = false;
    }

    if (_isDialogShowing) {
      debugPrint(
          'UpdateService: Chequeo ignorado ($source) - Diálogo ya visible.');
      return;
    }

    debugPrint('UpdateService: Iniciando chequeo ($source)...');

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
    }

    // 2. Respaldo via Firestore
    try {
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      final int currentBuildNumber = int.parse(packageInfo.buildNumber);
      debugPrint(
          'UpdateService: Versión actual del build: $currentBuildNumber');

      final updateRecords = await queryAppVersionsRecordOnce(
        queryBuilder: (q) =>
            q.where('platform', isEqualTo: 'android_$_storeType'),
        singleRecord: true,
      );

      if (updateRecords.isNotEmpty) {
        final remoteUpdate = updateRecords.first;
        debugPrint(
            'UpdateService: Versión remota en Firestore: ${remoteUpdate.buildNumber}');

        if (remoteUpdate.buildNumber > currentBuildNumber) {
          debugPrint('UpdateService: ¡Nueva versión detectada!');
          _showDialogWhenReady(remoteUpdate);
        } else {
          debugPrint('UpdateService: El app está al día.');
        }
      }
    } catch (e) {
      debugPrint(
          'UpdateService: Error en chequeo de actualización Firestore: $e');
    }
  }

  static void _showDialogWhenReady(AppVersionsRecord remoteUpdate,
      {int retryCount = 0}) {
    if (_isDialogShowing) return;

    if (retryCount > 10) {
      debugPrint('UpdateService: Máximo de reintentos alcanzado. Abortando.');
      _isDialogShowing = false;
      return;
    }

    final context = appNavigatorKey.currentContext;
    if (context == null || !context.mounted) {
      debugPrint(
          'UpdateService: Navegador no listo (Intento $retryCount). Reintentando en 1s...');
      Future.delayed(const Duration(seconds: 1),
          () => _showDialogWhenReady(remoteUpdate, retryCount: retryCount + 1));
      return;
    }

    try {
      final location = GoRouter.of(context).getCurrentLocation();
      debugPrint('UpdateService: Verificando ubicación ($location)...');

      // Si estamos en la raíz o cargando, esperamos a que el router redirija
      if (location == '/' || location.isEmpty) {
        debugPrint(
            'UpdateService: Ubicación transitoria detected. Reintentando en 1s...');
        Future.delayed(
            const Duration(seconds: 1),
            () =>
                _showDialogWhenReady(remoteUpdate, retryCount: retryCount + 1));
        return;
      }
    } catch (e) {
      debugPrint(
          'UpdateService: Error obteniendo ubicación: $e (Intento $retryCount). Reintentando...');
      Future.delayed(const Duration(seconds: 1),
          () => _showDialogWhenReady(remoteUpdate, retryCount: retryCount + 1));
      return;
    }

    debugPrint('UpdateService: Mostrando diálogo en ubicación estable.');
    _isDialogShowing = true;
    showDialog(
      context: context,
      useRootNavigator: true,
      barrierDismissible: !remoteUpdate.forceUpdate,
      builder: (context) => UpdateAvailableDialog(
        latestVersion: remoteUpdate.latestVersion,
        storeUrl: remoteUpdate.storeUrl,
        forceUpdate: remoteUpdate.forceUpdate,
      ),
    ).then((_) {
      _isDialogShowing = false;
      debugPrint('UpdateService: Diálogo cerrado. Estado limpiado.');
    });
  }
}
