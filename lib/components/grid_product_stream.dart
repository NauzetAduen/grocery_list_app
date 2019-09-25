import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_list_app/components/product_grid_view.dart';
import 'package:provider/provider.dart';

class GridProductViewStreamBuilder extends StatelessWidget {
  final bool isMine;
  final String documentID;

  const GridProductViewStreamBuilder({this.isMine, this.documentID});

  @override
  Widget build(BuildContext context) {
    String userID = Provider.of<FirebaseUser>(context).uid;

    return StreamBuilder<Object>(
        stream: Firestore.instance
            .collection("products")
            .where("addedBy", isEqualTo: userID)
            .snapshots(),
        builder: (context, snapshot) {
          QuerySnapshot data = snapshot.data;
          List<DocumentSnapshot> documents = data.documents;
          return GridView.builder(
              shrinkWrap: true,
              itemCount: documents.length,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
              itemBuilder: (BuildContext context, int index) {
                return ProductGridView(document: documents[index]);
              });
        });
  }
}
