import 'package:flutter/material.dart';
import 'package:flutter_application_1/bottombar_nav.dart';
import 'package:flutter_application_1/entities/on_boarding_entity.dart';
import 'package:flutter_application_1/login_page.dart';
import 'package:flutter_application_1/screens/profile_screen.dart';
import 'package:flutter_application_1/models/UserModel.dart';
import 'package:flutter_application_1/services/UserService.dart';
import 'package:flutter_application_1/widgets/header_widget.dart';
import 'package:flutter_application_1/widgets/profile_name.dart';
import 'package:flutter_application_1/widgets/profile_photo.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PersonalInfoScreen extends StatefulWidget {
  final User email;
  const PersonalInfoScreen({Key? key, required this.email, }) : super(key: key);

  @override
  _PersonalInfoScreenState createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  

  var isLoaded = false;
  void initState() {
    super.initState();

    //fetch data from API
  }

  void dispose() {
    super.dispose();
  }

 


  @override
 
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ملف المستخدم',
          style:
              TextStyle(fontFamily: 'Cairo', fontSize: 20, color: Colors.black),
        ),
        automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
      ),
      body: Stack(
        children: [
          
          ProfileScreen(email: widget.email,)

        ]
    ));
  }


}
