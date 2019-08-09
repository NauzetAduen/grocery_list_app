import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class IconSelectorHelper {
  static List<DropdownMenuItem<String>> list = <DropdownMenuItem<String>>[
    _buildDropDown("Default", Icon(FontAwesomeIcons.shoppingBag)),
    _buildDropDown("Cake", Icon(Icons.cake)),
    _buildDropDown("Fast Food", Icon(Icons.fastfood)),
    _buildDropDown("Coffee", Icon(Icons.local_cafe)),
    _buildDropDown("Medicine", Icon(Icons.local_hospital)),
    _buildDropDown("Pizza", Icon(Icons.local_pizza)),
    _buildDropDown("Bread", Icon(FontAwesomeIcons.breadSlice)),
    _buildDropDown("Cheese", Icon(FontAwesomeIcons.cheese)),
  ];

  static DropdownMenuItem<String> _buildDropDown(String value, Icon icon) {
    return DropdownMenuItem<String>(
      value: value,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 25),
            child: icon,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 25),
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
