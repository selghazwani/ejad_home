// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class PhoneAuthScreen extends StatefulWidget {
//   @override
//   _PhoneAuthScreenState createState() => _PhoneAuthScreenState();
// }

// class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _otpController = TextEditingController();

//   String? _verificationId;
//   bool _otpSent = false;

//   Future<void> _verifyPhoneNumber() async {
//     try {
//       await _auth.verifyPhoneNumber(
//         phoneNumber: _phoneController.text,
//         verificationCompleted: (PhoneAuthCredential credential) async {
//           await _auth.signInWithCredential(credential);
//           _showMessage('Successfully signed in');
//         },
//         verificationFailed: (FirebaseAuthException e) {
//           _showMessage('Verification failed: ${e.message}');
//         },
//         codeSent: (String verificationId, int? resendToken) {
//           setState(() {
//             _verificationId = verificationId;
//             _otpSent = true;
//           });
//         },
//         codeAutoRetrievalTimeout: (String verificationId) {
//           _verificationId = verificationId;
//         },
//       );
//     } catch (e) {
//       _showMessage('Error: $e');
//     }
//   }

//   Future<void> _signInWithOTP() async {
//     try {
//       if (_verificationId != null) {
//         PhoneAuthCredential credential = PhoneAuthProvider.credential(
//           verificationId: _verificationId!,
//           smsCode: _otpController.text,
//         );

//         await _auth.signInWithCredential(credential);
//         _showMessage('Successfully signed in');

//         // Navigate to home screen or perform desired action
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => HomeScreen()),
//         );
//       }
//     } catch (e) {
//       _showMessage('Error verifying OTP: $e');
//     }
//   }

//   void _showMessage(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message)),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Phone Authentication')),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: _phoneController,
//               decoration: InputDecoration(
//                 labelText: 'Phone Number (e.g., +1234567890)',
//               ),
//               keyboardType: TextInputType.phone,
//             ),
//             if (_otpSent) ...[
//               SizedBox(height: 20),
//               TextField(
//                 controller: _otpController,
//                 decoration: InputDecoration(labelText: 'Enter OTP'),
//                 keyboardType: TextInputType.number,
//               ),
//             ],
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _otpSent ? _signInWithOTP : _verifyPhoneNumber,
//               child: Text(_otpSent ? 'Verify OTP' : 'Send OTP'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Simple Home Screen after successful login
// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Home')),
//       body: Center(
//         child: Text('Welcome! Phone authentication successful'),
//       ),
//     );
//   }
// }
