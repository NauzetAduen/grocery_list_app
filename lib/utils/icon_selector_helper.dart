import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class IconSelectorHelper {
  static List<DropdownMenuItem<String>> list = <DropdownMenuItem<String>>[
    _buildDropDown("Default", IconFixedSize(FontAwesomeIcons.shoppingBag)),
    _buildDropDown("Cake", IconFixedSize(Icons.cake)),
    _buildDropDown("Fast Food", IconFixedSize(Icons.fastfood)),
    _buildDropDown("Medicine", IconFixedSize(Icons.local_hospital)),
    _buildDropDown("Bread", IconFixedSize(FontAwesomeIcons.breadSlice)),
    _buildDropDown("Cheese", IconFixedSize(FontAwesomeIcons.cheese)),
    _buildDropDown("Pet", IconFixedSize(FontAwesomeIcons.dog)),
    _buildDropDown("Fish", IconFixedSize(FontAwesomeIcons.fish)),
    _buildDropDown("Fruits", IconFixedSize(FontAwesomeIcons.solidLemon)),
    _buildDropDown("Water", IconFixedSize(FontAwesomeIcons.wineBottle)),
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

class IconFixedSize extends Icon {
  @override
  final double size = 18;

  IconFixedSize(IconData icon) : super(icon);
}
