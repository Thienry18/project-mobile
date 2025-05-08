import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projek_mobile/constants/app_text_style.dart';

class CustomTextField extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final bool obscureText;
  final String obscuringCharacter;
  final Icon? prefixIcon;
  final Icon? suffixIcon;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType keyboardType;
  final bool readOnly;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final int? maxLength;
  final TextAlign textAlign;
  final TextAlignVertical?
  textAlignVertical; // Tambahkan parameter textAlignVertical
  final List<TextInputFormatter>? inputFormatters;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? inputTextStyle;

  const CustomTextField({
    Key? key,
    this.labelText,
    this.hintText,
    this.obscureText = false,
    this.obscuringCharacter = '●',
    this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.focusNode,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
    this.maxLength,
    this.textAlign = TextAlign.start,
    this.textAlignVertical = TextAlignVertical.center, // Default ke tengah
    this.inputFormatters,
    this.contentPadding,
    this.inputTextStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        maxLength: maxLength,
        textAlign: textAlign,
        textAlignVertical: textAlignVertical, // Gunakan textAlignVertical
        readOnly: readOnly,
        onTap: onTap,
        onChanged: onChanged,
        obscureText: obscureText,
        obscuringCharacter: obscuringCharacter,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: AppTextStyles.subheading,
          hintText: hintText,
          counterText: '',
          prefixIcon: prefixIcon != null ? prefixIcon : null,
          suffixIcon: suffixIcon != null ? suffixIcon : null,
          filled: true,
          fillColor: const Color(0xFFE3E8FB),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              contentPadding ??
              const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          hintStyle: AppTextStyles.subheading,
        ),
        style: inputTextStyle ?? AppTextStyles.subheading,
      ),
    );
  }
}
