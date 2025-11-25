import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  bool isLoading = false;
  bool obscurePassword = true; // 👈 New field

  void toggleLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void toggleObscurePassword() { // 👈 New method
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }
}
