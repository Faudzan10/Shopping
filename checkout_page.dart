import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_model.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  String name = "";
  String address = "";
  String phone = "";

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartModel>();

    return Scaffold(
      appBar: AppBar(title: const Text("Checkout")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                "Order Summary",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ...cart.items.map(
                (item) => Text("${item.product.name} x ${item.quantity}"),
              ),
              Text("Total: Rp ${cart.totalPrice}"),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(labelText: "Name"),
                onSaved: (value) => name = value!,
                validator: (value) => value!.isEmpty ? "Enter name" : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Address"),
                onSaved: (value) => address = value!,
                validator: (value) => value!.isEmpty ? "Enter address" : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Phone"),
                onSaved: (value) => phone = value!,
                validator: (value) => value!.isEmpty ? "Enter phone" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    cart.clearCart();
                    Navigator.popUntil(context, (route) => route.isFirst);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Order Successful!")),
                    );
                  }
                },
                child: const Text("Confirm Order"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
