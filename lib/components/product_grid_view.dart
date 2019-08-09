import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_list_app/models/product.dart';
import 'package:grocery_list_app/utils/icon_selector_helper.dart';

class ProductGridView extends StatelessWidget {
  final DocumentSnapshot document;

  const ProductGridView({Key key, this.document}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Product product = Product.fromJson(document.data);
    // String name = document['name'];
    return GestureDetector(
      onTap: () => _showDialog(context, product),
      child: Card(
        color: Colors.red,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconSelectorHelper.getIcon(product.category),
            Text(
              product.name,
              style: TextStyle(
                fontSize: 19,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  _showDialog(BuildContext context, Product product) {
    double width = MediaQuery.of(context).size.width / 3;
    double height = MediaQuery.of(context).size.height / 4;

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  product.name,
                  textAlign: TextAlign.center,
                ),
                Text(
                  product.used.toString(),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            content: Container(
              width: width,
              height: height,
              child: DecoratedBox(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/example.jpg'))),
              ),
            ),
          );
        });
  }
}
