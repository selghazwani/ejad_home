import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/splash_screen.dart';
import 'package:flutter_application_1/tests/AddProperty.dart';
import 'package:flutter_application_1/tests/api.dart';
import 'package:flutter_application_1/tests/filter.dart';
import 'package:flutter_application_1/tests/photo_upload.dart';
import 'package:flutter_application_1/widgets/location_bar.dart';
import 'package:flutter_application_1/tests/property1.dart';
import 'package:flutter_application_1/tests/property.dart';
import 'package:flutter_application_1/tests/property2.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Cairo',
      ),
      debugShowCheckedModeBanner: false,
      locale: Locale('ar', 'AE'),
      supportedLocales: [Locale('en', 'US'), Locale('ar', 'AE')],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) {
        // Ensure the whole app follows RTL layout
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      home: SplashScreen(),
    );
  }
}

// // main.dart
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     // For named initialization (optional), add options from your Firebase config
//     options: const FirebaseOptions(
//         apiKey: 'AIzaSyACBD4cRbtqnwblHmzc3DMfKslUP5UCKfg',
//         appId: '1:50930067992:ios:91429546c0025f3346716d',
//         messagingSenderId: '50930067992',
//         projectId: 'ejad-home'),
//   );
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'OTP Login',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: const PhoneLoginScreen(),
//     );
//   }
// }

// class PhoneLoginScreen extends StatefulWidget {
//   const PhoneLoginScreen({super.key});

//   @override
//   State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
// }

// class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
//   final _phoneController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   bool _isLoading = false;

//   Future<void> _sendOTP() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() => _isLoading = true);

//       String phoneNumber = '+218${_phoneController.text}'; // Add country code

//       await _auth.verifyPhoneNumber(
//         phoneNumber: phoneNumber,
//         verificationCompleted: (PhoneAuthCredential credential) async {
//           // Auto-retrieval or instant verification completed
//           await _auth.signInWithCredential(credential);
//           setState(() => _isLoading = false);
//           _showSuccessDialog();
//         },
//         verificationFailed: (FirebaseAuthException e) {
//           setState(() => _isLoading = false);
//           _showErrorDialog(e.message ?? 'Verification failed');
//         },
//         codeSent: (String verificationId, int? resendToken) {
//           setState(() => _isLoading = false);
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => OTPScreen(
//                 phoneNumber: phoneNumber,
//                 verificationId: verificationId,
//               ),
//             ),
//           );
//         },
//         codeAutoRetrievalTimeout: (String verificationId) {
//           // Auto retrieval timeout
//         },
//       );
//     }
//   }

//   void _showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Error'),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showSuccessDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Success'),
//         content: const Text('Login successful!'),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               // Navigate to home screen
//             },
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Phone Login')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               TextFormField(
//                 controller: _phoneController,
//                 keyboardType: TextInputType.phone,
//                 decoration: const InputDecoration(
//                   labelText: 'Phone Number',
//                   prefixText: '+218',
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter phone number';
//                   }
//                   if (!RegExp(r'^\d{9}$').hasMatch(value)) {
//                     return 'Please enter a valid 9-digit phone number';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 20),
//               _isLoading
//                   ? const CircularProgressIndicator()
//                   : ElevatedButton(
//                       onPressed: _sendOTP,
//                       child: const Text('Send OTP'),
//                     ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class OTPScreen extends StatefulWidget {
//   final String phoneNumber;
//   final String verificationId;

//   const OTPScreen({
//     super.key,
//     required this.phoneNumber,
//     required this.verificationId,
//   });

//   @override
//   State<OTPScreen> createState() => _OTPScreenState();
// }

// class _OTPScreenState extends State<OTPScreen> {
//   final _otpController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   bool _isLoading = false;

//   Future<void> _verifyOTP() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() => _isLoading = true);

//       try {
//         final credential = PhoneAuthProvider.credential(
//           verificationId: widget.verificationId,
//           smsCode: _otpController.text,
//         );

//         await _auth.signInWithCredential(credential);
//         setState(() => _isLoading = false);

//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Login Successful!')),
//           );
//           // Navigate to home screen
//         }
//       } catch (e) {
//         setState(() => _isLoading = false);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error: ${e.toString()}')),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Verify OTP')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 'Enter the OTP sent to ${widget.phoneNumber}',
//                 style: const TextStyle(fontSize: 16),
//               ),
//               const SizedBox(height: 20),
//               TextFormField(
//                 controller: _otpController,
//                 keyboardType: TextInputType.number,
//                 maxLength: 6,
//                 decoration: const InputDecoration(
//                   labelText: 'OTP',
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter OTP';
//                   }
//                   if (!RegExp(r'^\d{6}$').hasMatch(value)) {
//                     return 'Please enter a valid 6-digit OTP';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 20),
//               _isLoading
//                   ? const CircularProgressIndicator()
//                   : ElevatedButton(
//                       onPressed: _verifyOTP,
//                       child: const Text('Verify OTP'),
//                     ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
