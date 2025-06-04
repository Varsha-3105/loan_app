import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
// import 'package:loanapp/views/home_screen.dart';
import 'package:loanapp/views/splash_screen.dart';
import 'package:loanapp/views/onboarding_screen.dart';
import 'package:loanapp/views/selection_screen.dart';
import 'package:loanapp/views/login_screen.dart';
import 'package:loanapp/views/admin_login_screen.dart';
import 'package:loanapp/views/admin_dashboard_screen.dart';
// import 'package:loanapp/views/otp_view.dart';
// import 'views/personal_details_screen.dart';
// import 'model/loan_type_model.dart';
// import 'package:loanapp/screens/personal_loan_details_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  // Initialize Firebase App Check
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.debug,
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/selection': (context) => const SelectionScreen(),
        '/login': (context) => LoginScreen(),
        '/admin_login': (context) => const AdminLoginScreen(),
        '/admin_dashboard': (context) => const AdminDashboardScreen(),
      },
    );
  }
}
