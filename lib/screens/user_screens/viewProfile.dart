import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:leez/constants/colors.dart';

class Viewprofile extends StatefulWidget {
  final String email;
  final String userName;
  final String imageUrl;
  final String password;
  final String phoneNumber;
  final String customerId;

  const Viewprofile({
    super.key,
    required this.email,
    required this.password,
    required this.userName,
    required this.imageUrl,
    required this.phoneNumber,
    required this.customerId,
  });

  @override
  State<Viewprofile> createState() => _ViewprofileState();
}

class _ViewprofileState extends State<Viewprofile> {
  bool _obscurePassword = true;
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;
  File? imageFile;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.userName);
    _emailController = TextEditingController(text: widget.email);
    _phoneController = TextEditingController(text: widget.phoneNumber);
    _passwordController = TextEditingController(text: widget.password);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );
    if (picked != null) {
      setState(() => imageFile = File(picked.path));
    }
  }

  Future<void> _requestOtpAndUpdateProfile() async {
    final uri = Uri.parse("https://leez-app.onrender.com/api/customer/get-update-otp");
    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": _emailController.text.trim(),
          "phoneNo": _phoneController.text.trim(),
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("OTP sent successfully")));
        String? otp = await _showOtpDialog();
        if (otp != null) await _updateProfile(otp);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to send OTP")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error sending OTP")));
    }
  }

  Future<String?> _showOtpDialog() async {
    final width = MediaQuery.of(context).size.width;
    List<TextEditingController> controllers = List.generate(4, (_) => TextEditingController());
    List<FocusNode> focusNodes = List.generate(4, (_) => FocusNode());
    String? otpResult;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text("Enter 4-digit OTP",
              style: TextStyle(fontSize: width * 0.05, fontWeight: FontWeight.w600)),
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (i) {
                return SizedBox(
                  width: width * 0.13,
                  child: TextField(
                    controller: controllers[i],
                    focusNode: focusNodes[i],
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: width * 0.06, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      counterText: '',
                      contentPadding: EdgeInsets.all(14),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onChanged: (val) {
                      if (val.isNotEmpty) {
                        if (i < 3) {
                          FocusScope.of(dialogContext).requestFocus(focusNodes[i + 1]);
                        } else {
                          FocusScope.of(dialogContext).unfocus();
                        }
                      } else {
                        if (i > 0) {
                          FocusScope.of(dialogContext).requestFocus(focusNodes[i - 1]);
                        }
                      }
                    },
                  ),
                );
              }),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text("Cancel", style: TextStyle(color: Colors.black, fontSize: width * 0.042)),
            ),
            ElevatedButton(
              onPressed: () {
                String otp = controllers.map((c) => c.text).join();
                if (otp.length == 4) {
                  otpResult = otp;
                  Navigator.pop(dialogContext);
                } else {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text("Enter valid 4-digit OTP")));
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: Text("Submit", style: TextStyle(fontSize: width * 0.045)),
            ),
          ],
        );
      },
    );

    return otpResult;
  }

  Future<void> _updateProfile(String otp) async {
    final uri = Uri.parse("https://leez-app.onrender.com/api/customer/update-profile");
    final request = http.MultipartRequest("POST", uri);

    request.fields.addAll({
      'customerId': widget.customerId,
      'email': _emailController.text.trim(),
      'name': _usernameController.text.trim(),
      'phoneNo': _phoneController.text.trim(),
      'password': _passwordController.text.trim(),
      'otp': otp,
    });

    if (imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath('photo', imageFile!.path));
    }

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      _showUpdateResultDialog(response.statusCode == 200);
    } catch (e) {
      _showUpdateResultDialog(false);
    }
  }

  void _showUpdateResultDialog(bool success) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(success ? "Success" : "Failed"),
        content: Text(success ? "Profile updated successfully" : "Profile update failed"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (success) Navigator.pop(context, true);
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool obscure = false,
    VoidCallback? toggleObscure,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
          suffixIcon: toggleObscure != null
              ? IconButton(
                  icon: Icon(obscure ? Icons.visibility_off : Icons.visibility, color: Colors.grey[700]),
                  onPressed: toggleObscure,
                )
              : null,
        ),
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        title: Text("Edit Profile", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(height: 12),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: width * 0.36,
                    height: width * 0.36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: imageFile != null
                            ? FileImage(imageFile!)
                            : NetworkImage(widget.imageUrl) as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                      border: Border.all(color: Colors.grey.shade300, width: 2),
                    ),
                  ),
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: CircleAvatar(
                      backgroundColor: Colors.black,
                      radius: 18,
                      child: IconButton(
                        icon: Icon(Icons.camera_alt, color: Colors.white, size: 18),
                        onPressed: _pickImage,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 28),
              _buildTextField("Username", _usernameController),
              _buildTextField("Email", _emailController),
              _buildTextField("Phone Number", _phoneController),
              _buildTextField("Password", _passwordController,
                  obscure: _obscurePassword,
                  toggleObscure: () => setState(() => _obscurePassword = !_obscurePassword)),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _requestOtpAndUpdateProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 30),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: Text("Update Profile", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
