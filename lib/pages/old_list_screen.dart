import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_list_app/components/custom_appbar.dart';
import 'package:grocery_list_app/models/grocery_list.dart';

class OldListScreen extends StatefulWidget {
  @override
  _OldListScreenState createState() => _OldListScreenState();
}

class _OldListScreenState extends State<OldListScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String uid = "Nauzet";
    return Scaffold(
      appBar: CustomAppbar(Text("Old lists")),
      body: StreamBuilder<Object>(
        stream: Firestore.instance
            .collection("lists")
            .where("users", arrayContains: uid)
            .where("active", isEqualTo: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );
          QuerySnapshot data = snapshot.data;
          List<DocumentSnapshot> documents = data.documents;

          return ListView.builder(
            shrinkWrap: true,
            itemCount: documents.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> mapJson = documents[index].data;
              GroceryList tempList =
                  GroceryList.fromJson(json.decode(json.encode(mapJson)));
              return Text("${tempList.title}");
            },
          );
        },
      ),
    );
  }
}
