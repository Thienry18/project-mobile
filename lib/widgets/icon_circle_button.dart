import 'package:flutter/material.dart';

class IconCircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const IconCircleButton({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: Ink(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFFE0ECFF),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(100),
          splashColor: const Color(0xFF324EAF),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(icon, color: const Color(0xFF324EAF), size: 20),
          ),
        ),
      ),
    );
  }
}
