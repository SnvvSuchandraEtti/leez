import 'package:flutter/material.dart';
import 'kyc_AadhaarFrontScreen4.dart';
import 'kyc_VerificationSuccessScreen8.dart'; // <-- or whatever page you want to navigate to

class AddressScreen extends StatelessWidget {
  final String idType;

  AddressScreen({required this.idType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔙 Header
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // 🧾 Title
              Text(
                'Upload ID Proof',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 40),

              // 📂 Add Photo Option
              GestureDetector(
                onTap: () {
                  // 🛣️ Navigate to your image picker or upload page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AadhaarFrontScreen(idType: idType),
                    ),

                  );
                },
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.photo_library, color: Colors.purple),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Add Photos',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.purple,
                          ),
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 16),

              // 📸 Take New Photo Option
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    // MaterialPageRoute(
                    //   builder: (context) => AadhaarFrontScreen(idType: idType),
                    // ),
                    MaterialPageRoute(
                      builder: (context) => VerificationPendingScreen(),
                    ),
                  );
                  // 💡 Later you can navigate to a camera screen here
                  print("TODO: Navigate to camera");
                },
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.camera_alt, color: Colors.blue[600]),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Take New Photo',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.blue[600],
                          ),
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                    ],
                  ),
                ),
              ),

              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
