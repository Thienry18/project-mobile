import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class CertificatePDFScreen extends StatelessWidget {
  final String pdfPath; // contoh: 'assets/pdfs/certificate.pdf'

  const CertificatePDFScreen({super.key, required this.pdfPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Certificate'),
        backgroundColor: const Color(0xFF324EAF),
        foregroundColor: Colors.white,
      ),
      body: SfPdfViewer.asset(pdfPath),
    );
  }
}
