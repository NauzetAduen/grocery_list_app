import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grocery_list_app/components/custom_appbar.dart';

class HomePageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(Text("HomePage"), actions: <Widget>[
        IconButton(
          onPressed: () => print("FIESHTA"),
          icon: Icon(FontAwesomeIcons.plus),
        ),
      ]),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[],
        ),
      ),
    );
  }
}
