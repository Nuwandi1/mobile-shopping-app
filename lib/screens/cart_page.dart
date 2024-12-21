import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../models/item_model.dart';
import 'checkout_page.dart'; // Import the CheckoutPage

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.cartItems;

    // Get the total price from CartProvider
    double totalPrice = cartProvider.totalPrice;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: cartItems.isEmpty
          ? const Center(child: Text('Your cart is empty!', style: TextStyle(fontSize: 18, color: Colors.black)))
          : Column(
              children: [
                // Cart items list
                Expanded(
                  child: ListView.builder(
                    itemCount: (cartItems.length / 2).ceil(), // To ensure we get an integer count of rows
                    itemBuilder: (context, index) {
                      final firstItem = cartItems[index * 2];
                      final secondItem = (index * 2 + 1) < cartItems.length
                          ? cartItems[index * 2 + 1]
                          : null;

                      return _buildCartRow(firstItem, secondItem, cartProvider);
                    },
                  ),
                ),
                // Total price section
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total:',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '\$${totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    ],
                  ),
                ),
                // Checkout button section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to the CheckoutPage when clicked
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CheckoutPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text('Proceed to Checkout'),
                  ),
                ),
                const SizedBox(height: 20), // Add some space at the bottom
              ],
            ),
    );
  }

  // Helper function to build a row of cart items (two items per row)
  Widget _buildCartRow(ItemModel firstItem, ItemModel? secondItem, CartProvider cartProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // First item
          _buildCartTile(firstItem, cartProvider),
          // Second item (if exists)
          if (secondItem != null) _buildCartTile(secondItem, cartProvider),
        ],
      ),
    );
  }

  // Helper function to build a single cart item tile
  Widget _buildCartTile(ItemModel item, CartProvider cartProvider) {
    return Expanded(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                'assets/images/${item.image}', // Ensure correct image path
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                item.name,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                '\$${item.price.toStringAsFixed(2)} x ${item.quantity}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                cartProvider.removeItem(item);
              },
            ),
          ],
        ),
      ),
    );
  }
}
