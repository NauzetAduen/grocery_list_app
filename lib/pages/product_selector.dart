import 'package:flutter/material.dart';

class ProductSelector extends StatefulWidget {
  final String documentID;

  ProductSelector(this.documentID);
  @override
  _ProductSelectorState createState() => _ProductSelectorState();
}

class _ProductSelectorState extends State<ProductSelector> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(widget.documentID),
      ),
    );
  }
}
