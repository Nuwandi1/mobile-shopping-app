import 'package:flutter/material.dart';
import '../services/data.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DataService _dataService = DataService();
  List<dynamic> groceryItems = [];
  List<dynamic> filteredItems = [];
  bool isLoading = true;

  List<String> categories = ['Fruits', 'Vegetables', 'Snacks', 'Drinks'];
  String selectedCategory = 'Fruits'; // Default category
  List<dynamic> cartItems = [];

  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch all data initially
  }

  Future<void> fetchData() async {
    try {
      final items = await _dataService.fetchGroceryItems();
      setState(() {
        groceryItems = items;
        filteredItems = filterItemsByCategory(items, selectedCategory);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Filter items based on category
  List<dynamic> filterItemsByCategory(List<dynamic> items, String category) {
    return items.where((item) {
      if (category == 'Fruits') {
        return item['id'].startsWith('F'); // Filter by 'F' for Fruits
      } else if (category == 'Vegetables') {
        return item['id'].startsWith('V'); // Filter by 'V' for Vegetables
      } else if (category == 'Snacks') {
        return item['id'].startsWith('S'); // Filter by 'S' for Snacks
      } else if (category == 'Drinks') {
        return item['id'].startsWith('D'); // Filter by 'D' for Drinks
      }
      return false;
    }).toList();
  }

  // Show the Add to Cart dialog with quantity selection and maximize/minimize toggle
  void showAddToCartDialog(dynamic item) {
    int quantity = 1; // Default quantity
    bool isMaximized = false; // Whether the dialog is maximized or minimized

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(item['name']),
              content: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                width: isMaximized ? MediaQuery.of(context).size.width * 0.8 : 250, // Maximize/Minimize
                height: isMaximized ? MediaQuery.of(context).size.height * 0.5 : 150,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.network(item['image'], height: 100, fit: BoxFit.cover),
                    const SizedBox(height: 10),
                    Text("Price: \$${item['price']}"),
                    const SizedBox(height: 10),
                    Text("Select quantity:"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            if (quantity > 1) {
                              setState(() {
                                quantity--;
                              });
                            }
                          },
                          icon: const Icon(Icons.remove),
                        ),
                        Text('$quantity', style: const TextStyle(fontSize: 20)),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              quantity++;
                            });
                          },
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    // Close the dialog without adding to cart
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Add the item with the selected quantity to the cart
                    setState(() {
                      item['quantity'] = quantity;
                      cartItems.add(item);
                    });
                    Navigator.of(context).pop(); // Close the dialog
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Item added to cart!')),
                    );
                  },
                  child: const Text('Add to Cart'),
                ),
                IconButton(
                  icon: Icon(isMaximized ? Icons.arrow_downward : Icons.arrow_upward),
                  onPressed: () {
                    setState(() {
                      isMaximized = !isMaximized; // Toggle between maximized and minimized
                    });
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Grocery List"),
      ),
      body: Column(
        children: [
          // Category selection bar (horizontal scroll)
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedCategory = categories[index];
                        filteredItems = filterItemsByCategory(groceryItems, selectedCategory);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      backgroundColor: selectedCategory == categories[index]
                          ? Colors.purple // Active category color
                          : Colors.blue, // Inactive category color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: Text(
                      categories[index],
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                );
              },
            ),
          ),
          // Display the filtered grocery items in a grid layout
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredItems.isEmpty
                    ? const Center(child: Text("No items found for this category"))
                    : GridView.builder(
                        padding: const EdgeInsets.all(10.0),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Two items per row
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                          childAspectRatio: 3 / 4, // Adjust the ratio as needed
                        ),
                        itemCount: filteredItems.length,
                        itemBuilder: (context, index) {
                          final item = filteredItems[index];
                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(8.0)),
                                    child: Image.network(
                                      item['image'], // Ensure the image URL is correct
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        item['name'],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        "\$${item['price']}",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      ElevatedButton(
                                        onPressed: () => showAddToCartDialog(item),
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                          backgroundColor: Colors.green, // Button color
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12.0),
                                          ),
                                        ),
                                        child: const Text(
                                          "Add to Cart",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
