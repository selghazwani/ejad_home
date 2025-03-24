import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/bottombar_nav.dart';
import 'package:flutter_application_1/login_page.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/models/UserModel.dart';
import 'package:flutter_application_1/screens/on_boarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

void checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userData = prefs.getString('user');

    Timer(Duration(seconds: 3), () {
      if (userData != null) {
        // Convert JSON string to User object
        User user = User.fromJson(jsonDecode(userData));

        // Navigate to BottomBarNav with user data
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => BottomNavigationExample(email: user)),
        );
      } else {
        // Navigate to LoginPage if no user is found
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => OnBoardingScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
      decoration: BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.center,
        end: Alignment.center,
        colors: [
          Color.fromARGB(84, 84, 115, 255),
          Color.fromARGB(84, 84, 116, 255),
        ],
      )),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(right: 20),
              width: 340,
              child: Image.asset(
                'assets/logonew.png',
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 12, 75, 164),
              ),
            )
          ],
        ),
      ),
    );
  }
}
