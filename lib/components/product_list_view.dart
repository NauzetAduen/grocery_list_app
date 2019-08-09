import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_list_app/Style/style.dart';
import 'package:grocery_list_app/components/user_row.dart';
import 'package:grocery_list_app/models/grocery_list.dart';
import 'package:grocery_list_app/pages/product_selector.dart';
import 'package:grocery_list_app/utils/validator_helper.dart';

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
      physics: ScrollPhysics(),
      shrinkWrap: true,
      children: <Widget>[
        Text(
          // _getStringFromDate(widget.myList.initDate),
          widget.myList.title,
          style: Style.listTitleTextStyle,
          textAlign: TextAlign.center,
        ),
        UserRow(widget.myList.users),
        CupertinoButton(
          onPressed: () {
            _goToProductListView();
          },
          child: Text("ADD"),
        ),
        ListView.builder(
          physics: ScrollPhysics(),
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
                    color: Style.green,
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
                                          _editMagnitude(pro, mag);
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () {
                                          _showDeleteDialog(pro);
                                          _deleteProductFromList(pro);
                                        },
                                      ),
                                    ],
                                  ),
                                )))));
          },
        ),
      ],
    );
  }

  String _getStringFromDate(DateTime date) {
    return "${date.day} - ${date.month} - ${date.year}";
  }

  _editMagnitude(String product, String magnitude) {
    _showEditingDialog(product, magnitude);
  }

  _showEditingDialog(String product, String magnitude) {
    TextEditingController _controller = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Editing $product $magnitude"),
            content: Form(
              key: _formKey,
              child: TextFormField(
                controller: _controller,
                validator: ValidatorHelper.editingMagnitudeValidator,
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              ),
              FlatButton(
                child: Text("OK"),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    _updateMagnitude(product, magnitude, _controller.text);
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          );
        });
  }

  _showDeleteDialog(String product) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("Do you want to remove $product from this list?"),
            title: Text("Removing $product"),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              ),
              FlatButton(
                child: Text("OK"),
                onPressed: () {
                  _deleteProductFromList(product);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  _updateMagnitude(String product, String magnitude, String newMagnitude) {
    Firestore.instance.runTransaction((Transaction transaction) async {
      DocumentSnapshot snapshot = await transaction.get(reference);
      List<Map<String, dynamic>> newList = widget.myList.productList;
      newList.removeWhere((prodc) => prodc.containsValue(product));
      newList.add(
          {'productName': '$product', 'productMagnitude': '$newMagnitude'});
      await transaction.update(snapshot.reference, {"productList": newList});
    });
  }

  _deleteProductFromList(String product) {
    Firestore.instance.runTransaction((Transaction transaction) async {
      DocumentSnapshot snapshot = await transaction.get(reference);
      List<Map<String, dynamic>> newList = widget.myList.productList;
      newList.removeWhere((prodc) => prodc.containsValue(product));
      await transaction.update(snapshot.reference, {"productList": newList});
    });
  }

  _goToProductListView() {
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) =>
                ProductSelector(widget.documentID, widget.myList.productList)));
  }
}
