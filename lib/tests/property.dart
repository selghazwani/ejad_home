import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/property_model.dart';
import 'package:flutter_application_1/tests/pro_details.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(RealEstateApp());
}

class RealEstateApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PropertyListScreen(),
    );
  }
}

class PropertyListScreen extends StatefulWidget {
  @override
  _PropertyListScreenState createState() => _PropertyListScreenState();
}

class _PropertyListScreenState extends State<PropertyListScreen> {
  List<Property> properties = [];

  @override
  void initState() {
    super.initState();
    fetchProperties();
  }

  Future<void> fetchProperties() async {
    final response =
        await http.get(Uri.parse('https://ejad-home.ly/readProperty.php'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        properties = data.map((item) => Property.fromJson(item)).toList();
      });
    } else {
      throw Exception('Failed to load properties');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Real Estate Listings')),
      body: properties.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: properties.length,
              itemBuilder: (context, index) {
                final property = properties[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  elevation: 3,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PropertyDetailsScreen(
                            property: property,
                            favoriteProperties: [],
                          ),
                        ),
                      );
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Property Image
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            bottomLeft: Radius.circular(8),
                          ),
                          child: Image.network(
                            property.images[0],
                            width: 120,
                            height: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 120,
                                height: 100,
                                color: Colors.grey[300],
                                child: Icon(Icons.image_not_supported,
                                    color: Colors.grey),
                              );
                            },
                          ),
                        ),
                        // Property Details
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  property.name,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "${property.location}",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey[700]),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "\$${property.price.toString()}",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  property.type,
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.blueGrey),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
