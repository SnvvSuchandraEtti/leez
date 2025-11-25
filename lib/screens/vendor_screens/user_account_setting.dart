import 'package:flutter/material.dart';

class AccountSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Moved title into body
            Padding(
              padding: EdgeInsets.only(top: height * 0.02, bottom: height * 0.02),
              child: Text(
                'Account Settings',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: width * 0.06,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  _buildSettingItem(
                    icon: Icons.person_outline,
                    title: 'Personal information',
                  ),
                  _buildSettingItem(
                    icon: Icons.shield_outlined,
                    title: 'Login & security',
                  ),
                  _buildSettingItem(
                    icon: Icons.pan_tool_outlined,
                    title: 'Privacy',
                  ),
                  _buildSettingItem(
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                  ),
                  _buildSettingItem(
                    icon: Icons.account_balance_wallet_outlined,
                    title: 'Payments',
                  ),
                  _buildSettingItem(
                    icon: Icons.calculate_outlined,
                    title: 'Taxes',
                  ),
                  _buildSettingItem(
                    icon: Icons.language_outlined,
                    title: 'Translation',
                  ),
                  _buildSettingItem(
                    icon: Icons.work_outline,
                    title: 'Travel for work',
                  ),
                  _buildSettingItem(
                    icon: Icons.settings_accessibility,
                    title: 'Accessibility',
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: height * 0.01, bottom: height * 0.02),
              child: Center(
                child: Text(
                  'Version 25.23 (28011453)',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: width * 0.035,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem({required IconData icon, required String title}) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black),
      onTap: () {
        // Add your navigation or action here
      },
    );
  }
}