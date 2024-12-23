import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/item_model.dart';
import '../providers/cart_provider.dart';

class ItemCard extends StatelessWidget {
  final String name;
  final double price;
  final String image;
  final int id;

  const ItemCard({
    required this.name,
    required this.price,
    required this.image,
    required this.id,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(4.0),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Adjusting the size of the image
          Image.asset(
            'assets/images/$image', // Ensure the image path is correct
            height: 65, // Adjusted height
            width: 220,  // Adjusted width
            fit: BoxFit.cover,  // Ensure the image scales appropriately
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 0),
                Text('\$${price.toStringAsFixed(2)}'),
                const SizedBox(height: 1),
                ElevatedButton(
                  onPressed: () => _showQuantityDialog(context),
                  child: const Text('Add to Cart'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showQuantityDialog(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    // Show a dialog to choose the quantity
    showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        int quantity = 1; // Default quantity is 1

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Select Quantity'),
              content: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      if (quantity > 1) {
                        setState(() {
                          quantity--;
                        });
                      }
                    },
                  ),
                  Text('$quantity'),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        quantity++;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    // Add the item to the cart with the selected quantity
                    cartProvider.addItemWithQuantity(ItemModel(
                      id: id,
                      name: name,
                      price: price,
                      image: image,
                      quantity: quantity,
                    ));
                    Navigator.pop(context); // Close the dialog
                  },
                  child: const Text('Add to Cart'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Just close the dialog
                  },
                  child: const Text('Cancel'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
