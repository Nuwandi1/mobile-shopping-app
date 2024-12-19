import 'package:flutter/material.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Cart Page',
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }
}
