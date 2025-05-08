import 'package:flutter/material.dart';

class BuildStepCircle extends StatelessWidget {
  final bool isActive;

  const BuildStepCircle({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 127,
      height: 9,
      margin: EdgeInsets.symmetric(horizontal: 7),
      decoration: BoxDecoration(
        color: isActive ? Colors.green : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }
}
