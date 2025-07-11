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

    return LayoutBuilder(
      builder: (context, constraints) {
        final double barWidth = (constraints.maxWidth - (2 * 13)) / 3;

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            return Container(
              height: 5,
              width: barWidth > 0 ? barWidth : 0,
              margin: EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: barColors[index],
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        );
      },
    );
  }
}
