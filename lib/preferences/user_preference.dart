import 'dart:convert';

import 'package:flutter_application_1/models/UserModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
