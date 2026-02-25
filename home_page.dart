import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../models/cart_model.dart';
import 'cart_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchQuery = "";
  String selectedCategory = "All";

  final List<Product> products = [
    Product(id: "1", name: "Sepatu", price: 500000, category: "Fashion"),
    Product(id: "2", name: "Baju", price: 200000, category: "Fashion"),
    Product(id: "3", name: "Laptop", price: 8000000, category: "Elektronik"),
    Product(id: "4", name: "Mouse", price: 150000, category: "Elektronik"),
  ];

  @override
  Widget build(BuildContext context) {
    final filteredProducts = products.where((product) {
      final matchesSearch = product.name.toLowerCase().contains(
        searchQuery.toLowerCase(),
      );

      final matchesCategory =
          selectedCategory == "All" || product.category == selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Shop"),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Search product...",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          DropdownButton<String>(
            value: selectedCategory,
            items: ["All", "Fashion", "Elektronik"]
                .map(
                  (category) =>
                      DropdownMenuItem(value: category, child: Text(category)),
                )
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedCategory = value!;
              });
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return ListTile(
                  title: Text(product.name),
                  subtitle: Text("Rp ${product.price}"),
                  trailing: ElevatedButton(
                    onPressed: () {
                      context.read<CartModel>().addToCart(product);
                    },
                    child: const Text("Add"),
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
