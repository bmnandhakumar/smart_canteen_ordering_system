import "package:flutter/material.dart";

class ItemsScreen extends StatelessWidget {
  final String categoryId;

  const ItemsScreen({ super.key, required this.categoryId });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Category Items"),
      ),
      body: Center(
        child: Text(
          "Category ID: $categoryId",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
