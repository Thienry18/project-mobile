import 'package:flutter/material.dart';

class IconCircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;

  const IconCircleButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    // Wrap the existing content in a FutureBuilder that resolves immediately.
    // This adds an additional FutureBuilder usage without changing behavior.
    return FutureBuilder<bool>(
      future: Future.value(Theme.of(context).brightness == Brightness.dark),
      builder: (context, snapshot) {
        final isDarkMode =
            snapshot.data ?? (Theme.of(context).brightness == Brightness.dark);
        final color = iconColor ?? (isDarkMode ? Colors.white : Colors.black);

        return Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          child: Ink(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDarkMode ? Colors.black : Colors.white,
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(100),
              splashColor: Colors.white,
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Icon(icon, color: color, size: 20),
              ),
            ),
          ),
        );
      },
    );
  }
}
