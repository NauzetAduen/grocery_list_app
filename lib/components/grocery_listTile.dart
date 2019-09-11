import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grocery_list_app/models/grocery_list.dart';

class GroceryListTile extends StatelessWidget {
  final GroceryList gl;

  const GroceryListTile({Key key, this.gl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color = gl.active ? Colors.red : Colors.grey;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: color,
        child: ListTile(
            title: Text(gl.title),
            trailing:
                gl.active ? Text("") : Text(gl.finishDate.toIso8601String())),
      ),
    );
  }
}
