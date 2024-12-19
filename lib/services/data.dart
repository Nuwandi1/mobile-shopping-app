import 'dart:convert';
import 'package:flutter/services.dart';

class DataService {
  Future<List<dynamic>> fetchGroceryItems() async {
    final String response = await rootBundle.loadString('assets/grocery_items.json');
    final List<dynamic> data = json.decode(response);
    return data;
  }
}
