import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_list_app/Style/style.dart';
import 'package:grocery_list_app/components/custom_appbar.dart';
import 'package:grocery_list_app/components/grocery_list_streambuilder.dart';
import 'package:grocery_list_app/pages/new_group.dart';
import 'package:provider/provider.dart';

class HomePageScreen extends StatefulWidget {
  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  String userID;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    userID = Provider.of<FirebaseUser>(context).uid;

    return Scaffold(
      backgroundColor: Style.darkBlue,
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Text("Options"),
              decoration: BoxDecoration(color: Style.lightYellow),
            ),
            ListTile(
              title: Text("Logout"),
            ),
            ListTile(
              title: Text("check product list"),
            ),
            ListTile(
              title: Text("Change username"),
            ),
          ],
        ),
      ),
      appBar: CustomAppbar(
        Text(
          "Home",
          style: Style.appbarStyle,
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Align(
              child: Text(
                "Active",
                style: Style.grocerylistTitleTextStyle,
              ),
              alignment: Alignment.center,
            ),
          ),
          GroceryListStreamBuilder(userID: userID, active: true),
          Align(
            child: Text(
              "Inactive",
              style: Style.grocerylistTitleTextStyle,
            ),
            alignment: Alignment.center,
          ),
          GroceryListStreamBuilder(userID: userID, active: false),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => NewGroupScreen()));
          },
          backgroundColor: Style.darkYellow,
          child: Center(
              child: Text(
            "New group",
            style: Style.fabTextStyle,
            textAlign: TextAlign.center,
          ))),
    );
  }
}
