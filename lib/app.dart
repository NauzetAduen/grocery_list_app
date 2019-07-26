import 'package:flutter/material.dart';
import 'package:grocery_list_app/pages/homepage_screen.dart';
import 'package:grocery_list_app/pages/old_list_screen.dart';
import 'package:grocery_list_app/pages/products_screen.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [HomePageScreen(), OldListScreen(), ProductsScreen()]
          .elementAt(_currentIndex),
      bottomNavigationBar: TitledBottomNavigationBar(
          // reverse: true,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          currentIndex: _currentIndex,
          items: [
            TitledNavigationBarItem(title: "Home", icon: Icons.home),
            TitledNavigationBarItem(title: "Old lists", icon: Icons.list),
            TitledNavigationBarItem(title: "Products", icon: Icons.layers)
          ]),
    );
  }
}
