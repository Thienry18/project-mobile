import 'package:flutter/material.dart';

class AppTextStyles {
  static final TextStyle heading = TextStyle(
    fontFamily: 'Poppins',
    color: Color(0xff324eaf),
    fontWeight: FontWeight.bold,
    fontSize: 26,
  );

  static final TextStyle subheading = TextStyle(
    fontFamily: 'Poppins',
    color: Color(0xff7A8EDA),
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle body = TextStyle(
    fontFamily: 'Poppins',
    color: Color(0xff97a4d8),
    fontSize: 12,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle link = TextStyle(
    fontFamily: 'Poppins',
    color: Color(0xFF40CE62),
    fontWeight: FontWeight.w700,
    decoration: TextDecoration.underline,
    decorationColor: Colors.green,
  );

  static final TextStyle button = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}
