import 'package:flutter/material.dart';

class UserRow extends StatelessWidget {
  final List<String> users;
  const UserRow(this.users);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 75,
        child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: users.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[CircleAvatar(), Text("User $index")],
                ),
              );
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
