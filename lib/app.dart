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
        tabItems,
        controller: _navigationController,
        selectedCallback: (int selectedPos) {
          setState(() {
            _navigationController.value = selectedPos;
            _currentIndex = selectedPos;
          });
        },
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: _currentIndex,
      //   onTap: (newValue) {
      //     setState(() {
      //       _currentIndex = newValue;
      //     });
      //   },
      //   items: <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //         icon: Icon(
      //           Icons.home,
      //         ),
      //         title: Text("Home")),
      //     BottomNavigationBarItem(
      //         icon: Icon(
      //           Icons.list,
      //         ),
      //         title: Text("Old list")),
      //     BottomNavigationBarItem(
      //         icon: Icon(
      //           Icons.filter_list,
      //         ),
      //         title: Text("Products")),
      //   ],
      // ),
    );
  }

  List<TabItem> tabItems = List.of([
    new TabItem(Icons.home, "Home", Colors.blue),
    new TabItem(Icons.list, "Old lists", Colors.orange),
    new TabItem(Icons.layers, "Products", Colors.red),
  ]);
}
