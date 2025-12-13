import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'location_helper.dart';

class PermissionHelper {
  static Future<bool> requestCameraPermission(BuildContext context) async {
    final status = await Permission.camera.status;
    if (status.isGranted) return true;
    final res = await Permission.camera.request();
    if (res.isGranted) return true;
    await _showPermissionDialog(
      context,
      AppLocalizations.of(context).permissionNotGrantedTitle,
      AppLocalizations.of(context).permissionNotGrantedMessage,
    );
    return false;
  }

  static Future<bool> requestStoragePermission(BuildContext context) async {
    if (await Permission.photos.isGranted) return true;
    if (await Permission.storage.isGranted) return true;

    final res = await Permission.photos.request();
    if (res.isGranted) return true;

    final res2 = await Permission.storage.request();
    if (res2.isGranted) return true;

    await _showPermissionDialog(
      context,
      AppLocalizations.of(context).permissionNotGrantedTitle,
      AppLocalizations.of(context).permissionNotGrantedMessage,
    );
    return false;
  }

  static Future<bool> requestNotificationPermission(
    BuildContext context,
  ) async {
    final status = await Permission.notification.status;
    if (status.isGranted) return true;
    final res = await Permission.notification.request();
    if (res.isGranted) return true;
    await _showPermissionDialog(
      context,
      AppLocalizations.of(context).permissionNotGrantedTitle,
      AppLocalizations.of(context).permissionNotGrantedMessage,
    );
    return false;
  }

  static Future<bool> requestLocationPermission(BuildContext context) async {
    return await LocationHelper.ensurePermission(context);
  }

  static Future<void> _showPermissionDialog(
    BuildContext context,
    String title,
    String message,
  ) async {
    final l10n = AppLocalizations.of(context);
    await showDialog<void>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text(l10n.cancel),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(ctx).pop();
                  await openAppSettings();
                },
                child: Text(l10n.openSettings),
              ),
            ],
          ),
    );
  }
}
