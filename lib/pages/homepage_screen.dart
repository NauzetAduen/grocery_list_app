import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grocery_list_app/Style/style.dart';
import 'package:grocery_list_app/components/custom_appbar.dart';
import 'package:grocery_list_app/components/grocery_list_streambuilder.dart';
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

    return StreamBuilder<Object>(
        stream: Firestore.instance
            .collection("lists")
            .where("users", arrayContains: userID)
            // .where("active", isEqualTo: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );
          // QuerySnapshot data = snapshot.data;
          // List<DocumentSnapshot> documents = data.documents;
          return Scaffold(
            drawer: Drawer(
              child: ListView(
                children: <Widget>[
                  DrawerHeader(
                    child: Text("Options"),
                    decoration: BoxDecoration(color: Style.green),
                  ),
                  ListTile(
                    title: Text("Item 1"),
                  ),
                  ListTile(
                    title: Text("Item 2"),
                  ),
                  ListTile(
                    title: Text("Item 3"),
                  ),
                ],
              ),
            ),
            appBar: CustomAppbar(
              Text("Home"),
            ),
            body: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Align(
                  child: Text("active"),
                  alignment: Alignment.center,
                ),
                GroceryListStreamBuilder(userID: userID, active: true),
                Align(
                  child: Text("Innactive"),
                  alignment: Alignment.center,
                ),
                GroceryListStreamBuilder(userID: userID, active: false),
              ],
            ),
            floatingActionButton: FloatingActionButton(
                onPressed: () {
                  print("Pressed");
                },
                backgroundColor: Style.green,
                child: Center(
                    child: Text(
                  "New group",
                  textAlign: TextAlign.center,
                ))),
          );
        });
  }
}
