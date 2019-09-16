import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grocery_list_app/components/leading_appbar.dart';
import 'package:grocery_list_app/models/product.dart';
import 'package:grocery_list_app/pages/new_product.dart';
import 'package:grocery_list_app/utils/icon_selector_helper.dart';
import 'package:grocery_list_app/utils/validator_helper.dart';

class ProductSelector extends StatefulWidget {
  final String documentID;
  final List<Map<String, dynamic>> productList;

  ProductSelector(this.documentID, this.productList);
  @override
  _ProductSelectorState createState() => _ProductSelectorState();
}

class _ProductSelectorState extends State<ProductSelector> {
  bool isAdded = false;
  DocumentReference reference;

  @override
  void initState() {
    super.initState();
    reference =
        Firestore.instance.collection("lists").document(widget.documentID);
  }

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
              appBar: LeadingAppbar(
                Text("Add products"),
              ),
              floatingActionButton: FloatingActionButton(
                child: Text(
                  "New product",
                  textAlign: TextAlign.center,
                  textScaleFactor: 0.8,
                ),
                onPressed: () {
                  _onPress(context);
                },
              ),
              body: GridView.builder(
                itemCount: snap.documents.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemBuilder: (BuildContext context, int index) {
                  Product product =
                      Product.fromJson(snap.documents[index].data);
                  isAdded = _isAdded(widget.productList, product.name);
                  return GestureDetector(
                    onTap: () {
                      _showMagnitudeDialog(product.name);
                    },
                    child: Card(
                      color: isAdded ? Colors.grey : Colors.red,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          IconSelectorHelper.getIcon(product.category),
                          Text(
                            product.name,
                            style: TextStyle(fontSize: 22),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ));
        });
  }

  _onPress(BuildContext context) async {
    var result = await Navigator.push(
        context, CupertinoPageRoute(builder: (context) => NewProduct()));

    if (result != null) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("$result added"),
        duration: Duration(milliseconds: 4000),
      ));
    }
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

  bool _isAdded(List<Map<String, dynamic>> list, String productName) {
    bool found = false;
    list.forEach((doc) {
      if (doc['productName'].toString().toLowerCase() ==
          productName.toLowerCase()) {
        found = true;
        return;
      }
    });
    return found;
  }

  _showMagnitudeDialog(String product) {
    bool found = false;
    widget.productList.forEach((doc) {
      if (doc['productName'].toString().toLowerCase() ==
          product.toLowerCase()) {
        found = true;
        return;
      }
    });
    if (!found) {
      TextEditingController _controller = TextEditingController();
      final _formKey = GlobalKey<FormState>();
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Add a magnitude for $product"),
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
                      _addProductToList(product, _controller.text);
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            );
          });
    }
  }

  Future _addProductToList(String newProduct, String newMagnitude) async {
    List<Map<String, dynamic>> newList = widget.productList;
    Firestore.instance.runTransaction((Transaction transaction) async {
      DocumentSnapshot snapshot = await transaction.get(reference);
      newList.add(
          {'productName': '$newProduct', 'productMagnitude': '$newMagnitude'});
      await transaction.update(snapshot.reference, {"productList": newList});
    });
  }
}
