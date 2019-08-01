import 'package:flutter/material.dart';

class UserRow extends StatelessWidget {
  final List<String> users;
  UserRow(this.users);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: users.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[CircleAvatar(), Text(users[index])],
            ),
          );
        },
      ),
    );
  }
}
