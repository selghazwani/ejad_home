import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/property_model.dart';
import 'package:flutter_application_1/tests/pro_details.dart';

class FavoritesPage extends StatelessWidget {
  final List<Property> favoriteProperties;

  FavoritesPage({required this.favoriteProperties});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('المفضلة'),
        backgroundColor: Colors.deepPurple,
      ),
      body: favoriteProperties.isEmpty
          ? Center(
              child: Text(
                'لا توجد عقارات في المفضلة',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: favoriteProperties.length,
              itemBuilder: (context, index) {
                final property = favoriteProperties[index];
                return ListTile(
                  leading: Image.network(property.images[0],
                      width: 50, height: 50, fit: BoxFit.cover),
                  title: Text(property.name),
                  subtitle: Text("السعر: ${property.price} د.ل"),
                  onTap: () {
                    // Navigate to property details
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PropertyDetailsScreen(
                          property: property,
                          favoriteProperties: favoriteProperties,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
