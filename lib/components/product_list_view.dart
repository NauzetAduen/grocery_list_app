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
                icon: Icon(FontAwesomeIcons.check),
                onPressed: () {
                  _showFinishDialog(gl);
                },
              )
            ],
          ),
          body: ListView(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            children: <Widget>[
              UserRow(gl.users),
              FlatButton(
                child: Text("+ Add new product"),
                onPressed: () {
                  _goToProductListView();
                },
              ),
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
  }

  _editMagnitude(String product, String magnitude) {
    _showEditingDialog(product, magnitude);
  }

  _showFinishDialog(GroceryList gl) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Finishing ${gl.title}"),
            content: Text(
                "Do you want to finish ${gl.title}?\nA new list will be created"),
            actions: <Widget>[
              FlatButton(
                child: Text("No"),
                onPressed: () => Navigator.pop(context),
              ),
              FlatButton(
                  child: Text("Yes"),
                  onPressed: () {
                    _finishList();
                    _createNewList(gl);
                    Navigator.pop(context);
                  }),
            ],
          );
        });
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

  _finishList() {
    Firestore.instance.runTransaction((Transaction transaction) async {
      DocumentSnapshot snapshot = await transaction.get(reference);
      await transaction.update(snapshot.reference,
          {"active": false, "finishDate": DateTime.now().toIso8601String()});
    });
  }

  _createNewList(GroceryList oldGroceryList) {
    GroceryList newGroceryList = GroceryList.fromOther(oldGroceryList);
    Firestore.instance.collection("lists").add(newGroceryList.toJson());
    Navigator.popUntil(context, (route) => route.isFirst);
  }
  // String title;
  // List<String> users;
  // DateTime finishDate;
  // List<Map<String, dynamic>> productList;
  // bool active;

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

  _goToProductListView() {
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => ProductSelector(widget.documentID)));
  }
}
