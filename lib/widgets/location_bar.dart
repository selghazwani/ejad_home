import 'package:flutter/material.dart';
import 'package:flutter_application_1/tests/fav.dart';
import 'package:flutter_application_1/tests/filter.dart';
import 'package:flutter_application_1/tests/property1.dart';
import 'package:flutter_application_1/tests/search_bar.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: GoogleFonts.cairo().fontFamily, // Cairo font
      ),
      home: const LocationBar(),
    );
  }
}

class LocationBar extends StatelessWidget {
  const LocationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchFilterPage(),
                ),
              );
            },
          ),
        ],
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(height: 4), // Space between title and subtitle
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.location_on,
                    color: Color.fromARGB(229, 19, 60, 117), size: 20),
                const SizedBox(width: 4),
                Text(
                  " بنغازي",
                  style: TextStyle(
                    fontSize: 20, // At least 20
                    color: Colors.black,
                    fontFamily: GoogleFonts.cairo().fontFamily,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: PropertyOneScreen(),
    );
  }
}
