import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_list_app/components/custom_appbar.dart';
import 'package:grocery_list_app/components/grocery_listTile.dart';
import 'package:grocery_list_app/components/product_list_view.dart';
import 'package:grocery_list_app/models/grocery_list.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
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
          QuerySnapshot data = snapshot.data;
          List<DocumentSnapshot> documents = data.documents;
          return Scaffold(
            appBar: CustomAppbar(
              Text("Home"),
            ),
            body: ListView.builder(
              itemCount: documents.length,
              itemBuilder: (BuildContext context, int index) {
                GroceryList gl =
                    GroceryList.fromJsonFull(documents[index].data);
                return GroceryListTile(gl: gl);
              },
            ),
          );
        });
  }
}
