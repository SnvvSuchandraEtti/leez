import 'package:flutter/material.dart';
import 'package:leez/constants/colors.dart';
import 'package:leez/providers/loginprovider.dart';
import 'package:leez/screens/user_screens/mainpage.dart';
import 'package:leez/screens/user_screens/signup.dart';
import 'package:leez/services/authservice.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LoginProvider>(context);
    final emailController = provider.emailController;
    final passController = provider.passController;
    final isLoading = provider.isLoading;

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 100),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/logo/leez_logo.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Text(
                  'Welcome back to the leez connect',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                const SizedBox(height: 30),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Email or Phone",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            hintText: 'Enter your email or phone',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Password",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: passController,
                          obscureText: provider.obscurePassword,
                          decoration: InputDecoration(
                            hintText: 'Enter your password',
                            suffixIcon: IconButton(
                              icon: Icon(
                                provider.obscurePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: provider.toggleObscurePassword,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Checkbox(value: false, onChanged: (v) {}),
                            const Text("Remember me"),
                            const Spacer(),
                            TextButton(
                              onPressed: () {},
                              child: const Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  color: AppColors.secondary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed:
                                isLoading
                                    ? null
                                    : () async {
                                      provider.toggleLoading(true);
                                      try {
                                        final authService = AuthService();
                                        final res = await authService.login(
                                          email: emailController.text.trim(),
                                          password: passController.text.trim(),
                                        );

                                        if (res.containsKey('success') &&
                                            res['success'] == true) {
                                          final prefs =
                                              await SharedPreferences.getInstance();
                                          await prefs.setBool(
                                            'isLoggedIn',
                                            true,
                                          );

                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                '${res['message']}',
                                              ),
                                            ),
                                          );

                                          // ✅ Clear fields after login
                                          emailController.clear();
                                          passController.clear();

                                          Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) => const MainPage(),
                                            ),
                                            (route) => false,
                                          );
                                        } else {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                res['message'] ??
                                                    'Login failed',
                                              ),
                                            ),
                                          );
                                        }
                                      } catch (e) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(content: Text('$e')),
                                        );
                                      }
                                      provider.toggleLoading(false);
                                    },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child:
                                isLoading
                                    ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                    : const Text(
                                      "Log In",
                                      style: TextStyle(color: Colors.white),
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: TextStyle(color: AppColors.secondary),
                        textScaler: TextScaler.linear(1.0),
                      ),
                      TextButton(
                        onPressed: () {
                          // ✅ Clear fields before signup navigation
                          emailController.clear();
                          passController.clear();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUp1(),
                            ),
                          );
                        },
                        child: const Text(
                          textScaler: TextScaler.linear(1.0),
                          "Sign up",
                          style: TextStyle(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
