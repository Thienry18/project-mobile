import 'package:flutter/material.dart';
import 'package:projek_mobile/data/auth_gate.dart';
import 'package:provider/provider.dart';
import 'package:projek_mobile/providers/password_provider.dart';
import 'package:projek_mobile/providers/pin_provider.dart';
import 'package:projek_mobile/providers/profile_image_provider.dart';
import 'package:projek_mobile/providers/theme_provider.dart';
import 'package:projek_mobile/providers/verify_code_provider.dart';

import 'package:projek_mobile/data/explore_repository.dart';
import 'package:projek_mobile/providers/explore_provider.dart';
import 'package:projek_mobile/data/explore_data.dart' show trendingCourses;

import 'package:projek_mobile/data/auth_gate.dart'; // <-- pakai AuthGate

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
      home: const AuthGate(), // <<<<<< inilah pengganti FavScreen
    );
  }
}
