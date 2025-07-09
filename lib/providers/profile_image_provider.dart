import 'dart:io';
import 'package:flutter/material.dart';

class ProfileImageProvider extends ChangeNotifier {
  File? _imageFile;

  File? get image => _imageFile;

  void setImage(File imageFile) {
    _imageFile = imageFile;
    notifyListeners();
  }
}
