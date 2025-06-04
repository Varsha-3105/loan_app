// import 'dart:async';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:loanapp/views/login_screen.dart'; // or your home screen

// class EmailVerificationScreen extends StatefulWidget {
//   const EmailVerificationScreen({Key? key}) : super(key: key);

//   @override
//   State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
// }

// class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
//   bool isEmailVerified = false;
//   bool canResendEmail = false;
//   Timer? timer;

//   @override
//   void initState() {
//     super.initState();

//     // Start periodic checking
//     isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

//     if (!isEmailVerified) {
//       sendVerificationEmail();

//       timer = Timer.periodic(
//         const Duration(seconds: 5),
//         (_) => checkEmailVerified(),
//       );
//     }
//   }

//   Future<void> sendVerificationEmail() async {
//     try {
//       final user = FirebaseAuth.instance.currentUser!;
//       await user.sendEmailVerification();
//       setState(() => canResendEmail = false);
//       await Future.delayed(const Duration(seconds: 5));
//       setState(() => canResendEmail = true);
//     } catch (e) {
//       print('Error sending email verification: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to send verification email.')),
//       );
//     }
//   }

//   Future<void> checkEmailVerified() async {
//     await FirebaseAuth.instance.currentUser!.reload();
//     setState(() {
//       isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
//     });

//     if (isEmailVerified) timer?.cancel();
//   }

//   @override
//   void dispose() {
//     timer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) => isEmailVerified
//       ? const LoginView() // Or your home screen after successful verification
//       : Scaffold(
//           appBar: AppBar(title: const Text('Verify your email')),
//           body: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text(
//                   'A verification email has been sent. Please check your inbox.',
//                   style: TextStyle(fontSize: 16),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 24),
//                 ElevatedButton.icon(
//                   onPressed: canResendEmail ? sendVerificationEmail : null,
//                   icon: const Icon(Icons.email),
//                   label: const Text('Resend Email'),
//                 ),
//                 const SizedBox(height: 8),
//                 TextButton(
//                   onPressed: () => FirebaseAuth.instance.signOut().then((_) {
//                     Navigator.of(context).pushReplacement(
//                       MaterialPageRoute(builder: (_) => const LoginView()),
//                     );
//                   }),
//                   child: const Text('Cancel'),
//                 )
//               ],
//             ),
//           ),
//         );
// }
