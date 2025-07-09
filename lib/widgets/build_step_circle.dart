import 'package:flutter/material.dart';

class BuildStepCircle extends StatelessWidget {
  final bool isActive;

  const BuildStepCircle({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 9,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: isActive ? Colors.green : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
