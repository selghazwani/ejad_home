import 'package:flutter/material.dart';
import 'package:flutter_application_1/bottombar_nav.dart';
import 'package:flutter_application_1/login_page.dart';
import 'package:flutter_application_1/preferences/user_preference.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/models/UserModel.dart'; // Import UserModel
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences

class SignupPage extends StatefulWidget {
  SignupPage({Key? key});
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _validationKey = GlobalKey<FormState>();

  TextEditingController lname = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  Future<void> add() async {
    var url = 'https://ejad-home.ly/addUser.php';
    var response = await http.post(Uri.parse(url), body: {
      'last_name': lname.text,
      'first_name': name.text,
      'email': email.text,
      'password': password.text,
    });

    if (response.statusCode == 200) {
      // Create a User object
      User newUser = User(
        firstName: name.text,
        lastName: lname.text,
        email: email.text,
      );

      // Save the user to SharedPreferences
      await UserPreferences.saveUser(newUser);

      // Show success message
      Fluttertoast.showToast(
        msg: 'تم انشاء حسابك بنجاح',
        backgroundColor: Colors.green,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
      );

      // Navigate to BottomNavigationExample
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BottomNavigationExample(
            email: newUser,
          ),
        ),
      );
    } else {
      // Handle error
      Fluttertoast.showToast(
        msg: 'حدث خطأ أثناء إنشاء الحساب',
        backgroundColor: Colors.red,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  void dispose() {
    super.dispose();
    lname.dispose();
    name.dispose();
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
    print("dispose used");
  }

  _header(context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
          height: 180,
          width: 180,
          child: Image.asset('assets/logonew-screen.png'),
        ),
        Text(
          "إنشاد حساب",
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.w700, fontFamily: 'Cairo'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            height: MediaQuery.of(context).size.height - 50,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    _header(context),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextField(
                          controller: name,
                          decoration: InputDecoration(
                              hintText: "اسم بالكامل",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: BorderSide.none),
                              fillColor: Color.fromARGB(255, 18, 87, 171)
                                  .withOpacity(0.1),
                              filled: true,
                              prefixIcon: const Icon(Icons.person)),
                        )),
                    const SizedBox(height: 25),
                    Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextField(
                          controller: email,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              hintText: "رقم هاتف المتصل بالوتساب ",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: BorderSide.none),
                              fillColor: Color.fromARGB(255, 18, 87, 171)
                                  .withOpacity(0.1),
                              filled: true,
                              prefixIcon: const Icon(Icons.phone)),
                        )),
                    const SizedBox(height: 25),
                    Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextField(
                          controller: password,
                          decoration: InputDecoration(
                            hintText: "كلمة المرور",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none),
                            fillColor: Color.fromARGB(255, 18, 87, 171)
                                .withOpacity(0.1),
                            filled: true,
                            prefixIcon: const Icon(Icons.password),
                          ),
                          obscureText: true,
                        )),
                    const SizedBox(height: 25),
                    Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextField(
                          controller: confirmPassword,
                          decoration: InputDecoration(
                            hintText: "تأكيد كلمة المرور",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none),
                            fillColor: Color.fromARGB(255, 18, 87, 171)
                                .withOpacity(0.1),
                            filled: true,
                            prefixIcon: const Icon(Icons.password),
                          ),
                          obscureText: true,
                          onChanged: (value) {
                            if (value != password.text) {
                              Fluttertoast.showToast(
                                msg: 'كلمة المرور غير متطابقة',
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                toastLength: Toast.LENGTH_SHORT,
                              );
                            }
                          },
                        )),
                  ],
                ),
                Container(
                    padding: const EdgeInsets.only(top: 3, left: 3),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (password.text != confirmPassword.text) {
                          Fluttertoast.showToast(
                            msg: 'كلمة المرور غير متطابقة',
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            toastLength: Toast.LENGTH_SHORT,
                          );
                        } else {
                          await add(); // Call the add function
                        }
                      },
                      child: const Text(
                        " إنشاء ",
                        style: TextStyle(fontSize: 20, fontFamily: "Cairo"),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(vertical: 11),
                        backgroundColor: Color.fromARGB(255, 84, 115, 255),
                      ),
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      LoginPage()));
                        },
                        child: const Text(
                          "سجل دخولك",
                          style: TextStyle(
                              color: Color.fromARGB(255, 84, 115, 255),
                              fontFamily: "Cairo",
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        )),
                    const Text(
                      "لديك حساب؟",
                      style: TextStyle(fontFamily: 'Cairo', fontSize: 15),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
