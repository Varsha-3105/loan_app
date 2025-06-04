import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loanapp/views/home_screen.dart'; // Navigate to HomeScreen after registration
// import 'package:get/get.dart'; // If using GetX for state management

class RegistrationController {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void registerUser(BuildContext context) async {
    String username = usernameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    if (username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showSnackbar(context, "Please fill in all fields.");
      return;
    }

    if (password != confirmPassword) {
      _showSnackbar(context, "Passwords do not match.");
      return;
    }

    try {
      // Firebase Authentication - Create User
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        // Save additional user data to Firestore
        await _saveUserData(user.uid, username, email);

        // Show success message and navigate to HomeScreen
        _showSnackbar(context, "Registration successful!");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        _showSnackbar(context, "Registration failed. Please try again.");
      }
    } catch (e) {
      print("Firebase signup error: $e");
      _showSnackbar(context, "Registration failed: ${e.toString()}");
    }
  }

  // Save user data to Firestore
  Future<void> _saveUserData(String uid, String username, String email) async {
    try {
      // Create a user model to save in Firestore
      await _firestore.collection('users').doc(uid).set({
        'username': username,
        'email': email,
        'uid': uid,
        'profileImage': ''
, // Default profile image if you need
      });
      print("User data saved successfully.");
    } catch (e) {
      print("Error saving user data: $e");
    }
  }

  // Show a Snackbar with the given message
  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: Duration(seconds: 2)),
    );
  }
}
