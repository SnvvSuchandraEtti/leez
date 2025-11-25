import 'package:flutter/material.dart';
import 'package:leez/screens/user_screens/login.dart';
import 'package:leez/screens/user_screens/mainpage.dart';

class OnboardingScreen extends StatefulWidget {
  final bool isLoggedIn;
  const OnboardingScreen({super.key, required this.isLoggedIn});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<Map<String, String>> onboardingData = [
    {
      "title": "Welcome to LEEZ",
      "description": "Seamless renting and hassle-free transactions in one platform.",
      "image": "assets/onboard/onb_1.png"
    },
    {
      "title": "Diverse Rental Categories",
      "description": "Rent anything – cars, furniture, electronics, and more.",
      "image": "assets/onboard/onb_2.png"
    },
    {
      "title": "Verified Listings & Secure Rentals",
      "description": "Browse trusted listings with reviews and rental guarantees.",
      "image": "assets/onboard/onb_3.jpeg"
    },
    {
      "title": "Easy Booking & Payments",
      "description": "Quick booking, flexible durations, and secure payment options.",
      "image": "assets/onboard/onb_4.jpeg"
    },
    {
      "title": "Earn by Renting",
      "description": "List your items and start earning passive income effortlessly.",
      "image": "assets/onboard/onb_5.jpeg"
    },
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextButton(
                  onPressed: () => Navigator.of(context).push(_createRoute()),
                  child: Text(
                    "Skip",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            
            // Page view
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                itemCount: onboardingData.length,
                itemBuilder: (context, index) => buildOnboardingPage(
                  context,
                  onboardingData[index]["title"]!,
                  onboardingData[index]["description"]!,
                  onboardingData[index]["image"]!,
                ),
              ),
            ),
            
            // Page indicator
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  onboardingData.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.only(right: 8),
                    height: 8,
                    width: currentPage == index ? 24 : 8,
                    decoration: BoxDecoration(
                      color: currentPage == index ? Colors.black : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
            
            // Next or Get Started button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    if (currentPage == onboardingData.length - 1) {
                      Navigator.of(context).push(_createRoute());
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    currentPage == onboardingData.length - 1 ? "Get Started" : "Next",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOnboardingPage(BuildContext context, String title, String description, String imageUrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image with cleaner presentation
          Container(
            height: MediaQuery.of(context).size.height * 0.35,
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 40),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          // Title with modern typography
          Text(
            title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: 'Montserrat',
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 16),
          
          // Description with improved readability
          Text(
            description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade700,
              fontFamily: 'Montserrat',
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
           widget.isLoggedIn ? MainPage():Login(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 0.1);
        const end = Offset.zero;
        const curve = Curves.easeOutCubic;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }
}