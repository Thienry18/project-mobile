import 'package:flutter/material.dart';
import 'package:projek_mobile/providers/password_provider.dart';
import 'package:projek_mobile/providers/pin_provider.dart';
import 'package:projek_mobile/providers/verify_code_provider.dart';
import 'package:projek_mobile/screens/build_profile.dart';
import 'package:projek_mobile/screens/interest.dart';
import 'package:projek_mobile/screens/profile.dart';
import 'package:projek_mobile/screens/set_pin.dart';
import 'package:provider/provider.dart';
import 'package:projek_mobile/providers/theme_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => VerifyCodeProvider()),
        ChangeNotifierProvider(create: (_) => SetPinProvider()),
        ChangeNotifierProvider(create: (_) => PasswordProvider()),
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
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
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeNotifier.themeMode,
      home: BuildProfile(),
    );
  }
}
