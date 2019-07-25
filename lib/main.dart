import 'package:flutter/material.dart';
import 'package:grocery_list_app/app.dart';

import 'Style/style.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final String appName = "Grocery List App";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      theme: ThemeData(primaryColor: Style.green),
      home: App(),
    );
  }
}
