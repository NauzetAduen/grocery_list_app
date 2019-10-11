import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grocery_list_app/Style/style.dart';
import 'package:grocery_list_app/components/custom_appbar.dart';
import 'package:grocery_list_app/components/grocery_list_streambuilder.dart';
import 'package:grocery_list_app/models/user.dart';
import 'package:grocery_list_app/pages/image_picker_screen.dart';
import 'package:grocery_list_app/pages/new_group.dart';
import 'package:grocery_list_app/pages/new_product.dart';
import 'package:grocery_list_app/utils/validator_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class HomePageScreen extends StatefulWidget {
  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  String userID;
  String documentID;
  File _imageFile;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    userID = Provider.of<FirebaseUser>(context).uid;

    // User myUser;
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
                      // myUser = user;
                      documentID = list[i].documentID;
                      break;
                    }
                  }
                  return StreamBuilder<Object>(
                      stream: Firestore.instance
                          .collection("users")
                          .document(documentID)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return CircularProgressIndicator();
                        DocumentSnapshot snap = snapshot.data;
                        User myUser = User.fromJson(snap.data);
                        return DrawerHeader(
                          child: Stack(
                            children: <Widget>[
                              Align(
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundImage: myUser.photoURL.isEmpty
                                      ? AssetImage(
                                          "assets/images/defaultprofilepicture.jpg")
                                      : NetworkImage(myUser.photoURL),
                                ),
                                alignment: Alignment.centerRight,
                              ),
                              Align(
                                  alignment:
                                      Alignment.centerLeft + Alignment(.1, 0),
                                  child: Text(
                                    myUser.username.isNotEmpty
                                        ? myUser.username
                                        : "@username",
                                    style: Style.drawerUsername,
                                  ))
                            ],
                          ),
                          decoration: BoxDecoration(color: Style.lightYellow),
                        );
                      });
                },
              ),
              ListTile(
                title: Text(
                  "Logout for testing",
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
                onTap: () {
                  FirebaseAuth.instance.signOut();
                },
              ),
              ListTile(
                title: Text(
                  "Edit @username",
                  style: Style.drawerListTileTextStyle,
                ),
                onTap: () {
                  _showNewUserNameDialog();
                },
              ),
              ListTile(
                title: Text(
                  "Edit @picture",
                  style: Style.drawerListTileTextStyle,
                ),
                onTap: () {
                  // _showEditPictureDialog();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ImagePickerScreen()));
                },
              ),
              Divider(
                color: Style.whiteYellow,
                thickness: 2,
              ),
              ListTile(
                title: Text(
                  "New product",
                  style: Style.drawerListTileTextStyle,
                ),
                onTap: () => Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => NewProduct())),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NewGroupScreen()));
                },
                title: Text(
                  "New group",
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

  void _showNewUserNameDialog() {
    TextEditingController _controller = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Style.darkBlue,
            title: Text("New username", style: Style.addPhoneTextFieldStyle),
            content: Form(
              key: _formKey,
              child: TextFormField(
                validator: ValidatorHelper.genericEmptyValidator,
                controller: _controller,
                style: Style.addPhoneTextFieldStyle,
                cursorColor: Style.whiteYellow,
                decoration: InputDecoration(
                  hintText: "Enter an unique username",
                  hintStyle: Style.hintLoginNumberTextStyle,
                  prefixIcon: Icon(
                    FontAwesomeIcons.textHeight,
                    color: Style.whiteYellow,
                  ),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Style.whiteYellow)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Style.lightYellow)),
                ),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                color: Style.darkRed,
                child: Text("Cancel", style: Style.dialogFlatButtonTextStyle),
                onPressed: () => Navigator.pop(context),
              ),
              FlatButton(
                  color: Style.darkYellow,
                  child: Text(
                    "Yes",
                    style: Style.dialogFlatButtonTextStyle,
                  ),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      Firestore.instance
                          .runTransaction((Transaction transaction) async {
                        DocumentReference reference = Firestore.instance
                            .collection("users")
                            .document(documentID);
                        DocumentSnapshot snapshot =
                            await transaction.get(reference);
                        await transaction.update(snapshot.reference, {
                          "username": _controller.text,
                        });
                      });
                      Navigator.pop(context);
                    }
                  }),
            ],
          );
        });
  }
}
