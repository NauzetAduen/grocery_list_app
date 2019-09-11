import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UserRow extends StatelessWidget {
  final List<String> users;
  const UserRow(this.users);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        CircleAvatar(
          child: IconButton(
            icon: const Icon(
              FontAwesomeIcons.plus,
              size: 20,
            ),
            onPressed: () {
              print("ADD NEW TO FUCKING GRUP");
            },
          ),
        ),
        Container(
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
                })),
      ],
    );
  }
}
