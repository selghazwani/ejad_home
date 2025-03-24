import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/property_model.dart';
import 'package:flutter_application_1/tests/pro_details.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PropertyOneScreen(),
    );
  }
}

class PropertyOneScreen extends StatefulWidget {
  @override
  _PropertyOneScreenState createState() => _PropertyOneScreenState();
}

class _PropertyOneScreenState extends State<PropertyOneScreen> {
  List<Property> properties = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();
  List<String> searchResults = [];
  bool sortOldestFirst = false;

  @override
  void initState() {
    super.initState();
    fetchProperties();
  }

  Future<void> fetchProperties() async {
    final url = Uri.parse("https://ejad-home.ly/readProperty.php");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        setState(() {
          properties = data.map((json) => Property.fromJson(json)).toList();
          properties.sort((a, b) => DateTime.parse(b.createdAt)
              .compareTo(DateTime.parse(a.createdAt)));
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load properties");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching properties: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل في تحميل العقارات، حاول مرة أخرى')),
      );
    }
  }

  Future<void> _refreshProperties() async {
    setState(() {
      isLoading = true;
    });
    await fetchProperties();
  }

  void sortProperties() {
    setState(() {
      properties.sort((a, b) {
        DateTime dateA = DateTime.parse(a.createdAt);
        DateTime dateB = DateTime.parse(b.createdAt);
        return sortOldestFirst
            ? dateA.compareTo(dateB)
            : dateB.compareTo(dateA);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _refreshProperties,
        child: Stack(
          children: [
            isLoading
                ? Center(child: CircularProgressIndicator())
                : properties.isEmpty
                    ? Center(child: Text("لا توجد بيانات"))
                    : Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 15),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                Text(
                                  'عما تبحث؟',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    CategoryItem(
                                      icon: Icons.apartment,
                                      label: 'سكني',
                                      properties: properties,
                                    ),
                                    CategoryItem(
                                      icon: Icons.storefront,
                                      label: 'تجاري',
                                      properties: properties,
                                    ),
                                    CategoryItem(
                                      icon: Icons.handshake,
                                      label: 'للبيع',
                                      properties: properties,
                                    ),
                                    CategoryItem(
                                      icon: Icons.vpn_key,
                                      label: 'للإيجار',
                                      properties: properties,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 24),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          sortOldestFirst = true;
                                          sortProperties();
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 5),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: sortOldestFirst
                                                ? [
                                                    Colors.blue.shade700,
                                                    Colors.blue.shade500
                                                  ]
                                                : [
                                                    Colors.grey.shade400,
                                                    Colors.grey.shade400
                                                  ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 6,
                                              offset: Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: Text(
                                          'الأقدم أولاً',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          sortOldestFirst = false;
                                          sortProperties();
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 5),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: !sortOldestFirst
                                                ? [
                                                    Colors.blue.shade700,
                                                    Colors.blue.shade500
                                                  ]
                                                : [
                                                    Colors.grey.shade400,
                                                    Colors.grey.shade400
                                                  ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 6,
                                              offset: Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: Text(
                                          'الأحدث أولاً',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: properties.length,
                              itemBuilder: (context, index) {
                                return PropertyCard(
                                    property: properties[index]);
                              },
                            ),
                          ),
                        ],
                      ),
          ],
        ),
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
            child: Icon(icon, color: Color.fromARGB(229, 19, 60, 117)),
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
        title: Text('عقارات $filterType',
            style: TextStyle(color: Colors.deepPurple)),
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
    // Use the first image from the images list, fallback to placeholder if empty
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
                    property: property, favoriteProperties: []),
              ),
            );
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: displayImage.isEmpty
                    ? Image.asset(
                        'assets/noimage.png',
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        displayImage,
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
                                child: Text(property.state,
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white)),
                              )
                            : Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.orange[700],
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(property.state,
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white)),
                              ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 14, color: Colors.blue),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(property.location,
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey[700])),
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
                        Text(property.price,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.red)),
                        Text('د.ل',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.red)),
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
