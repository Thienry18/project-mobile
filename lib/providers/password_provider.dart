import 'package:flutter/material.dart';

class PasswordProvider with ChangeNotifier {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool hasUppercase = false;
  bool hasNumber = false;
  bool hasMinLength = false;
  bool passwordsMatch = false;

  bool get hasAnyCriteriaMet => hasUppercase || hasNumber || hasMinLength;

  void onPasswordChanged(String value) {
    hasUppercase = value.contains(RegExp(r'[A-Z]'));
    hasNumber = value.contains(RegExp(r'[0-9]'));
    hasMinLength = value.length >= 8;
    passwordsMatch = value == confirmPasswordController.text;
    notifyListeners();
  }

  void onConfirmPasswordChanged(String value) {
    passwordsMatch = value == passwordController.text;
    notifyListeners();
  }

  String getPasswordStrengthText() {
    if (hasUppercase && hasNumber && hasMinLength) {
      return "Strong password, good to go!";
    } else if ((hasUppercase && hasNumber) ||
        (hasUppercase && hasMinLength) ||
        (hasNumber && hasMinLength)) {
      return "Medium password, consider adding more complexity";
    } else if (hasUppercase || hasNumber || hasMinLength) {
      return "Weak password,must contain :";
    } else {
      return "Very weak password";
    }
  }

  bool get isValid =>
      hasUppercase && hasNumber && hasMinLength && passwordsMatch;

  void disposeAll() {
    passwordController.dispose();
    confirmPasswordController.dispose();
  }
}
