import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_list_app/components/leading_appbar.dart';
import 'package:grocery_list_app/models/product.dart';

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
              body: GridView.builder(
                itemCount: snap.documents.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemBuilder: (BuildContext context, int index) {
                  Product product =
                      Product.fromJson(snap.documents[index].data);

                  return GestureDetector(
                    // onTap: () => _showDialog(context, product),
                    child: Card(
                      color: _getColor(widget.productList, product.name),
                      child: Center(
                        child: Text(
                          product.name,
                          style: TextStyle(fontSize: 22),
                        ),
                      ),
                    ),
                  );
                },
              ));
        });
  }

  Color _getColor(List<Map<String, dynamic>> list, String productName) {
    bool found = false;
    list.forEach((doc) {
      if (doc['productName'].toString().toLowerCase() ==
          productName.toLowerCase()) {
        found = true;
        return;
      }
    });
    if (found) return Colors.grey;
    return Colors.red;
  }
}
