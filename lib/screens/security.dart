import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projek_mobile/screens/change_password.dart';
import 'package:projek_mobile/screens/change_pin.dart';
import 'package:projek_mobile/l10n/app_localizations.dart';

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const blueColor = Color(0xFF324EAF);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF324EAF),
        title: Text(
          AppLocalizations.of(context).passwordSecurityTitle,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        leading: const BackButton(color: Colors.white),
      ),
      body: Column(
        children: [
          _buildSecurityItem(
            icon: Icons.pin_outlined,
            title: AppLocalizations.of(context).changePIN,
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ChangePin()),
              );
            },
            titleColor: blueColor,
          ),
          _buildSecurityItem(
            icon: Icons.key_outlined,
            title: AppLocalizations.of(context).changePassword,
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ChangePassword()),
              );
            },
            titleColor: blueColor,
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required Color titleColor,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      leading: Icon(icon, color: Colors.grey[700]),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: titleColor,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
      onTap: onTap,
    );
  }
}
