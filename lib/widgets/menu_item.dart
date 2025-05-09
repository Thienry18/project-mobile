import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final Color? iconColor;
  final Color? textColor;
  final VoidCallback? onTap;

  const MenuItem({
    Key? key,
    required this.icon,
    required this.title,
    this.trailing,
    this.iconColor,
    this.textColor,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            Icon(
              icon,
              color:
                  iconColor ??
                  (Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : const Color(0xff324eaf)),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color:
                      textColor ??
                      (Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : const Color(0xff324eaf)),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            trailing ??
                Icon(
                  Icons.arrow_forward_rounded,
                  size: 20,
                  color:
                      Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : const Color(0xff324eaf),
                ),
          ],
        ),
      ),
    );
  }
}
