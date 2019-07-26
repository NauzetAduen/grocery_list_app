import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:grocery_list_app/Style/style.dart';
import 'package:grocery_list_app/pages/homepage_screen.dart';
import 'package:grocery_list_app/pages/old_list_screen.dart';
import 'package:grocery_list_app/pages/products_screen.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [HomePageScreen(), OldListScreen(), ProductsScreen()]
          .elementAt(_currentIndex),
      bottomNavigationBar: CurvedNavigationBar(
        height: 50,
        backgroundColor: Colors.transparent,
        color: Style.green,
        index: _currentIndex,
        items: <Widget>[
          Icon(
            Icons.home,
          ),
          Icon(
            Icons.list,
          ),
          Icon(
            Icons.fastfood,
          ),
        ],
        onTap: (newIndex) {
          setState(() {
            _currentIndex = newIndex;
          });
        },
      ),
    );
    // bottomNavigationBar: BottomNavyBar(
    //   selectedIndex: _currentIndex,
    //   onItemSelected: (int value) {
    //     setState(() {
    //       _currentIndex = value;
    //     });
    //   },
    //   items: [
    //     BottomNavyBarItem(
    //         title: Text("Home"),
    //         icon: Icon(Icons.home),
    //         activeColor: Colors.green),
    //     BottomNavyBarItem(title: Text("Old lists"), icon: Icon(Icons.list)),
    //     BottomNavyBarItem(
    //         title: Text("Products"),
    //         icon: Icon(Icons.fastfood),
    //         activeColor: Colors.red),
    //   ],
    // ));
  }
}
