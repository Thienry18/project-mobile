import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PasswordCriteria extends StatelessWidget {
  final bool hasUppercase;
  final bool hasNumber;
  final bool hasMinLength;

  const PasswordCriteria({
    Key? key,
    required this.hasUppercase,
    required this.hasNumber,
    required this.hasMinLength,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCriteriaRow(hasUppercase, 'At least 1 uppercase letter.'),
        _buildCriteriaRow(hasNumber, 'At least 1 number.'),
        _buildCriteriaRow(hasMinLength, 'At least 8 characters.'),
      ],
    );
  }

  Widget _buildCriteriaRow(bool isValid, String text) {
    return Row(
      children: [
        Icon(
          isValid ? Icons.check_circle : Icons.cancel,
          size: 18,
          color: isValid ? Colors.green : const Color(0xff7A8EDA),
        ),
        const SizedBox(width: 5),
        Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 11,
            color: isValid ? Colors.green : const Color(0xff7A8EDA),
          ),
        ),
      ],
    );
  }
}
