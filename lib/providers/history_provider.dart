import 'package:flutter/material.dart';

class HistoryNotifier extends ChangeNotifier {
  void notifyUpdated() {
    notifyListeners();
  }
}
