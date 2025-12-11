import 'package:flutter/material.dart';
import 'package:projek_mobile/screens/auth/sign_in.dart';
// database imports not required here; AuthGate uses SharedPreferences
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projek_mobile/screens/input_pin.dart';

// Onboarding step-1 kamu bernama FavScreen (bukan "Onboarding")
import 'package:projek_mobile/screens/onboarding.dart' show FavScreen;

// Halaman utama aplikasi — di sini aku arahkan ke ExplorePage.
// Ganti ke widget home kamu jika berbeda (mis. HomeRoot, MainTab, dsb).
// explore_page not needed here

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _loading = true;
  bool _loggedIn = false;

  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLogged = prefs.getBool('is_logged_in') ?? false;
      setState(() {
        _loading = false;
        _loggedIn = isLogged;
      });
    } catch (e) {
      // fail safe: consider not logged in
      setState(() {
        _loading = false;
        _loggedIn = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_loggedIn) {
      // Jika sudah login, minta PIN terlebih dahulu
      return const SignIn();
    }

    // Jika belum login, tampilkan onboarding/landing (FavScreen)
    return const FavScreen();
  }
}
