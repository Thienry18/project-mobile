import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static final TextStyle heading = GoogleFonts.poppins(
    color: Color(0xff324eaf),
    fontWeight: FontWeight.bold,
    fontSize: 26,
  );

  static final TextStyle subheading = GoogleFonts.poppins(
    color: Color(0xff7A8EDA),
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle body = GoogleFonts.poppins(
    color: Color(0xff97a4d8),
    fontSize: 12,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle link = GoogleFonts.poppins(
    color: Colors.green,
    fontWeight: FontWeight.bold,
    decoration: TextDecoration.underline,
    decorationColor: Colors.green,
  );

  static final TextStyle button = GoogleFonts.poppins(
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}
