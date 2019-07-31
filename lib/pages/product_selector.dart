import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_list_app/components/leading_appbar.dart';

class ProductSelector extends StatefulWidget {
  final String documentID;
  final List<Map<String, dynamic>> productList;

  ProductSelector(this.documentID, this.productList);
  @override
  _ProductSelectorState createState() => _ProductSelectorState();
}

class _ProductSelectorState extends State<ProductSelector> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: Firestore.instance
            .collection("products")
            .orderBy("used", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );

          QuerySnapshot snap = snapshot.data;

          return Scaffold(
              appBar: LeadingAppbar(Text("Add products")),
              body: Center(
                child: Text("ASDASD"),
              ));
        });
  }
}
