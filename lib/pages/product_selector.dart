import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grocery_list_app/Style/style.dart';
import 'package:grocery_list_app/components/leading_appbar.dart';
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
        backgroundColor: Style.darkBlue,
        appBar: LeadingAppbar(
          Text(
            "Add products",
            style: Style.appbarStyle,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: MediaQuery.of(context).viewInsets.bottom == 0.0
            ? FloatingActionButton(
                backgroundColor: Style.darkYellow,
                child: Icon(FontAwesomeIcons.plus),
                onPressed: () {
                  _onPress(context);
                },
              )
            : null,
        body: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Text(
                "Products added by me",
                textAlign: TextAlign.center,
                style: Style.grocerylistTitleTextStyle,
              ),
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
                          crossAxisCount: 5),
                      itemBuilder: (BuildContext context, int index) {
                        Product p = Product.fromJson(documents[index].data);
                        return GestureDetector(
                          onTap: () => _showMagnitudeDialog(p.name),
                          child: Card(
                            color: Style.whiteYellow,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                IconSelectorHelper.getIcon(p.category),
                                Text(
                                  p.name,
                                  style: Style.gridTextStyle,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                }),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Text(
                "Search other products",
                textAlign: TextAlign.center,
                style: Style.grocerylistTitleTextStyle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              child: TextField(
                cursorColor: Style.whiteYellow,
                style: Style.addPhoneTextFieldStyle,
                decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Style.whiteYellow)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Style.lightYellow)),
                    hintText: "Enter a product",
                    hintStyle: Style.hintLoginNumberTextStyle,
                    prefixIcon: Icon(
                      FontAwesomeIcons.shoppingBag,
                      color: Style.whiteYellow,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: Style.whiteYellow,
                      ),
                      onPressed: () {
                        setState(() {
                          searchText = "";
                        });
                      },
                    )),
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
                stream: Firestore.instance.collection("products").snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return SizedBox();
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
                            crossAxisCount: 5),
                        itemBuilder: (BuildContext context, int index) {
                          Product p = productOthersList[index];

                          return GestureDetector(
                            onTap: () => _showMagnitudeDialog(p.name),
                            child: Card(
                              color: Style.whiteYellow,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  IconSelectorHelper.getIcon(p.category),
                                  Text(
                                    p.name,
                                    style: Style.gridTextStyle,
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

  _showMagnitudeDialog(String product) {
    TextEditingController _controller = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Style.darkBlue,
            title: Text("Add a magnitude for $product",
                style: Style.addPhoneTextFieldStyle),
            content: Form(
                key: _formKey,
                child: TextFormField(
                  cursorColor: Style.whiteYellow,
                  controller: _controller,
                  validator: ValidatorHelper.editingMagnitudeValidator,
                  style: Style.addPhoneTextFieldStyle,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Style.whiteYellow)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Style.lightYellow)),
                    hintText: "Enter a magnitude",
                    hintStyle: Style.hintLoginNumberTextStyle,
                    prefixIcon: Icon(
                      FontAwesomeIcons.shoppingBag,
                      color: Style.whiteYellow,
                    ),
                  ),
                )),
            actions: <Widget>[
              FlatButton(
                color: Style.darkRed,
                child: Text("Cancel", style: Style.dialogActionsTextStyle),
                onPressed: () => Navigator.pop(context),
              ),
              FlatButton(
                color: Style.darkYellow,
                child: Text("OK", style: Style.dialogActionsTextStyle),
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
