import 'package:flutter/material.dart';
import 'package:grocery_list_app/components/leading_appbar.dart';

class NewProduct extends StatefulWidget {
  @override
  _NewProductState createState() => _NewProductState();
}

class _NewProductState extends State<NewProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LeadingAppbar(Text("New product")),
      body: Center(
        child: Text("AAA"),
      ),
    );
  }
}
