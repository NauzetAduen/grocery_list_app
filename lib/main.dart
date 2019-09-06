import 'package:flutter/material.dart';
import 'package:grocery_list_app/grocery_list_app.dart';

import 'Style/style.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final String appName = "Grocery List App";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appName,
      theme: ThemeData(primaryColor: Style.green),
      home: GroceryListApp(),
    );
  }
}
