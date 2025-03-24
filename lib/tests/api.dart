import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

// 1. User Model
class User {
  final int id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['first_name'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': name,
      'email': email,
    };
  }
}

// 2. API Service to Fetch User Data

class ApiService {
  static const String apiUrl =
      'https://ejad-home.ly/get_current_user.php?email=';

  Future<User> fetchUser(String email) async {
    final response = await http.get(Uri.parse('$apiUrl$email'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return User.fromJson(data);
    } else {
      throw Exception('Failed to load user');
    }
  }
}

// 3. User Preferences for Persistent Login
class UserPreferences {
  static Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('user', jsonEncode(user.toJson()));
  }

  static Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user');
    if (userData == null) return null;
    return User.fromJson(jsonDecode(userData));
  }

  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
  }
}

// 4. Flutter Page to Display User Data

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final TextEditingController _emailController = TextEditingController();

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
    try {
      User user = await ApiService().fetchUser(_emailController.text);
      await UserPreferences.saveUser(user);
      navigateToUserDetails(user);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void navigateToUserDetails(User user) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => UserDetailsPage(user: user),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Enter Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => fetchUserAndNavigate(context),
              child: Text('Fetch User'),
            ),
          ],
        ),
      ),
    );
  }
}

class UserDetailsPage extends StatefulWidget {
  final User user;
  UserDetailsPage({required this.user});

  @override
  _UserDetailsPageState createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  void logout() async {
    await UserPreferences.clearUser();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => UserPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Details'), actions: [
        IconButton(
          icon: Icon(Icons.logout),
          onPressed: logout,
        )
      ]),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            Text(widget.user.name, style: TextStyle(fontSize: 22)),
            Text(widget.user.email,
                style: TextStyle(fontSize: 16, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
