import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_list_app/components/custom_appbar.dart';
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
  final _currentPageNotifier = ValueNotifier<int>(0);
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
            .where("active", isEqualTo: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );
          QuerySnapshot data = snapshot.data;
          List<DocumentSnapshot> documents = data.documents;
          PageController pageController = PageController();
          print(documents.length);
          return Scaffold(
            appBar: CustomAppbar(
              Text("Home"),
            ),
            body: Stack(children: <Widget>[
              PageView.builder(
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> mapJson = documents[index].data;
                  GroceryList myList =
                      GroceryList.fromJson(json.decode(json.encode(mapJson)));
                  return ProductListView(myList, documents[index].documentID);
                },
                controller: pageController,
                onPageChanged: (index) {
                  _currentPageNotifier.value = index;
                },
              ),
              Positioned(
                left: 0.0,
                right: 0.0,
                bottom: 0.0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CirclePageIndicator(
                    size: 10,
                    selectedSize: 15,
                    selectedDotColor: Colors.red,
                    itemCount: documents.length,
                    currentPageNotifier: _currentPageNotifier,
                  ),
                ),
              )
            ]),
          );
        });
  }
}
