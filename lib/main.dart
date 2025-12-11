import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:projek_mobile/data/auth_gate.dart';
import 'package:projek_mobile/screens/database_test_screen.dart';
=======
>>>>>>> be7823f0cb885709fde4a5a2246c8ccdb8d51f57
import 'package:provider/provider.dart';
import 'package:projek_mobile/providers/locale_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
import 'package:projek_mobile/data/auth_gate.dart';
import 'package:firebase_core/firebase_core.dart';

// Note: Auth flow is handled by `lib/data/auth_gate.dart` when used.

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final analytics = FirebaseAnalytics.instance;
  await analytics.logAppOpen();

  // Note: do not reset the database on every startup. Use the
  // RESET_DB_ONCE dart-define to trigger a one-time reset when needed.

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

  // Ensure the app database is opened and tables are created before the
  // UI starts. This reduces the chance of long DB operations happening
  // concurrently with user interactions (like Sign Up).
  try {
    await DatabaseService.instance.database;
    // ignore: avoid_print
    print('DatabaseService: database opened at startup');
  } catch (e) {
    // ignore: avoid_print
    print('DatabaseService: failed to open database at startup: $e');
  }

  // Prepare theme notifier and load saved pref before runApp
  final themeNotifier = ThemeNotifier();
  await themeNotifier.loadTheme();
  final localeProvider = LocaleProvider();
  await localeProvider.load();

  runApp(
    MultiProvider(
      providers: [
        // History notifier - used to notify HistoryScreen when DB changes occur
        ChangeNotifierProvider(create: (_) => HistoryNotifier()),
        ChangeNotifierProvider(create: (_) => VerifyCodeProvider()),
        ChangeNotifierProvider(create: (_) => ProfileImageProvider()),
        ChangeNotifierProvider(create: (_) => SetPinProvider()),
        ChangeNotifierProvider(create: (_) => PasswordProvider()),
        // Provide the pre-loaded ThemeNotifier instance so startup theme is correct
        ChangeNotifierProvider<ThemeNotifier>.value(value: themeNotifier),
        ChangeNotifierProvider<LocaleProvider>.value(value: localeProvider),
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
    final localeProvider = Provider.of<LocaleProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: localeProvider.locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      localeResolutionCallback: (locale, supportedLocales) {
        if (locale == null) return supportedLocales.first;
        for (var s in supportedLocales) {
          if (s.languageCode == locale.languageCode) return s;
        }
        return supportedLocales.first;
      },
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
      home: const AuthGate(),
    );
  }
}
