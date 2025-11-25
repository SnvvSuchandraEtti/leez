import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:leez/screens/suci/product_registration_2.dart';


class LeezOnboardingScreen1 extends StatelessWidget {
  const LeezOnboardingScreen1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 24,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Text(
              "It's easy to get started on\nLeez",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: Colors.black,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 48),
            
            // Step 1
_buildStep(
  number: "1",
  title: "Choose what you want to rent",
  description: "Select the category of your item and give us basic info like item type and condition.",
  icon: Icons.category_outlined,
  iconColor: Colors.deepPurple,
),

const SizedBox(height: 32),

// Step 2
_buildStep(
  number: "2",
  title: "Add photos and details",
  description: "Upload images, write a short title and description, and set item availability.",
  icon: Icons.photo_library_outlined,
  iconColor: Colors.teal,
),

const SizedBox(height: 32),

// Step 3
_buildStep(
  number: "3",
  title: "Set price and publish",
  description: "Enter the rental price, confirm your location, and publish your listing to go live.",
  icon: Icons.attach_money_outlined,
  iconColor: Colors.orange,
),

            
            const Spacer(),
            
            // Get started button
SizedBox(
  width: double.infinity,
  height: 52,
  child: ElevatedButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LocationScreen()),
      );
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0), // Leez black
      foregroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    child: const Text(
      "Get started",
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
),

            
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStep({
    required String number,
    required String title,
    required String description,
    required IconData icon,
    required Color iconColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Step number
        Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        
        const SizedBox(width: 16),
        
        // Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(width: 16),
        
        // Icon
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 24,
          ),
        ),
      ],
    );
  }
}

