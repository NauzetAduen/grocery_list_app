import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grocery_list_app/models/grocery_list.dart';

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
