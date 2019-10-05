import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class IconSelectorHelper {
  static List<DropdownMenuItem<String>> list = <DropdownMenuItem<String>>[
    _buildDropDown("Default", IconFixedSize(FontAwesomeIcons.shoppingBag)),
    _buildDropDown("Cake", IconFixedSize(Icons.cake)),
    _buildDropDown("Fast Food", IconFixedSize(Icons.fastfood)),
    _buildDropDown("Medicine", IconFixedSize(Icons.local_hospital)),
    _buildDropDown("Bread", IconFixedSize(FontAwesomeIcons.breadSlice)),
    _buildDropDown("Vegetables", IconFixedSize(FontAwesomeIcons.pepperHot)),
    _buildDropDown("Pet", IconFixedSize(FontAwesomeIcons.dog)),
    _buildDropDown("Fish", IconFixedSize(FontAwesomeIcons.fish)),
    _buildDropDown("Fruits", IconFixedSize(FontAwesomeIcons.solidLemon)),
    _buildDropDown("Water", IconFixedSize(FontAwesomeIcons.wineBottle)),
  ];

  static Icon getIcon(String category) {
    switch (category) {
      case "Cake":
        return IconBiggerFixedSize(Icons.cake);
      case "Fast Food":
        return IconBiggerFixedSize(Icons.fastfood);
      case "Medicine":
        return IconBiggerFixedSize(Icons.local_hospital);
      case "Bread":
        return IconBiggerFixedSize(FontAwesomeIcons.breadSlice);
      case "Vegetables":
        return IconBiggerFixedSize(FontAwesomeIcons.pepperHot);
      case "Pet":
        return IconBiggerFixedSize(FontAwesomeIcons.dog);
      case "Fish":
        return IconBiggerFixedSize(FontAwesomeIcons.fish);
      case "Fruits":
        return IconBiggerFixedSize(FontAwesomeIcons.solidLemon);
      case "Water":
        return IconBiggerFixedSize(FontAwesomeIcons.wineBottle);
      case "Default":
      default:
        return IconBiggerFixedSize(FontAwesomeIcons.shoppingCart);
    }
  }

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

class IconBiggerFixedSize extends Icon {
  @override
  final double size = 35;

  IconBiggerFixedSize(IconData icon) : super(icon, color: getRandomColor());
}

getRandomColor() {
  Random random = Random();
  int value = random.nextInt(12);
  switch (value) {
    case 0:
      return Colors.red;
    case 1:
      return Colors.green;
    case 2:
      return Colors.grey;
    case 3:
      return Colors.indigo;
    case 4:
      return Colors.lightBlue;
    case 5:
      return Colors.orange;
    case 6:
      return Colors.pinkAccent;
    case 7:
      return Colors.purple;
    case 8:
      return Colors.amber;
    case 9:
      return Colors.brown;
    case 10:
      return Colors.cyan;
    case 11:
      return Colors.tealAccent;
    default:
      return Colors.black;
  }
}
