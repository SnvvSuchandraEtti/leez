import 'package:flutter/material.dart';
import 'package:leez/providers/loginprovider.dart';
import 'package:leez/screens/onboarding/onboarding.dart';
import 'package:leez/screens/onboarding/splash.dart';
import 'package:leez/screens/user_screens/login.dart';
import 'package:leez/screens/user_screens/mainpage.dart';
import 'package:leez/screens/vendor_screens/vendor_home.dart';
import 'package:provider/provider.dart';
import 'package:leez/providers/signup1provider.dart';
import 'package:leez/providers/signup2provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => SignUpProvider()),
        ChangeNotifierProvider(create: (_) => SignUp2Provider()),
      ],
      child: MyApp(isLoggedIn: isLoggedIn),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Leez App',
      home: SplashScreen(isLoggedIn: isLoggedIn),
      // 👇 Override system text scaling
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(1.0), // 1.0 = no scaling
          ),
          child: child!,                  
        );
        
      },
    );
  }
}
