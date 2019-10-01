import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grocery_list_app/Style/style.dart';
import 'package:grocery_list_app/components/leading_appbar.dart';
import 'package:grocery_list_app/models/grocery_list.dart';
import 'package:grocery_list_app/models/user.dart';
import 'package:provider/provider.dart';

class NewGroupScreen extends StatefulWidget {
  @override
  _NewGroupScreenState createState() => _NewGroupScreenState();
}

class _NewGroupScreenState extends State<NewGroupScreen> {
  String groupName = "";
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
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              onSubmitted: (value) {
                setState(() {
                  groupName = value;
                });
              },
              decoration: InputDecoration(
                  hintText: "Add a group name",
                  errorText: groupName.isNotEmpty ? null : "Cant be empty"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              onSubmitted: (value) {
                _isValid = value.isEmpty ? false : true;
                if (_isValid) {
                  _validate(value);
                }
              },
              decoration: InputDecoration(
                  hintText: "Write a number or an username",
                  errorText: _isValid ? null : "Can't be empty"),
            ),
          ),
          Text(
            "Current users",
            style: Style.listTitleTextStyle,
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: users.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                    "${users[index].photoURL}",
                  ),
                ),
                title: Text("${users[index].username}"),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      users.removeAt(index);
                    });
                  },
                ),
              );
            },
          )
        ],
      ),
      floatingActionButton: showFAB()
          ? FloatingActionButton(
              child: Icon(FontAwesomeIcons.check),
              onPressed: () {
                if (groupName.isNotEmpty && users.isNotEmpty) {
                  GroceryList list = GroceryList(
                      finishDate: DateTime.now(),
                      productList: [],
                      title: groupName,
                      active: true,
                      users: userListToString(users));
                  Firestore.instance.collection("lists").add(list.toJson());
                  Navigator.pop(context);
                }
              },
            )
          : SizedBox(),
    );
  }

  List<String> userListToString(List<User> users) {
    List<String> usersStrings = [];
    users.forEach((user) {
      usersStrings.add(user.id);
    });
    usersStrings.add(Provider.of<FirebaseUser>(context).uid);
    return usersStrings;
  }

  _validate(String value) {
    userFound = false;
    if (value == Provider.of<FirebaseUser>(context).uid) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("You can't add yourself"),
      ));

      return;
    }
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
    return MediaQuery.of(context).viewInsets.bottom == 0.0 &&
        users.isNotEmpty &&
        groupName.isNotEmpty;
  }
}
