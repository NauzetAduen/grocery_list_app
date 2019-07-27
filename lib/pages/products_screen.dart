import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grocery_list_app/components/custom_appbar.dart';
import 'package:grocery_list_app/components/product_grid_view.dart';
import 'package:grocery_list_app/pages/new_product.dart';

class ProductsScreen extends StatelessWidget {
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
            appBar: CustomAppbar(Text("Products screen"), actions: <Widget>[
              IconButton(
                onPressed: () => _onPress(context),
                icon: Icon(FontAwesomeIcons.plus),
              ),
            ]),
            body: GridView.builder(
              itemCount: snap.documents.length,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              itemBuilder: (BuildContext context, int index) {
                return ProductGridView(document: snap.documents[index]);
              },
            ),
          );
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
}
