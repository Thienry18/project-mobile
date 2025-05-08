import 'package:flutter/material.dart';

class PasswordStrengthBar extends StatelessWidget {
  final List<Color> barColors;
  final bool isVisible;

  const PasswordStrengthBar({
    Key? key,
    required this.barColors,
    required this.isVisible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Container(
          height: 5,
          width: 145,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: barColors[index],
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
