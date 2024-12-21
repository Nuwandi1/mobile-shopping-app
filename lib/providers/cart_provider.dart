import 'package:flutter/material.dart';
import '../models/item_model.dart';

class CartProvider with ChangeNotifier {
  final List<ItemModel> _cartItems = [];
  final List<ItemModel> _purchasedItems = [];

  List<ItemModel> get cartItems => _cartItems;
  List<ItemModel> get purchasedItems => _purchasedItems;

  // Add an item to the cart
  void addItem(ItemModel item) {
    _cartItems.add(item);
    notifyListeners();
  }

  // Add item with quantity check and update if already in cart
  void addItemWithQuantity(ItemModel item) {
    final index = _cartItems.indexWhere((existingItem) => existingItem.id == item.id);
    if (index != -1) {
      _cartItems[index].quantity += item.quantity;  // Increase quantity if item is already in cart
    } else {
      _cartItems.add(item);  // Add new item if not found
    }
    notifyListeners();
  }

  // Remove item from cart by object
  void removeItem(ItemModel item) {
    _cartItems.remove(item);
    notifyListeners();
  }

  // Remove item from cart by ID
  void removeItemById(int itemId) {
    _cartItems.removeWhere((item) => item.id == itemId);
    notifyListeners();
  }

  // Get total price of items in cart
  double get totalPrice {
    double total = 0.0;
    for (var item in _cartItems) {
      total += item.price * item.quantity; // Multiply price by quantity
    }
    return total;
  }

  // Get total count of items in the cart (including quantity)
  int get itemCount {
    return _cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  // Clear the cart
  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  // Confirm the order (move items to purchased list)
  void confirmOrder() {
    _purchasedItems.addAll(_cartItems);  // Add items to purchased list
    clearCart();  // Clear cart after confirming the order
    notifyListeners();
  }
}
