import 'package:flutter/material.dart';
import 'package:leez/screens/user_screens/mainpage.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  Widget buildMenuItem({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    Widget? leading,
  }) {
    return ListTile(
      leading: leading ?? Icon(icon, size: 26),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.05),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: height * 0.02),
                Text(
                  "Menu",
                  style: TextStyle(
                    fontSize: width * 0.08,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: height * 0.03),
                Text(
                  "HOSTING",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                buildMenuItem(
                  icon: Icons.account_balance_wallet,
                  title: 'Earnings',
                ),
                buildMenuItem(icon: Icons.bar_chart, title: 'Insights'),
                buildMenuItem(
                  icon: Icons.menu_book_outlined,
                  title: 'Guidebooks',
                ),
                buildMenuItem(
                  icon: Icons.add_box_outlined,
                  title: 'Create a new listing',
                ),
                buildMenuItem(
                  icon: Icons.group_add_outlined,
                  title: 'Find a co-host',
                ),
                const Divider(),
                Text(
                  "ACCOUNT",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                buildMenuItem(
                  title: 'Your profile',
                  icon: Icons.person,
                  leading: const CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage(
                      'https://www.w3schools.com/w3images/avatar2.png',
                    ),
                  ),
                ),
                buildMenuItem(icon: Icons.settings, title: 'Settings'),
                buildMenuItem(
                  icon: Icons.help_outline,
                  title: 'Visit the Help Centre',
                ),
                buildMenuItem(
                  icon: Icons.shield_outlined,
                  title: 'Get help with a safety issue',
                ),
                buildMenuItem(
                  icon: Icons.library_books_outlined,
                  title: 'Explore hosting resources',
                ),
                buildMenuItem(
                  icon: Icons.group_outlined,
                  title: 'Connect with Hosts near you',
                ),
                buildMenuItem(
                  icon: Icons.edit_outlined,
                  title: 'Give us feedback',
                ),
                buildMenuItem(
                  icon: Icons.share_outlined,
                  title: 'Refer a host',
                ),
                const Divider(),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Log out",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text("Terms of Service"),
                    Text(" · "),
                    Text("Privacy Policy"),
                  ],
                ),
                const SizedBox(height: 4),
                Center(
                  child: Text(
                    "Version 25.23 (28011453)",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MainPage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.swap_horiz, color: Colors.white),
                    label: const Text(
                      "Switch to travelling",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: width * 0.15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
