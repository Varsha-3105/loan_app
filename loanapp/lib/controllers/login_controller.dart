import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
 // import '../model/user_model.dart';
import '../views/home_screen.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class LoginController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> login(BuildContext context) async {
  String email = emailController.text.trim();
  String password = passwordController.text.trim();

  if (email.isNotEmpty && password.isNotEmpty) {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Extract username from email (temporary solution)
      String username = email.split('@')[0]; // "john.doe@gmail.com" => "john.doe"

      // Set username in HomeController
      Get.put(HomeController()).setUsername(username);

      // Navigate to HomeScreen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );

      return true;

    } on FirebaseAuthException catch (e) {
      print("Login Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed: ${e.message}")),
      );
      return false;
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please enter email and password")),
    );
    return false;
  }
}

}
