import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_list_app/Style/style.dart';
import 'package:grocery_list_app/models/user.dart';

class UserRow extends StatelessWidget {
  final List<String> users;
  const UserRow(this.users);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 80,
        child: FutureBuilder<Object>(
            future: Firestore.instance.collection("users").getDocuments(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return SizedBox();
              QuerySnapshot querySnapshot = snapshot.data;
              List<DocumentSnapshot> list = querySnapshot.documents;
              List<User> groupUsers = [];
              list.forEach((doc) {
                User tempUser = User.fromJson(doc.data);
                if (users.contains(tempUser.id)) groupUsers.add(tempUser);
              });
              return ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: groupUsers.length,
                  itemBuilder: (context, index) {
                    User user = groupUsers[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          CircleAvatar(
                            backgroundImage: NetworkImage("${user.photoURL}"),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "${user.username}",
                            style: Style.addPhoneTextFieldStyle,
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    );
                  });
            }));
  }
}
