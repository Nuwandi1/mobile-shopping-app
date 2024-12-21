import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For rootBundle
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/item_card.dart';
import '../models/item_model.dart';
import '../screens/cart_page.dart';
import '../screens/profile_page.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ItemModel> items = [];
  List<ItemModel> filteredItems = [];
  int _selectedIndex = 0; // Track the selected index for the bottom navigation
  String selectedCategory = 'All'; // Default category is 'All'

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  // Load items from JSON file
  Future<void> _loadItems() async {
    final String jsonString = await rootBundle.loadString('assets/items.json');
    final List<dynamic> jsonData = json.decode(jsonString);
    setState(() {
      items = jsonData.map((item) => ItemModel.fromJson(item)).toList();
      filteredItems = items; // Initially show all items
    });
  }

  // Filter items based on selected category
  void _filterItems(String category) {
    setState(() {
      selectedCategory = category;
      if (category == 'All') {
        filteredItems = items; // Show all items
      } else if (category == 'Fruits') {
        filteredItems = items.where((item) => item.id >= 1 && item.id <= 50).toList();
      } else if (category == 'Vegetables') {
        filteredItems = items.where((item) => item.id >= 51 && item.id <= 100).toList();
      } else if (category == 'Snacks') {
        filteredItems = items.where((item) => item.id >= 101 && item.id <= 150).toList();
      }else if (category == 'Spices') {
        filteredItems = items.where((item) => item.id >= 151 && item.id <= 200).toList();
      }else if (category == 'Others') {
        filteredItems = items.where((item) => item.id >= 201 && item.id <= 250).toList();
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    // Define the pages for the bottom navigation bar
    final List<Widget> pages = [
      _buildHomePage(cartProvider),
      const CartPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping App'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  _onItemTapped(1); // Navigate to Cart
                },
              ),
              if (cartProvider.itemCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.red,
                    child: Text(
                      '${cartProvider.itemCount}',
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: pages[_selectedIndex], // Show the selected page
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        onTap: _onItemTapped,
        items: const <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.shopping_cart, size: 30),
          Icon(Icons.account_circle, size: 30),
        ],
        color: Colors.blue,
        backgroundColor: Colors.white,
        height: 60.0,
      ),
    );
  }

  // Builds the home page content with product grid and category filter
  Widget _buildHomePage(CartProvider cartProvider) {
    return Column(
      children: [
        // Horizontal category filter
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildCategoryButton('All'),
                _buildCategoryButton('Fruits'),
                _buildCategoryButton('Vegetables'),
                _buildCategoryButton('Snacks'),
                _buildCategoryButton('Spices'),
                _buildCategoryButton('Others'),
              ],
            ),
          ),
        ),
        // Display filtered items
        Expanded(
          child: filteredItems.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Two items per row
                    crossAxisSpacing: 10.0, // Space between columns
                    mainAxisSpacing: 10.0, // Space between rows
                  ),
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    return ItemCard(
                      name: filteredItems[index].name,
                      price: filteredItems[index].price,
                      image: filteredItems[index].image,
                      id: filteredItems[index].id, // Item ID for cart functionality
                    );
                  },
                ),
        ),
      ],
    );
  }

  // Builds a category filter button
  Widget _buildCategoryButton(String category) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton(
        onPressed: () => _filterItems(category),
        child: Text(
          category,
          style: TextStyle(
            color: selectedCategory == category ? Colors.white : Colors.black,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: selectedCategory == category ? Colors.blue : Colors.grey[200],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}
