import 'package:flutter/material.dart';
import 'package:flutter_application_1/login_page.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/models/UserModel.dart';
import 'package:flutter_application_1/preferences/user_preference.dart';
import 'package:flutter_application_1/screens/on_boarding_screen.dart';
import 'package:flutter_application_1/screens/personal_info_screen.dart';
import 'package:flutter_application_1/tests/AddProperty.dart';
import 'package:flutter_application_1/tests/carRent.dart';
import 'package:flutter_application_1/tests/filter.dart';
import 'package:flutter_application_1/tests/test.dart';
import 'package:flutter_application_1/widgets/location_bar.dart';
import 'package:flutter_application_1/tests/property.dart';
import 'package:flutter_application_1/tests/property1.dart';

class BottomNavigationExample extends StatefulWidget {
  final User email;

  BottomNavigationExample({Key? key, required this.email}) : super(key: key);

  @override
  _BottomNavigationExampleState createState() =>
      _BottomNavigationExampleState();
}

class _BottomNavigationExampleState extends State<BottomNavigationExample> {
  int _selectedTab = 0;

  void logout() async {
    await UserPreferences.clearUser();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  late List<Widget> _pages = <Widget>[
    LocationBar(),
    SearchFilterPage(),
    CarsGridPage(),
    PersonalInfoScreen(
      email: widget.email,
    ),
  ];

  _changeTab(int index) {
    setState(() {
      _selectedTab = index;
    });
  }

  void _navigateToAddProperty() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddPropertyPage(
                user: widget.email,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedTab],
      extendBody:
          true, // This allows the body to extend behind the bottom navigation
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddProperty,
        backgroundColor: Color.fromARGB(229, 19, 60, 117),
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          Icons.add,
          size: 32,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomAppBar(
            shape: CircularNotchedRectangle(),
            notchMargin: 8.0,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.home, "رئيسي", 0),
                _buildNavItem(Icons.search, "بحث", 1),
                SizedBox(width: 48), // Space for the FAB
                _buildNavItem(Icons.car_rental, "تأجير سيارات", 2),
                _buildNavItem(Icons.person, "ملف", 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    return InkWell(
      onTap: () => _changeTab(index),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: _selectedTab == index
                  ? Color.fromARGB(229, 19, 60, 117)
                  : Colors.grey,
              size: 24,
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: _selectedTab == index
                    ? Color.fromARGB(229, 19, 60, 117)
                    : Colors.grey,
                fontSize: 12,
                fontWeight:
                    _selectedTab == index ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Add this dummy class if you don't have AddPropertyPage yet
