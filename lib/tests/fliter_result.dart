import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/property_model.dart';
import 'package:flutter_application_1/tests/pro_details.dart';

class FilteredResultsPage extends StatelessWidget {
  final List<dynamic> results;

  FilteredResultsPage({required this.results});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.blue),
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text("نتائج البحث", style: TextStyle(color: Colors.black)),
      ),
      body: results.isEmpty
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
              itemCount: results.length,
              itemBuilder: (context, index) {
                final property = results[index];
                // Use the first image from 'images' array, or fallback to empty string
                String displayImage = (property['images'] != null &&
                        property['images'].isNotEmpty)
                    ? property['images'][0]
                    : '';

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PropertyDetailsScreen(
                          property: Property(
                            id: property['id'] != null
                                ? int.parse(property['id'].toString())
                                : 0,
                            name: property['name'] ?? '',
                            description: property['description'] ?? '',
                            location: property['location'] ?? '',
                            type: property['type'] ?? '',
                            state: property['state'] ?? '',
                            propertyType: property['property_type'] ?? '',
                            furniture: property['furniture'] ?? '',
                            certificate: property['certificate'] ?? '',
                            price: property['price'] ?? '',
                            area: property['area'] ?? '',
                            floor: property['floor'] ?? '',
                            bedroom: property['bedroom'] ?? '',
                            bathroom: property['bathroom'] ?? '',
                            createdAt: property['created_at'] ?? '',
                            images: property['images'] != null
                                ? List<String>.from(property['images'])
                                : [],
                          ),
                          favoriteProperties: [],
                        ),
                      ),
                    );
                  },
                  child: Card(
                    margin: EdgeInsets.all(10),
                    child: ListTile(
                      leading: displayImage.isNotEmpty
                          ? Image.network(
                              displayImage,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset(
                                'assets/noimage.png',
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Image.asset(
                              'assets/noimage.png',
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                      title: Text(property['name'] ?? 'غير متوفر'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${property['price'] ?? 'غير محدد'} د.ل",
                              style: TextStyle(color: Colors.red)),
                          Text(
                              "${property['bedroom'] ?? '0'} غرف - ${property['bathroom'] ?? '0'} حمامات"),
                          Text(property['location'] ?? 'غير محدد'),
                        ],
                      ),
                      trailing: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: property['state'] == 'للبيع'
                              ? Colors.blue
                              : Colors.orange,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          property['state'] ?? 'غير محدد',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
