import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

class LocationHelper {
  static Future<bool> ensurePermission(BuildContext context) async {
    LocationPermission p = await Geolocator.checkPermission();
    if (p == LocationPermission.denied) {
      p = await Geolocator.requestPermission();
    }
    if (p == LocationPermission.deniedForever ||
        p == LocationPermission.denied) {
      // show message
      return false;
    }
    return true;
  }

  static Future<Position?> getCurrentPosition(BuildContext context) async {
    final ok = await ensurePermission(context);
    if (!ok) return null;
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (_) {
      return null;
    }
  }
}
