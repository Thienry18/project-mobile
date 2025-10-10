import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Onboarding step-1 kamu bernama FavScreen (bukan "Onboarding")
import 'package:projek_mobile/screens/onboarding.dart' show FavScreen;

// Halaman utama aplikasi — di sini aku arahkan ke ExplorePage.
// Ganti ke widget home kamu jika berbeda (mis. HomeRoot, MainTab, dsb).
import 'package:projek_mobile/screens/explore_page.dart';

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
    final prefs = await SharedPreferences.getInstance();
    final flag = prefs.getBool('is_logged_in') ?? false;
    setState(() {
      _loading = false;
      _loggedIn = flag;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_loggedIn) {
      // >>>>>> Halaman utama saat user SUDAH login
      return const ExplorePage(selectedCategory: 'Python');
      // Jika kamu punya widget home lain, ganti baris di atas,
      // mis. return const MainHome();
    }

    // >>>>>> Onboarding step-1 saat user BELUM login
    return const FavScreen();
  }
}
