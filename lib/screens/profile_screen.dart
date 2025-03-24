import 'package:flutter/material.dart';
import 'package:flutter_application_1/login_page.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/models/UserModel.dart';
import 'package:flutter_application_1/preferences/user_preference.dart';
import 'package:flutter_application_1/tests/AddProperty.dart';
import 'package:flutter_application_1/tests/property1.dart';
import 'package:flutter_application_1/tests/property2.dart';

class ProfileScreen extends StatelessWidget {
  final User email;

  const ProfileScreen({super.key, required this.email});

  Widget _showDialog(BuildContext context) {
    return AlertDialog(
      title: Text('تسجيل الخروج'),
      content: Text('هل أنت متأكد من تسجيل الخروج؟'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('لا'),
        ),
        TextButton(
          onPressed: () {
            UserPreferences.clearUser();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('لقد تم تسجيل الخروج بنجاح')),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => LoginPage()),
            );
          },
          child: Text('نعم'),
        ),
      ],
    );
  }

  void _onLogOutPressed(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => _showDialog(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("User ID in ProfileScreen: ${email.id}"); // Debug print
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            const ProfilePic(),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  email.firstName,
                  style: TextStyle(
                      color: Colors.black, fontFamily: 'Cairo', fontSize: 24),
                ),
                SizedBox(width: 5),
                Text(
                  email.lastName,
                  style: TextStyle(
                      color: Colors.black, fontFamily: 'Cairo', fontSize: 24),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ProfileMenu(
              text: "عقاراتي",
              icon: "assets/icons/User Icon.svg",
              press: () {
                if (email.id == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('معرف المستخدم غير متوفر')),
                  );
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PropertyTwoScreen(id: email.id),
                  ),
                );
              },
            ),
            ProfileMenu(
              text: "إضافة عقار",
              icon: "assets/icons/Bell.svg",
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddPropertyPage(user: email),
                  ),
                );
              },
            ),
            SizedBox(height: 25),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(229, 19, 60, 117),
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              onPressed: () => _onLogOutPressed(context),
              child: Text(
                'تسجيل خروج',
                style: TextStyle(
                    fontFamily: 'Cairo', fontSize: 19, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePic extends StatelessWidget {
  const ProfilePic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          const CircleAvatar(
            backgroundImage: AssetImage('assets/profile.png'),
          ),
        ],
      ),
    );
  }
}

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    Key? key,
    required this.text,
    required this.icon,
    this.press,
  }) : super(key: key);

  final String text, icon;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Color.fromARGB(255, 22, 4, 140),
          padding: const EdgeInsets.all(20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: const Color(0xFFF5F6F9),
        ),
        onPressed: press,
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 20,
                  fontFamily: 'Cairo',
                  color: Color(0xFF757575),
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward,
              color: Color(0xFF757575),
            ),
            const SizedBox(width: 20),
          ],
        ),
      ),
    );
  }
}
