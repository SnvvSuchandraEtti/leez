import 'package:flutter/material.dart';

class SignUpProvider with ChangeNotifier {
  String name = '';
  String email = '';
  String phone = '';
  bool agree = false;
  bool isSubmitting = false;

  void setName(String value) {
    name = value;
    notifyListeners();
  }

  void setEmail(String value) {
    email = value;
    notifyListeners();
  }

  void setPhone(String value) {
    phone = value;
    notifyListeners();
  }

  void setAgree(bool value) {
    agree = value;
    notifyListeners();
  }

  void setSubmitting(bool value) {
    isSubmitting = value;
    notifyListeners();
  }
}
