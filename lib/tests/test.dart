import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Houzi Search Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SearchPage(),
    );
  }
}

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  String searchQuery = '';
  List<String> results = [
    'Apartment in Downtown',
    'House in Suburbs',
    'Condo near Beach',
    'Luxury Villa',
    'Studio in the City',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 84, 115, 255),
        automaticallyImplyLeading: false,
        title: Text('البحث', style: TextStyle(color: Colors.white, fontFamily: 'cairo', fontSize: 25),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search bar
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for properties...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (query) {
                setState(() {
                  searchQuery = query;
                });
              },
            ),
            SizedBox(height: 16),

            // Filter options
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Apply filter functionality
                  },
                  child: Text('Filter'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Sort functionality
                  },
                  child: Text('Sort'),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Search results
            Expanded(
              child: ListView(
                children: results
                    .where((property) => property
                        .toLowerCase()
                        .contains(searchQuery.toLowerCase()))
                    .map((property) => ListTile(
                          title: Text(property),
                          onTap: () {
                            // Handle tap on a property
                          },
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
