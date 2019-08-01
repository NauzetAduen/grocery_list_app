import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grocery_list_app/components/custom_appbar.dart';
import 'package:grocery_list_app/components/product_list_view.dart';
import 'package:grocery_list_app/models/grocery_list.dart';

class HomePageScreen extends StatefulWidget {
  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String uid = "Nauzet";
    return StreamBuilder<Object>(
        stream: Firestore.instance
            .collection("lists")
            .where("users", arrayContains: uid)
            .where("active", isEqualTo: true)
            //!require an index
            // .orderBy("initDate", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );
          QuerySnapshot data = snapshot.data;
          List<DocumentSnapshot> documents = data.documents;

          return Scaffold(
            appBar: CustomAppbar(Text("HomePage"), actions: <Widget>[
              IconButton(
                onPressed: () {
                  _checkList();
                },
                icon: Icon(FontAwesomeIcons.plus),
              ),
            ]),
            body: SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Column(
                children: <Widget>[
                  ListView.builder(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> mapJson = documents[index].data;
                      GroceryList myList = GroceryList.fromJson(
                          json.decode(json.encode(mapJson)));
                      return ProductListView(
                          myList, documents[index].documentID);
                    },
                  ),
                  RaisedButton(
                    onPressed: () {
                      // _testUpdate(documents[0].documentID);
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  _checkList() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("List is not empty"),
            content: Text("Do you wan't to create a new list?"),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              ),
              FlatButton(
                child: Text("OK"),
                onPressed: () => _createNewList(),
              ),
            ],
          );
        });
  }

  _createNewList() {
    setState(() {});
    Navigator.pop(context);
  }

  _testUpdate(String documentID) {
    Firestore.instance.runTransaction((Transaction transaction) async {
      DocumentReference reference =
          Firestore.instance.collection("lists").document(documentID);
      DocumentSnapshot snapshot = await transaction.get(reference);
      GroceryList a = GroceryList(
          ["Nauzet"],
          DateTime.now(),
          [
            {'productName': 'coca', 'productMagnitude': '3 kilos'},
            {'productName': 'refresco', 'productMagnitude': '4 latas'},
            {'productName': 'tomates', 'productMagnitude': '4 kilos'},
          ],
          true);

      await transaction.update(snapshot.reference, a.toJson());
    });
  }
}
