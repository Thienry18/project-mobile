import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const _kLocaleKey = 'app_locale';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  static const supported = [
    Locale('en'),
    Locale('zh'),
    Locale('ko'),
    Locale('ja'),
    Locale('id'),
    Locale('de'),
  ];

  Future<void> setLocale(Locale l) async {
    if (!supported.contains(l)) return;
    _locale = l;
    notifyListeners();
    await _save(l.languageCode);
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'preferredLanguage': l.languageCode,
        }, SetOptions(merge: true));
      }
    } catch (_) {}
  }

  Future<void> load() async {
    try {
      // Prefer server-side user preference when authenticated
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        try {
          final doc =
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .get();
          final serverCode = doc.data()?['preferredLanguage'] as String?;
          if (serverCode != null && serverCode.isNotEmpty) {
            _locale = Locale(serverCode);
            notifyListeners();
            return;
          }
        } catch (_) {}
      }

      // Fallback to local preference
      final prefs = await SharedPreferences.getInstance();
      final code = prefs.getString(_kLocaleKey) ?? 'en';
      _locale = Locale(code);
      notifyListeners();
    } catch (_) {}
  }

  Future<void> _save(String code) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kLocaleKey, code);
    } catch (_) {}
  }
}
