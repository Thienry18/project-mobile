import 'package:flutter/material.dart';
import 'package:projek_mobile/screens/explore_page.dart';
import 'package:projek_mobile/screens/onboarding.dart';
import 'package:provider/provider.dart';
import 'package:projek_mobile/providers/password_provider.dart';
import 'package:projek_mobile/providers/pin_provider.dart';
import 'package:projek_mobile/providers/profile_image_provider.dart';
import 'package:projek_mobile/providers/theme_provider.dart';
import 'package:projek_mobile/providers/verify_code_provider.dart';

import 'package:projek_mobile/data/explore_repository.dart';
import 'package:projek_mobile/database/database_service.dart';
import 'package:projek_mobile/providers/history_provider.dart';
import 'package:projek_mobile/providers/explore_provider.dart';
import 'package:projek_mobile/data/explore_data.dart' show trendingCourses;

// Note: Auth flow is handled by `lib/data/auth_gate.dart` when used.

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // One-time developer flag: run with
  // flutter run --dart-define=RESET_DB_ONCE=true
  // to reset the app database (app_database.db) before seeding.
  const bool resetDbOnce = bool.fromEnvironment(
    'RESET_DB_ONCE',
    defaultValue: false,
  );
  if (resetDbOnce) {
    try {
      await DatabaseService.instance.resetDatabase();
      // ignore: avoid_print
      print('\u2705 app_database.db reset because RESET_DB_ONCE=true');
    } catch (e) {
      // ignore: avoid_print
      print('Failed to reset database: $e');
    }
  }

  final repo = ExploreRepository();
  await repo.seedIfEmpty(trendingCourses);

  runApp(
    MultiProvider(
      providers: [
        // History notifier - used to notify HistoryScreen when DB changes occur
        ChangeNotifierProvider(create: (_) => HistoryNotifier()),
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
      home: ExplorePage(
        selectedCategory: "all",
      ), // <<<<<< inilah pengganti FavScreen
    );
  }
}
