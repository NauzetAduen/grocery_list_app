import 'package:cloud_firestore/cloud_firestore.dart';
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
  DocumentReference reference;

  @override
  void initState() {
    super.initState();
    reference =
        Firestore.instance.collection("lists").document(widget.documentID);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Text(
          // _getStringFromDate(widget.myList.initDate),
          widget.myList.title,
          style: Style.listTitleTextStyle,
          textAlign: TextAlign.center,
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: widget.myList.productList.length,
          itemBuilder: (context, index) {
            var item = widget.myList.productList[index];
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
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () {
                                          _editMagnitude();
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () {
                                          _deleteProductFromList(pro);
                                        },
                                      ),
                                    ],
                                  ),
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

  _editMagnitude() {
    print("EDDDDDITING");
  }

  _deleteProductFromList(String product) {
    print("Deleting");
    Firestore.instance.runTransaction((Transaction transaction) async {
      print("entering transaction");
      DocumentSnapshot snapshot = await transaction.get(reference);
      List<Map<String, dynamic>> newList = widget.myList.productList;
      newList.removeWhere((prodc) => prodc.containsValue(product));
      await transaction.update(snapshot.reference, {"productList": newList});
    });
  }

  List<Map<String, dynamic>> _getListWithOutProduct(
      List<Map<String, dynamic>> list, String product) {
    List<Map<String, dynamic>> newList = [];
    list.forEach((element) {
      // if (!element.toString().contains(product))
      // newList.add(element.toString());
    });
    return newList;
  }

  _goToProductListView() {
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) =>
                ProductSelector(widget.documentID, widget.myList.productList)));
  }
}
