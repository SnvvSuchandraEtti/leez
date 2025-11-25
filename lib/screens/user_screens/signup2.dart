import 'package:flutter/material.dart';
import 'package:leez/constants/colors.dart';
import 'package:leez/providers/loginprovider.dart';
import 'package:leez/providers/signup2provider.dart';
import 'package:leez/screens/user_screens/login.dart';
import 'package:leez/services/authservice.dart';
import 'package:provider/provider.dart';

class SignUp2 extends StatelessWidget {
  final String name;
  final String email;
  final String phoneNo;

  const SignUp2({
    super.key,
    required this.name,
    required this.email,
    required this.phoneNo,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignUp2Provider(),
      child: SignUp2Screen(name: name, email: email, phoneNo: phoneNo),
    );
  }
}

class SignUp2Screen extends StatefulWidget {
  final String name;
  final String email;
  final String phoneNo;

  const SignUp2Screen({
    super.key,
    required this.name,
    required this.email,
    required this.phoneNo,
  });

  @override
  State<SignUp2Screen> createState() => _SignUp2ScreenState();
}

class _SignUp2ScreenState extends State<SignUp2Screen> {
  final TextEditingController passController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();
  final List<String> otp = List.filled(4, '');
  bool isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SignUp2Provider>(context);
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
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
                    buildStepCircle(2, true),
                    buildStepLine(),
                    buildStepCircle(3, false),
                  ],
                ),
                const SizedBox(height: 32),
                buildPasswordField(
                  "Password",
                  provider.obscurePassword,
                  provider.toggleObscurePassword,
                  passController,
                ),
                const SizedBox(height: 16),
                buildPasswordField(
                  "Confirm Password",
                  provider.obscureConfirmPassword,
                  provider.toggleObscureConfirmPassword,
                  confirmController,
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.info_outline, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'KYC verification will be required after signup',
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  "Verification Code",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  "We have sent the verification code to your email address",
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(4, (index) {
                    return SizedBox(
                      width: 60,
                      height: 60,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 24),
                        decoration: InputDecoration(
                          counterText: '',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onChanged: (value) {
                          if (value.length == 1) {
                            otp[index] = value;
                            if (index < 3) FocusScope.of(context).nextFocus();
                          } else if (value.isEmpty && index > 0) {
                            FocusScope.of(context).previousFocus();
                          }
                        },
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        isSubmitting
                            ? null
                            : () async {
                              setState(() => isSubmitting = true);

                              String enteredOtp = otp.join();
                              try {
                                final authService = AuthService();
                                final res = await authService.verifyOtp(
                                  email: widget.email,
                                  otp: enteredOtp,
                                  phoneNo: widget.phoneNo,
                                  name: widget.name,
                                  password: passController.text.trim(),
                                );
                                print(res);
                                // Navigate to next screen only if OTP is valid
                                if (res['success'] == true) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('${res['message']}'),
                                    ),
                                  );
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Login(),
                                    ),
                                  );
                                }
                              } catch (e) {
                                print("OTP verification error: $e");
                              }

                              setState(() => isSubmitting = false);
                            },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                    ),
                    child:
                        isSubmitting
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
                TextButton(
                  onPressed: () {},
                  child: const Text.rich(
                    TextSpan(
                      text: 'Already have an account?',
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

  Widget buildPasswordField(
    String label,
    bool obscure,
    VoidCallback onToggle,
    TextEditingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: label,
            hintStyle: const TextStyle(color: Colors.black26, fontSize: 15),
            filled: true,
            fillColor: AppColors.primary,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            suffixIcon: IconButton(
              onPressed: onToggle,
              icon: Icon(obscure ? Icons.visibility : Icons.visibility_off),
            ),
          ),
        ),
      ],
    );
  }
}
