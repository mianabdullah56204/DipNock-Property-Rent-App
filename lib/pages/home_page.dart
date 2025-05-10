import 'package:app/pages/listing_page.dart';
import 'package:app/pages/messages.dart';
import 'package:app/pages/pages_on_home/buy.dart';
import 'package:app/pages/profile.dart';
import 'package:app/utils/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';

// Dummy user data
Map<String, dynamic> dummyUser1 = {
  'name': 'Username',
  'username': 'username',
  'photoUrl': null,
  'email': 'email@example.com',
  'phoneNumber': '+1-555-9876',
  'location': 'New York, USA',
  'joinedDate': '2023-11-05',
};

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String selectedCity = "All Cities";
  final List<String> cities = [
    "All Cities",
    "Jumeirah",
    "Palm Jumeirah",
    "Emirates Hills",
    "Downtown",
    "Dubai Marina",
    "Business Bay",
    "JLT",
    "Dubai Mall Area",
  ];

  void _onItemTapped(int index) {
    if (index == 2) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => ListingPage()));
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  final List<Widget> _pages = [
    Buy(),
    MessagesPage(),
    ListingPage(),
    Center(
        child: Text(
      "My Ads",
      style: TextStyle(fontFamily: 'SourceSans3'),
    )),
    ProfilePage(userData: dummyUser1),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _pages[_selectedIndex],
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
