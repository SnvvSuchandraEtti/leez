import 'package:flutter/material.dart';

class Viewprofile extends StatefulWidget {
  final String email;
  final String userName;
  final String imageUrl;
  final String password;
  final String phoneNumber;

  const Viewprofile({
    super.key,
    required this.email,
    required this.password,
    required this.userName,
    required this.imageUrl,
    required this.phoneNumber,
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: width * 0.06),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.05,
          vertical: height * 0.02,
        ),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: width * 0.18,
                  backgroundImage: NetworkImage(widget.imageUrl),
                ),
                CircleAvatar(
                  backgroundColor: Colors.black,
                  child: IconButton(
                    onPressed: () {
                      // TODO: Handle profile image update
                    },
                    icon: Icon(
                      Icons.camera_enhance_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: height * 0.03),
            _buildTextField(label: "Username", controller: _usernameController),
            SizedBox(height: height * 0.02),
            _buildTextField(label: "Email", controller: _emailController),
            SizedBox(height: height * 0.02),
            _buildTextField(
              label: "Phone Number",
              controller: _phoneController,
            ),
            SizedBox(height: height * 0.02),
            _buildPasswordField(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          SizedBox(height: 4),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Password",
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
          SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              _showOtpDialog();
            },
            child: Text("Edit", style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  void _showOtpDialog() {
    List<TextEditingController> otpControllers = List.generate(
      4,
      (index) => TextEditingController(),
    );
    List<FocusNode> focusNodes = List.generate(4, (index) => FocusNode());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Enter 4-digit OTP"),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(4, (index) {
              return SizedBox(
                width: 40,
                child: TextField(
                  controller: otpControllers[index],
                  focusNode: focusNodes[index],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 1,
                  decoration: InputDecoration(
                    counterText: '',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      if (index < 3) {
                        focusNodes[index + 1].requestFocus();
                      } else {
                        focusNodes[index].unfocus();
                      }
                    } else {
                      if (index > 0) {
                        focusNodes[index - 1].requestFocus();
                      }
                    }
                  },
                ),
              );
            }),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                String otp = otpControllers.map((c) => c.text).join();
                if (otp.length == 4 &&
                    otp.runes.every((r) => r >= 48 && r <= 57)) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("OTP submitted: $otp")),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please enter a valid 4-digit OTP")),
                  );
                }
              },
              child: Text("Submit"),
            ),
          ],
        );
      },
    );
  }
}
