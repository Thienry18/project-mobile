import 'package:flutter/material.dart';

class VerifyCodeProvider with ChangeNotifier {
  final List<TextEditingController> controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());

  void onCodeChanged(String value, int index, BuildContext context) {
    if (value.isNotEmpty && index < 5) {
      FocusScope.of(context).requestFocus(focusNodes[index + 1]);
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(focusNodes[index - 1]);
    }
    notifyListeners(); // Penting untuk update tombol
  }

  String getCode() {
    return controllers.map((c) => c.text).join();
  }

  bool isCodeComplete() {
    return controllers.every((c) => c.text.isNotEmpty);
  }

  void disposeAll() {
    for (final controller in controllers) {
      controller.dispose();
    }
    for (final node in focusNodes) {
      node.dispose();
    }
  }
}
