import 'package:flutter/material.dart';
import 'package:grocery_list_app/models/grocery_list.dart';

class ProductListView extends StatefulWidget {
  final GroceryList myList;
  final String documentID;
  ProductListView(this.myList, this.documentID);
  @override
  _ProductListViewState createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Text("List ${widget.myList.initDate}"),
      ],
    );
  }
}
