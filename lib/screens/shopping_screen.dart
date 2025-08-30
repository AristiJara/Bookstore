import 'package:flutter/material.dart';

class ShoppingScreenContent extends StatelessWidget {
  const ShoppingScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        '🛒 Your cart is empty!',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}