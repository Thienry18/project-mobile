import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CertificateImageScreen extends StatelessWidget {
  final String imagePath;

  const CertificateImageScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Certificate', style: GoogleFonts.poppins()),
        backgroundColor: const Color(0xFF324EAF),
        foregroundColor: Colors.white,
      ),
      body: Center(child: Image.asset(imagePath, fit: BoxFit.contain)),
    );
  }
}
