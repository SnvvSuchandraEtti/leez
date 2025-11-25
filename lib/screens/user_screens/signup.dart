import 'package:flutter/material.dart';
import 'package:leez/constants/colors.dart';

import 'package:leez/providers/signup1provider.dart';
import 'package:leez/screens/user_screens/login.dart';
import 'package:leez/screens/user_screens/signup2.dart';
import 'package:leez/services/authservice.dart';
import 'package:provider/provider.dart';

class SignUp1 extends StatefulWidget {
  const SignUp1({super.key});

  @override
  State<SignUp1> createState() => _SignUp1State();
}

class _SignUp1State extends State<SignUp1> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SignUpProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/logo/leez_logo.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Create your account",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildStepCircle(1, true),
                      buildStepLine(),
                      buildStepCircle(2, false),
                      buildStepLine(),
                      buildStepCircle(3, false),
                    ],
                  ),
                  const SizedBox(height: 32),
                  buildTextField(
                    "Full Name",
                    "Enter your name",
                    onChanged: provider.setName,
                  ),
                  const SizedBox(height: 16),
                  buildTextField(
                    "Email Address",
                    "Enter your Email",
                    onChanged: provider.setEmail,
                  ),
                  const SizedBox(height: 16),
                  buildTextField(
                    "Phone Number",
                    "Enter your number",
                    onChanged: provider.setPhone,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          provider.isSubmitting
                              ? null
                              : () async {
                                provider.setSubmitting(true); // start loading

                                try {
                                  final authService = AuthService();
                                  final res = await authService.signUpUser(
                                    email: provider.email,
                                    phoneNo: provider.phone,
                                  );

                                  if (res.containsKey('success') &&
                                      res['success'] == true) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('${res['message']}'),
                                      ),
                                    );
                                    // Navigate to next screen
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => SignUp2(
                                              name: provider.name,
                                              email: provider.email,
                                              phoneNo: provider.phone,
                                            ),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          res['message'] ?? 'Signup failed',
                                        ),
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Error: $e')),
                                  );
                                } finally {
                                  provider.setSubmitting(false); // stop loading
                                }
                              },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                      ),
                      child:
                          provider.isSubmitting
                              ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                              : const Text('Submit'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: provider.agree,
                        onChanged: (val) {
                          provider.setAgree(val!);
                        },
                      ),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            text: "By Continuing, you agree to our ",
                            children: [
                              TextSpan(
                                text: "Terms & Conditions",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Login()),
                      );
                    },
                    child: const Text.rich(
                      TextSpan(
                        text: 'Already have an account?',
                        style: TextStyle(color: AppColors.secondary),
                        children: [
                          TextSpan(
                            text: ' Sign in',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
    String label,
    String hint, {
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            fillColor: AppColors.primary,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              // borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildStepCircle(int number, bool isActive) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: isActive ? Colors.black : Colors.grey[300],
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        "$number",
        style: TextStyle(color: isActive ? Colors.white : Colors.black),
      ),
    );
  }

  Widget buildStepLine() {
    return Container(width: 30, height: 2, color: Colors.grey[300]);
  }
}
