import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_list_app/models/user.dart';

class UserRow extends StatelessWidget {
  final List<String> users;
  const UserRow(this.users);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 75,
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
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          CircleAvatar(
                            backgroundImage: NetworkImage("${user.photoURL}"),
                          ),
                          Text("${user.username}")
                        ],
                      ),
                    );
                  });
            }));
  }
}

//  CircleAvatar(
//           child: IconButton(
//             icon: const Icon(
//               FontAwesomeIcons.plus,
//               size: 20,
//             ),
//             onPressed: () {
//               print("ADD NEW TO FUCKING GRUP");
//             },
//           ),
//         ),
