import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/property_model.dart';
import 'package:flutter_application_1/tests/pro_details.dart';
import 'package:http/http.dart' as http;

class PropertyTwoScreen extends StatefulWidget {
  final String? id;

  PropertyTwoScreen({Key? key, required this.id}) : super(key: key);

  @override
  _PropertyTwoScreenState createState() => _PropertyTwoScreenState();
}

class _PropertyTwoScreenState extends State<PropertyTwoScreen> {
  List<Property> properties = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();
  List<String> searchResults = [];

  @override
  void initState() {
    super.initState();
    print("User ID in PropertyTwoScreen: ${widget.id}"); // Debug print
    fetchProperties(widget.id);
  }

  Future<void> fetchProperties(String? userId) async {
    if (userId == null) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('معرف المستخدم غير متوفر')),
      );
      return;
    }

    final String baseUrl = "https://ejad-home.ly/readPropertyUser.php?user_id=";
    final String fullUrl = '$baseUrl$userId';

    print('Request URL: $fullUrl');

    try {
      final response = await http.get(Uri.parse(fullUrl));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        setState(() {
          properties = data.map((json) => Property.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load properties for user $userId");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching properties for user $userId: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل في تحميل العقارات')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text("عقاراتي", style: TextStyle(color: Colors.black)),
        elevation: 0,
      ),
      body: Stack(
        children: [
          isLoading
              ? Center(child: CircularProgressIndicator())
              : properties.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/no_found.jpg',
                            width: 300,
                            height: 300,
                          ),
                          SizedBox(height: 16),
                          Text(
                            "لا توجد بيانات",
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: properties.length,
                            itemBuilder: (context, index) {
                              return PropertyCard(property: properties[index]);
                            },
                          ),
                        ),
                      ],
                    ),
        ],
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final List<Property> properties;

  CategoryItem({
    required this.icon,
    required this.label,
    required this.properties,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FilteredPropertiesScreen(
              filterType: label,
              properties: properties,
            ),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Color.fromARGB(229, 19, 60, 117),
            ),
          ),
          SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}

class FilteredPropertiesScreen extends StatelessWidget {
  final String filterType;
  final List<Property> properties;

  FilteredPropertiesScreen({
    required this.filterType,
    required this.properties,
  });

  @override
  Widget build(BuildContext context) {
    final filteredProperties = properties.where((property) {
      if (filterType == 'سكني' || filterType == 'تجاري') {
        return property.type == filterType;
      } else if (filterType == 'للبيع' || filterType == 'للإيجار') {
        return property.state == filterType;
      }
      return false;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'عقارات $filterType',
          style: TextStyle(color: Colors.deepPurple),
        ),
        centerTitle: true,
      ),
      body: filteredProperties.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/no_found.jpg',
                    width: 300,
                    height: 300,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'لا توجد عقارات متاحة',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: filteredProperties.length,
              itemBuilder: (context, index) {
                return PropertyCard(property: filteredProperties[index]);
              },
            ),
    );
  }
}

class PropertyCard extends StatelessWidget {
  final Property property;

  PropertyCard({required this.property});

  @override
  Widget build(BuildContext context) {
    String displayImage = property.images.isNotEmpty ? property.images[0] : '';

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
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
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: displayImage.isNotEmpty
                    ? Image.network(
                        displayImage,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset(
                          'assets/noimage.png',
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Image.asset(
                        'assets/noimage.png',
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Row(
                          children: [
                            Text(
                              property.name,
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 5),
                            Text(
                              'في',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 5),
                            Text(
                              property.location,
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Spacer(),
                        property.state == 'للبيع'
                            ? Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(229, 19, 60, 117),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  property.state,
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.white),
                                ),
                              )
                            : Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.orange[700],
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  property.state,
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.white),
                                ),
                              ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 14, color: Colors.blue),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            property.location,
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[700]),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(Icons.square_foot, size: 14, color: Colors.blue),
                        SizedBox(width: 2),
                        Text("${property.area} متر مربع",
                            style: TextStyle(fontSize: 12)),
                        SizedBox(width: 2),
                        Icon(Icons.bathtub, size: 14, color: Colors.blue),
                        SizedBox(width: 4),
                        Text("${property.bathroom} حمام",
                            style: TextStyle(fontSize: 12)),
                        SizedBox(width: 2),
                        Icon(Icons.bed, size: 14, color: Colors.blue),
                        SizedBox(width: 4),
                        Text("${property.bedroom} غرف نوم",
                            style: TextStyle(fontSize: 12)),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Text(
                          property.price,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
                        Text(
                          'د.ل',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
