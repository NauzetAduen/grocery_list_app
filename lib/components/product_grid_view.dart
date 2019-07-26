import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductGridView extends StatelessWidget {
  final DocumentSnapshot document;

  const ProductGridView({Key key, this.document}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.red,
      child: Center(
        child: Text(
          "${document.data}",
          style: TextStyle(fontSize: 25),
        ),
      ),
    );
  }
}
