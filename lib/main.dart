import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'pages/home.dart';
import 'pages/cart.dart';
import 'pages/profile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shopping App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0; // Default selected index for the navigation bar

  final pages = [
    const HomePage(),
    const CartPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background color for the main screen
      appBar: AppBar(
        title: Text(
          ['Home', 'Cart', 'Profile'][index], // Dynamic app bar title
          style: const TextStyle(fontSize: 20),
        ),
        backgroundColor: Colors.blue[300],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: index,
        items: const [
          Icon(Icons.home, size: 30, color: Colors.white), // Home icon
          Icon(Icons.shopping_cart, size: 30, color: Colors.white), // Cart icon
          Icon(Icons.person, size: 30, color: Colors.white), // Profile icon
        ],
        onTap: (selectedIndex) {
          setState(() {
            index = selectedIndex;
          });
        },
        height: 70,
        backgroundColor: Colors.transparent,
        color: Colors.blue,
        animationDuration: const Duration(milliseconds: 300),
      ),
      body: pages[index], // Display the selected page
    );
  }
}
