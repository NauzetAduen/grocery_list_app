import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_list_app/Style/style.dart';
import 'package:grocery_list_app/models/grocery_list.dart';
import 'package:grocery_list_app/pages/product_selector.dart';

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
        Text(
          _getStringFromDate(widget.myList.initDate),
          style: Style.listTitleTextStyle,
          textAlign: TextAlign.center,
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: widget.myList.productList.length,
          itemBuilder: (context, index) {
            var item = widget.myList.productList[index];
            // print(item);
            String pro = item['productName'];
            String mag = item['productMagnitude'];
            return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Material(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.purpleAccent,
                    elevation: 10,
                    child: Container(
                        decoration: BoxDecoration(
                            // gradient: Styles.tileGradient,
                            borderRadius: BorderRadius.circular(15)),
                        child: Builder(
                            builder: (context) => ListTile(
                                  title: Text("$pro : $mag"),
                                )))));
          },
        ),
        CupertinoButton(
          onPressed: () {
            _goToProductListView();
          },
          child: Text("ADD"),
        ),
      ],
    );
  }

  String _getStringFromDate(DateTime date) {
    return "${date.day} - ${date.month} - ${date.year}";
  }

  _goToProductListView() {
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => ProductSelector(widget.documentID)));
  }
}
