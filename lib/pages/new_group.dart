import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grocery_list_app/components/leading_appbar.dart';
import 'package:grocery_list_app/models/user.dart';

class NewGroupScreen extends StatefulWidget {
  @override
  _NewGroupScreenState createState() => _NewGroupScreenState();
}

class _NewGroupScreenState extends State<NewGroupScreen> {
  bool _isValid = true;
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool userFound = false;
  List<User> users = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: LeadingAppbar(Text("New group")),
      body: Column(
        children: <Widget>[
          TextField(
            onSubmitted: (value) {
              _isValid = value.isEmpty ? false : true;
              if (_isValid) {
                _validate(value);
              }
            },
            decoration: InputDecoration(
                hintText: "Write a number or username",
                errorText: _isValid ? null : "Can't be empty"),
          ),
          Text("Current users"),
          ListView.builder(
            shrinkWrap: true,
            itemCount: users.length,
            itemBuilder: (context, index) {
              return Text("${users[index].username}");
            },
          )
        ],
      ),
      floatingActionButton: showFAB()
          ? FloatingActionButton(
              child: Icon(FontAwesomeIcons.check),
              onPressed: () {
                print("Creating a new group bro");
              },
            )
          : SizedBox(),
    );
  }

  _validate(String value) {
    userFound = false;
    if (isAlreadyOnList(value)) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("$value is already on the list"),
      ));

      return;
    }
    Firestore.instance.collection('users').getDocuments().then((doc) {
      for (DocumentSnapshot document in doc.documents) {
        User user = User.fromJson(document.data);
        print("${user.username} : $value");
        if (user.username == value || user.phoneNumber == value) {
          setState(() {
            users.add(user);
            userFound = true;
          });
          print(userFound);
          break;
        }
      }
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(userFound ? "$value added" : "$value not found"),
      ));
    });
  }

  bool isAlreadyOnList(String value) {
    for (User user in users) {
      if (user.username == value || user.phoneNumber == value) return true;
    }
    return false;
  }

  bool showFAB() {
    return MediaQuery.of(context).viewInsets.bottom == 0.0 && users.isNotEmpty;
  }
}
