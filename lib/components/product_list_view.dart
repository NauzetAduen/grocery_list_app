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
        ListView.builder(
          shrinkWrap: true,
          itemCount: widget.myList.productList.length,
          itemBuilder: (context, index) {
            var item = widget.myList.productList[index];
            // print(item);
            String pro = item['productName'];
            String mag = item['productMagnitude'];

            return ListTile(
              title: Text("$pro : $mag"),
            );
          },
        )
      ],
    );
  }
}
