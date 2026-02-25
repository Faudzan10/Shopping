import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Product {
  final String name;
  final double price;
  final String category;

  Product({required this.name, required this.price, required this.category});
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: Color(0xFFF5F6FA)),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedCategory = "All";

  List<Product> products = [
    Product(name: "Kaos Hitam", price: 100000, category: "Fashion"),
    Product(name: "Sepatu Sneakers", price: 250000, category: "Fashion"),
    Product(name: "Laptop Gaming", price: 12000000, category: "Elektronik"),
    Product(name: "Headset", price: 300000, category: "Elektronik"),
  ];

  List<CartItem> cart = [];

  void addToCart(Product product) {
    setState(() {
      final index = cart.indexWhere(
        (item) => item.product.name == product.name,
      );

      if (index >= 0) {
        cart[index].quantity++;
      } else {
        cart.add(CartItem(product: product));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Product> filteredProducts = selectedCategory == "All"
        ? products
        : products.where((p) => p.category == selectedCategory).toList();

    int totalItems = cart.fold(0, (sum, item) => sum + item.quantity);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text("Fashion Store"),
        centerTitle: true,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => CartPage(cart: cart)),
                  );
                  setState(() {});
                },
              ),
              if (totalItems > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      totalItems.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              categoryButton("All"),
              categoryButton("Fashion"),
              categoryButton("Elektronik"),
            ],
          ),

          SizedBox(height: 10),

          Expanded(
            child: ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];

                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    title: Text(product.name),
                    subtitle: Text("Rp ${product.price.toStringAsFixed(0)}"),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                          255,
                          255,
                          255,
                          255,
                        ),
                      ),
                      child: Text("Add"),
                      onPressed: () => addToCart(product),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget categoryButton(String category) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedCategory == category
            ? Colors.deepPurple
            : Colors.grey[300],
        foregroundColor: selectedCategory == category
            ? Colors.white
            : Colors.black,
      ),
      onPressed: () {
        setState(() {
          selectedCategory = category;
        });
      },
      child: Text(category),
    );
  }
}

class CartPage extends StatefulWidget {
  final List<CartItem> cart;

  CartPage({required this.cart});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    double total = widget.cart.fold(
      0,
      (sum, item) => sum + (item.product.price * item.quantity),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("My Cart"),
        backgroundColor: Colors.deepPurple,
      ),
      body: widget.cart.isEmpty
          ? Center(child: Text("Cart Kosong 🛒"))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.cart.length,
                    itemBuilder: (context, index) {
                      final item = widget.cart[index];

                      return Card(
                        margin: EdgeInsets.all(10),
                        child: ListTile(
                          title: Text(item.product.name),
                          subtitle: Text(
                            "Rp ${item.product.price.toStringAsFixed(0)}",
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: () {
                                  setState(() {
                                    if (item.quantity > 1) {
                                      item.quantity--;
                                    } else {
                                      widget.cart.removeAt(index);
                                    }
                                  });
                                },
                              ),
                              Text(item.quantity.toString()),
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () {
                                  setState(() {
                                    item.quantity++;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "Total: Rp ${total.toStringAsFixed(0)}",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
