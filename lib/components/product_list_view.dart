import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grocery_list_app/components/leading_appbar.dart';
import 'package:grocery_list_app/components/user_row.dart';
import 'package:grocery_list_app/models/grocery_list.dart';
import 'package:grocery_list_app/pages/product_selector.dart';
import 'package:grocery_list_app/utils/validator_helper.dart';

class ProductListView extends StatefulWidget {
  final String documentID;
  ProductListView(this.documentID);
  @override
  _ProductListViewState createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  DocumentReference reference;
  List<Map<String, dynamic>> productList = [];

  @override
  void initState() {
    super.initState();
    reference =
        Firestore.instance.collection("lists").document(widget.documentID);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection("lists")
          .document(widget.documentID)
          .snapshots(),
      builder: (context, snapshot) {
        GroceryList gl;
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.done:
            return SizedBox();
          case ConnectionState.active:
            gl = GroceryList.fromJsonFull(snapshot.data.data);
        }
        productList = gl.productList;
        return Scaffold(
          appBar: LeadingAppbar(
            Text("${gl.title}"),
            actions: <Widget>[
              IconButton(
                icon: Icon(FontAwesomeIcons.plus),
                onPressed: () {
                  _goToProductListView(gl.productList);
                },
              ),
              IconButton(
                icon: Icon(FontAwesomeIcons.check),
                onPressed: () {
                  print("AA");
                },
              )
            ],
          ),
          body: ListView(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            children: <Widget>[
              UserRow(gl.users),
              ListView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                itemCount: gl.productList.length,
                itemBuilder: (context, index) {
                  var item = gl.productList[index];
                  String pro = item['productName'];
                  String mag = item['productMagnitude'];
                  return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: Material(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.yellow,
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
                                                // _deleteProductFromList(pro);
                                              },
                                            ),
                                          ],
                                        ),
                                      )))));
                },
              )
            ],
          ),
        );
      },
    );
    // floatingActionButton: Row(
    //   mainAxisSize: MainAxisSize.min,
    //   children: <Widget>[
    //     FloatingActionButton(
    //       child: Text(
    //         "Add product",
    //         textAlign: TextAlign.center,
    //         textScaleFactor: 0.8,
    //       ),
    //       onPressed: () {
    //         // _goToProductListView();
    //       },
    //     ),
    //     SizedBox(
    //       width: 10,
    //     ),
    //     FloatingActionButton(
    //       heroTag: "",
    //       child: Text("Finish"),
    //       onPressed: () {
    //         _finishListAndCreateNew();
    //       },
    //     ),
    //   ],
    // ));
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

  _finishListAndCreateNew() {
    Firestore.instance.runTransaction((Transaction transaction) async {
      DocumentSnapshot snapshot = await transaction.get(reference);
      // List<Map<String, dynamic>> newList = widget.myList.productList;
      // newList.removeWhere((prodc) => prodc.containsValue(product));
      // newList.add(
      //     {'productName': '$product', 'productMagnitude': '$newMagnitude'});
      await transaction.update(snapshot.reference, {"active": false});
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
      List<Map<String, dynamic>> newList = productList;
      newList.removeWhere((prodc) => prodc.containsValue(product));
      newList.add(
          {'productName': '$product', 'productMagnitude': '$newMagnitude'});
      await transaction.update(snapshot.reference, {"productList": newList});
    });
  }

  _deleteProductFromList(String product) {
    Firestore.instance.runTransaction((Transaction transaction) async {
      DocumentSnapshot snapshot = await transaction.get(reference);
      List<Map<String, dynamic>> newList = productList;
      newList.removeWhere((prodc) => prodc.containsValue(product));
      await transaction.update(snapshot.reference, {"productList": newList});
    });
  }

  _goToProductListView(List<Map<String, dynamic>> productList) {
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => ProductSelector(widget.documentID)));
  }
}
