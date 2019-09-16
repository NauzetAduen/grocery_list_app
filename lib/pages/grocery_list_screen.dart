import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GroceryListScreen extends StatelessWidget {
  final String documentID;

  const GroceryListScreen(this.documentID);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fuck $documentID"),
      ),
      body: Container(
        color: Colors.white,
      ),
    );
  }
}
