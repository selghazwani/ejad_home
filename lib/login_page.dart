import 'package:flutter/material.dart';
import 'package:flutter_application_1/bottombar_nav.dart';
import 'package:flutter_application_1/models/UserModel.dart';
import 'package:flutter_application_1/preferences/user_preference.dart';
import 'package:flutter_application_1/screens/personal_info_screen.dart';
import 'package:flutter_application_1/services/UserService.dart';
import 'package:flutter_application_1/signup_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkLoggedInUser();
  }

  void checkLoggedInUser() async {
    User? user = await UserPreferences.getUser();
    if (user != null) {
      navigateToUserDetails(user);
    }
  }

  void fetchUserAndNavigate(BuildContext context) async {
    User user = await ApiService().fetchUser(email.text);
    await UserPreferences.saveUser(user);
    navigateToUserDetails(user);
  }

  void navigateToUserDetails(User user) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BottomNavigationExample(email: user),
      ),
    );
  }

  Future login() async {
    var url = Uri.parse("https://ejad-home.ly/UserLogin.php");
    var response = await http.post(url, body: {
      "email": email.text,
      "password": password.text,
    });
    var data = json.decode(response.body);
    print(data);
    if (data.toString() == "Success") {
      Fluttertoast.showToast(
        msg: 'تم تسجيل الدخول بنجاح',
        backgroundColor: Colors.green,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
      );
      fetchUserAndNavigate(context);
    } else {
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        msg: 'البريد او كلمة المرور غير صحيح',
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(screenWidth * 0.05), // 5% of screen width
            height: screenHeight, // Full height to allow proper scrolling
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _header(context, screenWidth, screenHeight),
                _inputField(context, screenWidth),
                _signup(context),
                SizedBox(height: screenHeight * 0.1), // 10% of screen height
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _header(
      BuildContext context, double screenWidth, double screenHeight) {
    return Column(
      children: [
        Container(
          constraints: BoxConstraints(
            maxHeight: screenHeight * 0.25, // Max 25% of screen height
            maxWidth: screenWidth * 0.5, // Max 50% of screen width
          ),
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Image.asset('assets/logonew-screen.png'),
        ),
        Text(
          "تسجيل الدخول",
          style: TextStyle(
            fontSize: screenWidth * 0.08, // Scales with screen width
            fontWeight: FontWeight.w700,
            fontFamily: 'Cairo',
          ),
        ),
      ],
    );
  }

  Widget _inputField(BuildContext context, double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: email,
          decoration: InputDecoration(
            hintText: "رقم هاتف المتصل بالوتساب ",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Color.fromARGB(255, 18, 87, 171).withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.call_rounded),
          ),
        ),
        SizedBox(height: screenWidth * 0.03), // Relative spacing
        TextField(
          controller: password,
          decoration: InputDecoration(
            hintText: "كلمة المرور",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Color.fromARGB(235, 16, 48, 192).withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.password),
          ),
          obscureText: true,
        ),
        SizedBox(height: screenWidth * 0.06),
        ElevatedButton(
          onPressed: () {
            login();
          },
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: EdgeInsets.symmetric(vertical: screenWidth * 0.03),
            backgroundColor: Color.fromARGB(255, 84, 115, 255),
          ),
          child: Text(
            "دخـــول",
            style: TextStyle(
              fontSize: screenWidth * 0.05,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _signup(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "لا تملك حساب؟",
          style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.04,
              fontFamily: "Cairo"),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => SignupPage()),
            );
          },
          child: Text(
            "سجل الان",
            style: TextStyle(
              color: Color.fromARGB(255, 84, 115, 255),
              fontSize: MediaQuery.of(context).size.width * 0.045,
              fontFamily: "Cairo",
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
