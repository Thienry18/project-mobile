import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ToggleItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool value;
  final Function(bool) onChanged;

  const ToggleItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Icon(
            icon,
            color:
                Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : const Color(0xff324eaf),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color:
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : const Color(0xff324eaf),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
