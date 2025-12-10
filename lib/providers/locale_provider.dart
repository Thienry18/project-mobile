import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  void setLocale(Locale l) {
    if (!supported.contains(l)) return;
    _locale = l;
    notifyListeners();
    _save(l.languageCode);
  }

  Future<void> load() async {
    try {
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
