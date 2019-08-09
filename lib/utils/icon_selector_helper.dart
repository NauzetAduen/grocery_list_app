import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class IconSelectorHelper {
  static List<DropdownMenuItem<String>> list = <DropdownMenuItem<String>>[
    DropdownMenuItem(
        value: "Default",
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[Icon(FontAwesomeIcons.deaf), Text("Default")],
        )),
  ];
}
