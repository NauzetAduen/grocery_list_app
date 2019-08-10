import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_list_app/components/custom_appbar.dart';
import 'package:grocery_list_app/components/product_list_view.dart';
import 'package:grocery_list_app/models/grocery_list.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

class OldListScreen extends StatefulWidget {
  @override
  _OldListScreenState createState() => _OldListScreenState();
}

class _OldListScreenState extends State<OldListScreen> {
  final _currentPageNotifier = ValueNotifier<int>(0);
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
            .where("active", isEqualTo: false)
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
          PageController pageController = PageController();
          return Scaffold(
            appBar: CustomAppbar(
              Text("Older lists"),
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
