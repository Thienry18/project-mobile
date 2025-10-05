import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Provider yang sudah ada
import 'package:projek_mobile/providers/password_provider.dart';
import 'package:projek_mobile/providers/pin_provider.dart';
import 'package:projek_mobile/providers/profile_image_provider.dart';
import 'package:projek_mobile/providers/theme_provider.dart';
import 'package:projek_mobile/providers/verify_code_provider.dart';

// Halaman awal kamu
import 'package:projek_mobile/screens/onboarding.dart'; // asumsi FavScreen ada di sini

// ==== Tambahan untuk Explore + Sqflite ====
import 'package:projek_mobile/data/explore_repository.dart';
import 'package:projek_mobile/providers/explore_provider.dart';
import 'package:projek_mobile/data/explore_data.dart' show trendingCourses;
// ==========================================

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Seed DB hanya saat kosong
  final repo = ExploreRepository();
  await repo.seedIfEmpty(trendingCourses);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => VerifyCodeProvider()),
        ChangeNotifierProvider(create: (_) => ProfileImageProvider()),
        ChangeNotifierProvider(create: (_) => SetPinProvider()),
        ChangeNotifierProvider(create: (_) => PasswordProvider()),
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),

        // Provider Explore (Sqflite)
        ChangeNotifierProvider(create: (_) => ExploreProvider(repo)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.black,
          selectedItemColor: Color(0xFF324EAF),
          unselectedItemColor: Colors.grey,
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.black,
          selectedItemColor: Color(0xFF324EAF),
          unselectedItemColor: Colors.grey,
        ),
      ),
      themeMode: themeNotifier.themeMode,
      home: FavScreen(), // atau halaman awalmu
    );
  }
}
