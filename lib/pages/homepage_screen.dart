import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grocery_list_app/Style/style.dart';
import 'package:grocery_list_app/components/custom_appbar.dart';
import 'package:grocery_list_app/components/grocery_list_streambuilder.dart';
import 'package:grocery_list_app/models/user.dart';
import 'package:grocery_list_app/pages/new_group.dart';
import 'package:grocery_list_app/pages/new_product.dart';
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
    User myUser;
    return Scaffold(
      backgroundColor: Style.darkBlue,
      drawer: Drawer(
        child: Container(
          color: Style.darkBlue,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              FutureBuilder(
                future: Firestore.instance.collection("users").getDocuments(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return DrawerHeader(
                      child: CircularProgressIndicator(),
                    );
                  QuerySnapshot querySnapshot = snapshot.data;
                  List<DocumentSnapshot> list = querySnapshot.documents;
                  for (int i = 0; i < list.length; i++) {
                    User user = User.fromJson(list[i].data);
                    if (user.id == userID) {
                      myUser = user;
                      break;
                    }
                  }
                  return DrawerHeader(
                    child: Stack(
                      children: <Widget>[
                        Align(
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(myUser.photoURL),
                          ),
                          alignment: Alignment.centerRight,
                        ),
                        Align(
                          alignment: Alignment.centerLeft + Alignment(.1, 0),
                          child: Text(
                            myUser.username,
                            style: Style.drawerUsername,
                          ),
                        )
                      ],
                    ),
                    decoration: BoxDecoration(color: Style.lightYellow),
                  );
                },
              ),
              ListTile(
                title: Text("Logout for testing"),
                onTap: () {
                  FirebaseAuth.instance.signOut();
                },
              ),
              ListTile(
                title: Text(
                  "Change your @Username",
                  style: Style.drawerListTileTextStyle,
                ),
              ),
              ListTile(
                title: Text(
                  "New product",
                  style: Style.drawerListTileTextStyle,
                ),
                onTap: () => Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => NewProduct())),
              ),
              Divider(
                color: Style.whiteYellow,
                thickness: 2,
              ),
              ListTile(
                title: Text(
                  "New group",
                  style: Style.drawerListTileTextStyle,
                ),
              ),
              ListTile(
                title: Text(
                  "Leave a group",
                  style: Style.drawerListTileTextStyle,
                ),
              ),
              ListTile(
                title: Text(
                  "Invite someone to a group",
                  style: Style.drawerListTileTextStyle,
                ),
              ),
            ],
          ),
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
          child: Center(child: Icon(FontAwesomeIcons.plus))),
    );
  }
}
