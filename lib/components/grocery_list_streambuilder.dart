import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_list_app/components/grocery_listTile.dart';
import 'package:grocery_list_app/models/grocery_list.dart';

class GroceryListStreamBuilder extends StatelessWidget {
  final bool active;
  final String userID;
  const GroceryListStreamBuilder({this.active, this.userID});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: Firestore.instance
            .collection("lists")
            .where("users", arrayContains: userID)
            .where("active", isEqualTo: active)
            .snapshots(),
        builder: (context, snapshot) {
          QuerySnapshot data;
          List<DocumentSnapshot> documents;
          if (snapshot.hasData) {
            data = snapshot.data;
            documents = data.documents;
          } else {
            return SizedBox();
          }
          return ListView.builder(
            shrinkWrap: true,
            itemCount: documents.length,
            itemBuilder: (BuildContext context, int index) {
              GroceryList gl = GroceryList.fromJsonFull(documents[index].data);
              return GroceryListTile(
                  gl: gl, documentID: documents[index].documentID);
            },
          );
        });
  }
}
