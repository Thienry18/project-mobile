import 'package:flutter/material.dart';
import 'package:projek_mobile/providers/password_provider.dart';
import 'package:projek_mobile/providers/set_pin_provider.dart';
import 'package:projek_mobile/providers/verify_code_provider.dart';
import 'package:projek_mobile/screens/cart.dart';
import 'package:projek_mobile/screens/explore_page.dart';
import 'package:projek_mobile/screens/favscreen.dart';
import 'package:projek_mobile/screens/interest.dart';
import 'package:projek_mobile/screens/my_course_page.dart';
import 'package:projek_mobile/screens/reset_password.dart';
import 'package:projek_mobile/screens/set_pin.dart';
import 'package:projek_mobile/screens/verify_code.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => VerifyCodeProvider()),
        ChangeNotifierProvider(create: (_) => SetPinProvider()),
        ChangeNotifierProvider(create: (_) => PasswordProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: MyCoursePage());
  }
}
