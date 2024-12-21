class ItemModel {
  final int id;
  final String name;
  final double price;
  final String image;
  int quantity;  // Track quantity for the cart

  // Constructor
  ItemModel({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    this.quantity = 1,  // Default quantity to 1
  });

  // Factory method to create an instance from JSON data
  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
      image: json['image'],
      quantity: json['quantity'] ?? 1,  // Ensure default quantity is 1 if not provided
    );
  }

  // Convert ItemModel instance to JSON format
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'image': image,
      'quantity': quantity,
    };
  }
}
