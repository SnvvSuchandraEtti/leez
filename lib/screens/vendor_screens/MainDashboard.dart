import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:leez/constants/colors.dart';
import 'package:leez/screens/suci/product_registration_0.dart';

import 'package:leez/screens/vendor_screens/inbox.dart';
import 'package:leez/screens/vendor_screens/taskday2.dart';
import 'package:leez/screens/vendor_screens/vendor_profile.dart';
import 'addlistingpage.dart';

class MainDashboard extends StatefulWidget {
  @override
  _MainDashboardState createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    DashboardScreen(),
    RentSelectionBottomSheet(),
    ChatLauncherScreen(),
    MenuScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true, // Allows body to extend under the BottomNavigationBar
      body: _pages[_currentIndex],
      bottomNavigationBar: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              border: const Border(
                top: BorderSide(
                  color: Color.fromARGB(255, 255, 255, 255),
                  width: 0.1,
                ),
              ),
            ),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) => setState(() => _currentIndex = index),
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedItemColor: const Color.fromARGB(255, 0, 0, 0),
              unselectedItemColor: const Color.fromARGB(255, 84, 82, 82),
              selectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                letterSpacing: -0.2,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w400,
                letterSpacing: -0.2,
              ),
              showSelectedLabels: true,
              showUnselectedLabels: true,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home_rounded),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.add_circle_outline),
                  activeIcon: Icon(Icons.add_circle),
                  label: "Add",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.mail_outline),
                  activeIcon: Icon(Icons.mail),
                  label: "Inbox",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  activeIcon: Icon(Icons.person),
                  label: "Profile",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
