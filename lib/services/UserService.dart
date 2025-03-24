import 'dart:io';

import 'package:flutter_application_1/models/UserModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

main() {}

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
