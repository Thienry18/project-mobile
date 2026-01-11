import 'package:flutter/material.dart';

class SetPinProvider with ChangeNotifier {
  final List<TextEditingController> pinControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  final List<FocusNode> pinFocusNodes = List.generate(
    4,
    (index) => FocusNode(),
  );

  bool isPinComplete() {
    return pinControllers.every((c) => c.text.isNotEmpty);
  }

  void onPinChanged(String value, int index, BuildContext context) {
    if (value.isNotEmpty && index < 3) {
      FocusScope.of(context).requestFocus(pinFocusNodes[index + 1]);
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(pinFocusNodes[index - 1]);
    }
    notifyListeners();
  }

  /// Clear all pin fields and unfocus nodes, notifying listeners.
  void clearAll() {
    for (final c in pinControllers) {
      c.clear();
    }
    for (final n in pinFocusNodes) {
      n.unfocus();
    }
    notifyListeners();
  }

  String getPin() {
    return pinControllers.map((c) => c.text).join();
  }

  void disposeAll() {
    for (final controller in pinControllers) {
      controller.dispose();
    }
    for (final node in pinFocusNodes) {
      node.dispose();
    }
  }
}
