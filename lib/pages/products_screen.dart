import 'package:flutter/material.dart';

class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Products screen"),
      ),
      body: Center(
        child: Text("Products"),
      ),
    );
  }
}
