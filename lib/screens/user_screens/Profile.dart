import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:leez/screens/onboarding/onboarding.dart';
import 'package:leez/screens/user_screens/AccountSettings.dart';
import 'package:leez/screens/user_screens/getHelp.dart';
import 'package:leez/screens/user_screens/viewProfile.dart';
import 'package:leez/screens/vendor_screens/MainDashboard.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic> userData = {};
  String _id = "6858ed546ab8ecdbc9264c2e";
  bool isLoading = true;
  String imageUrl = 'https://www.w3schools.com/w3images/avatar2.png';

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    Uri uri = Uri.parse(
      "https://leez-app.onrender.com/api/customer/get-customer-details/$_id",
    );
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          userData = data['Customer-details'] ?? {};
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildProfileHeader(size),
                      const SizedBox(height: 24),
                      _buildSectionTitle("Account"),
                      const SizedBox(height: 8),
                      _buildMenuCard(
                        icon: Icons.settings,
                        title: "Account Settings",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AccountSettingsPage(),
                            ),
                          );
                        },
                      ),
                      _buildMenuCard(
                        icon: Icons.help_outline,
                        title: "Get Help",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Gethelp(),
                            ),
                          );
                        },
                      ),
                      _buildViewProfileCard(context),
                      _buildMenuCard(
                        icon: Icons.privacy_tip_outlined,
                        title: "Privacy",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AccountSettingsPage(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      _buildSectionTitle("Community"),
                      const SizedBox(height: 8),
                      _buildMenuCard(
                        icon: Icons.group_outlined,
                        title: "Refer a host",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AccountSettingsPage(),
                            ),
                          );
                        },
                      ),
                      _buildMenuCard(
                        icon: Icons.group_add_outlined,
                        title: "Find a co-host",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AccountSettingsPage(),
                            ),
                          );
                        },
                      ),
                      _buildMenuCard(
                        icon: Icons.description_outlined,
                        title: "Legal",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AccountSettingsPage(),
                            ),
                          );
                        },
                      ),
                      _buildMenuCard(
                        icon: Icons.logout,
                        title: "Log out",
                        onTap: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.setBool('isLoggedIn', false);

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      const OnboardingScreen(isLoggedIn: false),
                            ),
                            (route) => false, // remove all previous routes
                          );
                        },
                      ),
                      const SizedBox(height: 36),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MainDashboard(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.sync_alt, size: 22),
                          label: const Text(
                            "Switch to hosting",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }

  Widget _buildProfileHeader(Size size) {
    final double avatarSize = size.width * 0.32;
    final String avatarUrl =
        userData['photo'] != null
            ? "https://res.cloudinary.com/dyigkc2zy/image/upload/v1750151597/${userData['photo']}"
            : imageUrl;

    return Card(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        child: Column(
          children: [
            CircleAvatar(
              radius: avatarSize / 2,
              backgroundImage: NetworkImage(avatarUrl),
              backgroundColor: Colors.grey.shade200,
            ),
            const SizedBox(height: 16),
            Text(
              userData['name']?.toString() ?? 'Name not available',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Text(
              "Guest",
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildMenuCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 24, color: Colors.black),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildViewProfileCard(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => Viewprofile(
                  email: userData['email'],
                  password: userData['password'],
                  userName: userData['name'],
                  imageUrl:
                      "https://res.cloudinary.com/dyigkc2zy/image/upload/v1750151597/${userData['photo']}",
                  phoneNumber: userData['phoneNo'],
                  customerId: userData['_id'],
                ),
          ),
        );
        if (result == true) {
          loadProfile();
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: const [
            Icon(Icons.person_outline, size: 24, color: Colors.black),
            SizedBox(width: 14),
            Expanded(
              child: Text(
                "View/Edit profile",
                style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w500),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
