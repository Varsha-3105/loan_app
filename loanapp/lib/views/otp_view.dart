// import 'package:flutter/material.dart';
// import 'package:pinput/pinput.dart';
// import '/views/home_screen.dart';

// class OTPView extends StatefulWidget {
//   const OTPView({super.key});

//   @override
//   _OTPViewState createState() => _OTPViewState();
// }

// class _OTPViewState extends State<OTPView> {
//   final TextEditingController _otpController = TextEditingController();

//   void _verifyOTP(BuildContext context) {
//     if (_otpController.text.length == 4) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => SuccessScreen()),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please enter a valid 4-digit OTP")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 24.0),
//         child: Column(
//           children: [
//             const Spacer(), // Pushes content to center
//             Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Text(
//                   "Enter Verification Code",
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 20),
//                 Image.asset('assets/image/otp_icon.png', height: 100),
//                 const SizedBox(height: 10),
//                 const Text(
//                   "Kindly input the 4-digit code we have sent to",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(color: Colors.grey),
//                 ),
//                 const Text(
//                   "your email ID",
//                   style: TextStyle(
//                     color: Color(0xFF5F5ED2),
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Pinput(
//                   length: 4,
//                   controller: _otpController,
//                   keyboardType: TextInputType.number,
//                 ),
//                 const SizedBox(height: 20),
//                 TextButton(
//                   onPressed: () {},
//                   child: const Text(
//                     "Resend Code",
//                     style: TextStyle(
//                       color: Color(0xFF5F5ED2),
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const Spacer(), // Pushes button to the bottom
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () => _verifyOTP(context),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Color(0xFF5F5ED2),
//                   minimumSize: const Size(double.infinity, 50),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.zero, // Makes it rectangular
//                   ),
//                 ),
//                 child: const Text(
//                   "Proceed",
//                   style: TextStyle(fontSize: 16, color: Colors.white),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 30), // Space from bottom
//           ],
//         ),
//       ),
//     );
//   }
// }

// class SuccessScreen extends StatelessWidget {
//   const SuccessScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 24.0),
//         child: Column(
//           children: [
//             const Spacer(), // Pushes content to center
//             Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Image.asset('assets/image/otp_successIcon.png', height: 100),
//                 const SizedBox(height: 20),
//                 const Text(
//                   "Account Created!",
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 10),
//                 const Text(
//                   "Your account has been created successfully. Click proceed to log in.",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(color: Colors.grey),
//                 ),
//               ],
//             ),
//             const Spacer(), // Pushes the button to the bottom
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {
//                   // Navigate to HomeScreen
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(builder: (context) => HomeScreen()),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Color(0xFF5F5ED2),
//                   minimumSize: const Size(double.infinity, 50),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.zero, // Makes it rectangular
//                   ),
//                 ),
//                 child: const Text(
//                   "Proceed",
//                   style: TextStyle(fontSize: 16, color: Colors.white),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 30), // Provides spacing from bottom edge
//           ],
//         ),
//       ),
//     );
//   }
// }
