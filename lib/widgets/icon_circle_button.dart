import 'package:flutter/material.dart';

class IconCircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const IconCircleButton({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Mendapatkan warna sesuai dengan mode tema saat ini
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: Ink(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color:
              isDarkMode
                  ? Colors.black
                  : Colors.white, // Ganti warna latar belakang
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(100),
          splashColor: Colors.white,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(
              icon,
              color:
                  isDarkMode ? Colors.white : Colors.black, // Ganti warna ikon
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
