import 'package:flutter/material.dart';
import 'package:grocery_list_app/pages/home_page.dart';
import 'package:grocery_list_app/pages/login_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final String appName = "Grocery List App";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      theme: ThemeData(primaryColor: Colors.red),

      home: HomePage(),
    );
  }
}

