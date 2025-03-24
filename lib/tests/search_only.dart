import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      "https://ejad-home.ly/searchonlyProperty.php"; // Replace with your actual server URL

  static Future<List<String>> searchProperties(String query) async {
    final response = await http.get(Uri.parse("$baseUrl?q=$query"));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((property) => property['name'].toString()).toList();
    } else {
      throw Exception("Failed to load properties");
    }
  }
}

void main() {
  runApp(MaterialApp(home: SearchOnlyScreen()));
}

class SearchOnlyScreen extends StatefulWidget {
  @override
  _SearchOnlyScreenState createState() => _SearchOnlyScreenState();
}

class _SearchOnlyScreenState extends State<SearchOnlyScreen> {
  TextEditingController _searchController = TextEditingController();
  List<String> _results = [];
  bool _isLoading = false;

  void _search() async {
    setState(() => _isLoading = true);

    try {
      List<String> results =
          await ApiService.searchProperties(_searchController.text);
      setState(() {
        _results = results;
      });
    } catch (e) {
      setState(() {
        _results = ["Error fetching data"];
      });
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Property Search")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Enter property name",
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _search,
                ),
              ),
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : Expanded(
                    child: ListView.builder(
                      itemCount: _results.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_results[index]),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
