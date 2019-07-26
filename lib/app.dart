import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:circular_bottom_navigation/tab_item.dart';
import 'package:flutter/material.dart';
import 'package:grocery_list_app/pages/homepage_screen.dart';
import 'package:grocery_list_app/pages/old_list_screen.dart';
import 'package:grocery_list_app/pages/products_screen.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  int _currentIndex = 0;
  CircularBottomNavigationController _navigationController;

  @override
  void initState() {
    super.initState();
    _navigationController = CircularBottomNavigationController(_currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [HomePageScreen(), OldListScreen(), ProductsScreen()]
          .elementAt(_currentIndex),
      bottomNavigationBar: CircularBottomNavigation(
        List.of([
          TabItem(Icons.home, "Home", Colors.blue),
          TabItem(Icons.list, "Old lists", Colors.orange),
          TabItem(Icons.layers, "Products", Colors.red),
        ]),
        controller: _navigationController,
        selectedCallback: (int selectedPos) {
          setState(
              () => _currentIndex = _navigationController.value = selectedPos);
        },
      ),
    );
  }
}
