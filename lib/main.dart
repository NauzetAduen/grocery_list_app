import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_list_app/grocery_list_app.dart';
import 'package:provider/provider.dart';

import 'Style/style.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final String appName = "Grocery List App";
  @override
  Widget build(BuildContext context) {
    return StreamProvider<QuerySnapshot>.value(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: appName,
        theme: ThemeData(primaryColor: Style.green),
        home: GroceryListApp(),
      ),
      value: Firestore.instance.collection("products").snapshots(),
    );
  }
}
