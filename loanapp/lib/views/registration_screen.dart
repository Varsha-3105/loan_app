import 'package:flutter/material.dart';
import 'package:loanapp/views/login_screen.dart';
import '../controllers/registration_controller.dart';

class RegistrationScreen extends StatelessWidget {
  final RegistrationController controller = RegistrationController();

  RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 50,
                ),
                child: Column(
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/image/splash_icon.png',
                        height: 100,
                      ),
                    ),
                    const SizedBox(height: 50),
                    const Text(
                      "Register",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      "Create your account",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(controller.usernameController, "Username"),
                    const SizedBox(height: 15),
                    _buildTextField(controller.emailController, "Email"),
                    const SizedBox(height: 15),
                    _buildTextField(
                      controller.passwordController,
                      "Password",
                      isPassword: true,
                    ),
                    const SizedBox(height: 15),
                    _buildTextField(
                      controller.confirmPasswordController,
                      "Confirm Password",
                      isPassword: true,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: ElevatedButton(
                onPressed: () => controller.registerUser(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF5F5ED2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  "Submit",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 15),
            GestureDetector(
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  ),
              child: const Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Text.rich(
                  TextSpan(
                    text: "Already have an account? ",
                    style: TextStyle(color: Colors.black54),
                    children: [
                      TextSpan(
                        text: "LOGIN",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
