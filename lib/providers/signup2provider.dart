import 'package:flutter/material.dart';

class SignUp2Provider extends ChangeNotifier {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  bool get obscurePassword => _obscurePassword;
  bool get obscureConfirmPassword => _obscureConfirmPassword;

  void toggleObscurePassword() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void toggleObscureConfirmPassword() {
    _obscureConfirmPassword = !_obscureConfirmPassword;
    notifyListeners();
  }
}
