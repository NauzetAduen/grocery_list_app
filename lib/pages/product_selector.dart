import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_list_app/components/leading_appbar.dart';
import 'package:grocery_list_app/components/product_grid_view.dart';
import 'package:grocery_list_app/models/grocery_list.dart';
import 'package:grocery_list_app/models/product.dart';
import 'package:grocery_list_app/pages/new_product.dart';
import 'package:grocery_list_app/utils/icon_selector_helper.dart';
import 'package:grocery_list_app/utils/validator_helper.dart';
import 'package:provider/provider.dart';

class ProductSelector extends StatefulWidget {
  final String documentID;

  ProductSelector(this.documentID);
  @override
  _ProductSelectorState createState() => _ProductSelectorState();
}

class _ProductSelectorState extends State<ProductSelector> {
  bool isAdded = false;
  DocumentReference reference;
  String searchText = "";

  @override
  void initState() {
    super.initState();
    reference =
        Firestore.instance.collection("lists").document(widget.documentID);
  }

  @override
  Widget build(BuildContext context) {
    String userID = Provider.of<FirebaseUser>(context).uid;

    TextEditingController controller = TextEditingController();

    return Scaffold(
        appBar: LeadingAppbar(
          Text("Add products"),
        ),
        floatingActionButton: MediaQuery.of(context).viewInsets.bottom == 0.0
            ? FloatingActionButton(
                child: Text(
                  "New product",
                  textAlign: TextAlign.center,
                  textScaleFactor: 0.8,
                ),
                onPressed: () {
                  _onPress(context);
                },
              )
            : null,
        body: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Text(
              "Products added by me",
              textAlign: TextAlign.center,
            ),
            StreamBuilder<Object>(
                stream: Firestore.instance
                    .collection("products")
                    .where("addedBy", isEqualTo: userID)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return SizedBox();
                  QuerySnapshot data = snapshot.data;
                  List<DocumentSnapshot> documents = data.documents;

                  return GridView.builder(
                      shrinkWrap: true,
                      itemCount: documents.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4),
                      itemBuilder: (BuildContext context, int index) {
                        Product p = Product.fromJson(documents[index].data);
                        return GestureDetector(
                          onTap: () => _showMagnitudeDialog(p.name),
                          child: Card(
                            color: Colors.red,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                IconSelectorHelper.getIcon(p.category),
                                Text(
                                  p.name,
                                  style: TextStyle(
                                    fontSize: 19,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                }),
            Text(
              "Search other products",
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              child: TextField(
                controller: controller,
                onSubmitted: (value) {
                  setState(() {
                    searchText = value;
                    print(searchText.toString());
                  });
                },
              ),
            ),
            StreamBuilder<Object>(
                stream: Firestore.instance
                    .collection("products")
                    // .where("addedBy", isLessThan: userID)
                    .snapshots(),
                builder: (context, snapshot) {
                  List<Product> productOthersList = [];
                  QuerySnapshot q = snapshot.data;
                  q.documents.forEach((doc) {
                    Product p = Product.fromJson(doc.data);
                    if (p.addedBy != userID &&
                            p.category
                                .toLowerCase()
                                .contains(searchText.toLowerCase()) ||
                        p.name.toLowerCase().contains(searchText.toLowerCase()))
                      productOthersList.add(p);
                  });
                  if (searchText.isEmpty)
                    return SizedBox();
                  else
                    return GridView.builder(
                        shrinkWrap: true,
                        itemCount: productOthersList.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4),
                        itemBuilder: (BuildContext context, int index) {
                          Product p = productOthersList[index];

                          return GestureDetector(
                            onTap: () => _showMagnitudeDialog(p.name),
                            child: Card(
                              color: Colors.blue,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  IconSelectorHelper.getIcon(p.category),
                                  Text(
                                    p.name,
                                    style: TextStyle(
                                      fontSize: 19,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                }),
          ],
        ));
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

  Future _addProductToList(String newProduct, String newMagnitude) async {
    reference.get().then((onValue) {
      GroceryList gl = GroceryList.fromJsonFull(onValue.data);

      List<Map<String, dynamic>> newList = gl.productList;
      Firestore.instance.runTransaction((Transaction transaction) async {
        DocumentSnapshot snapshot = await transaction.get(reference);
        newList.add({
          'productName': '$newProduct',
          'productMagnitude': '$newMagnitude'
        });
        await transaction.update(snapshot.reference, {"productList": newList});
      });
    });
  }
}
