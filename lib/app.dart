import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grocery_list_app/Style/style.dart';
import 'package:grocery_list_app/pages/homepage_screen.dart';
import 'package:grocery_list_app/pages/old_list_screen.dart';
import 'package:grocery_list_app/pages/products_screen.dart';
import 'package:grocery_list_app/pages/profile_screen.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  int _currentIndex = 0;
  static const iconSize = 22.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [
        HomePageScreen(),
        OldListScreen(),
        ProductsScreen(),
        ProfileScreen()
      ].elementAt(_currentIndex),
      bottomNavigationBar: CurvedNavigationBar(
        height: 50,
        backgroundColor: Colors.transparent,
        color: Style.green,
        index: _currentIndex,
        items: <Widget>[
          Icon(
            FontAwesomeIcons.layerGroup,
            size: iconSize,
          ),
          Icon(
            FontAwesomeIcons.list,
            size: iconSize,
          ),
          Icon(
            Icons.fastfood,
            size: iconSize,
          ),
          Icon(
            FontAwesomeIcons.userAlt,
            size: iconSize,
          ),
        ],
        onTap: (newIndex) {
          setState(() {
            _currentIndex = newIndex;
          });
        },
      ),
    );
  }
}
