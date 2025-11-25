import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:leez/screens/onboarding/onboarding.dart';
import 'package:leez/screens/user_screens/AccountSettings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'MainDashboard.dart';
import 'edit_profile.dart';

class ProfilePage_user extends StatefulWidget {
  @override
  State<ProfilePage_user> createState() => _ProfilePage_userState();
}

class _ProfilePage_userState extends State<ProfilePage_user> {
  Map<String, dynamic> userData = {
    'name': 'John Doe',
    'email': 'john.doe@example.com',
    'phone': '1234567890',
    'imageUrl': 'https://www.w3schools.com/w3images/avatar2.png',
  };
  String _id = "684feab79fe732f27fbc300b";
  bool isLoading = true;
  String imageUrl = 'https://www.w3schools.com/w3images/avatar2.png';

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    await Future.delayed(Duration(seconds: 1)); // Simulate API delay
    setState(() {
      userData = {
        'name': 'John Smith',
        'email': 'john.smith@example.com',
        'phoneNo': '9876543210',
        'password': 'dummypassword123',
        'imageUrl': 'https://www.w3schools.com/w3images/avatar2.png',
      };
      imageUrl = userData['imageUrl']!;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 0,
        title: Text(
          'Profile',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: width * 0.06,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: height * 0.03),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: width * 0.12,
                              backgroundImage: NetworkImage(imageUrl),
                            ),
                            SizedBox(height: height * 0.01),
                            Text(
                              userData['name'] ?? 'Name not available',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: width * 0.05,
                              ),
                            ),
                            Text(
                              'Guest',
                              style: TextStyle(
                                fontSize: width * 0.04,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.home_outlined, color: Colors.white),
                      label: Text(
                        'Become a host',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: width * 0.045,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: height * 0.02),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    Divider(),

                    // Menu Items
                    _buildMenuItem(
                      context: context,
                      icon: Icons.settings,
                      title: 'Account settings',
                      destination: AccountSettingsPage(),
                    ),
                    _buildMenuItem(
                      context: context,
                      icon: Icons.help_outline,
                      title: 'Get help',
                      destination: AccountSettingsPage(),
                    ),
                    _buildMenuItem(
                      context: context,
                      icon: Icons.person_outline,
                      title: 'View profile',
                      destination: Viewprofile(
                        email: userData['email'],
                        password: userData['password'],
                        userName: userData['name'],
                        imageUrl: imageUrl,
                        phoneNumber: userData['phoneNo'],
                      ),
                    ),
                    _buildMenuItem(
                      context: context,
                      icon: Icons.privacy_tip_outlined,
                      title: 'Privacy',
                      destination: AccountSettingsPage(),
                    ),
                    Divider(),
                    _buildMenuItem(
                      context: context,
                      icon: Icons.group_outlined,
                      title: 'Refer a host',
                      destination: AccountSettingsPage(),
                    ),
                    _buildMenuItem(
                      context: context,
                      icon: Icons.group_add_outlined,
                      title: 'Find a co-host',
                      destination: AccountSettingsPage(),
                    ),
                    _buildMenuItem(
                      context: context,
                      icon: Icons.description_outlined,
                      title: 'Legal',
                      destination: AccountSettingsPage(),
                    ),

                    // Logout Item using onTap
                    _buildMenuItem(
                      context: context,
                      icon: Icons.logout,
                      title: 'Log out',
                      onTap: () async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('isLoggedIn', false);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    OnboardingScreen(isLoggedIn: false),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: height * 0.03),
                  ],
                ),
              ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(width * 0.04),
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MainDashboard()),
            );
          },
          icon: Icon(Icons.sync_alt),
          label: Text(
            "Switch to hosting",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: width * 0.045,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: height * 0.02),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  /// Fixed versatile menu builder
  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    Widget? destination,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, size: 24),
      title: Text(title),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap:
          onTap ??
          () {
            if (destination != null) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => destination),
              );
            }
          },
    );
  }
}
