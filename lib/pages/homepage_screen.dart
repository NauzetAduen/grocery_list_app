import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grocery_list_app/components/custom_appbar.dart';
import 'package:grocery_list_app/models/item.dart';
import 'package:grocery_list_app/models/product.dart';

class HomePageScreen extends StatefulWidget {
  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  List<Item> list;

  @override
  void initState() {
    super.initState();
    list = List<Item>();
    list.add(Item("Cocacola", 5, "latas"));
    list.add(Item("Papas", 2, "Kilos"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(Text("HomePage"), actions: <Widget>[
        IconButton(
          onPressed: () {
            _checkList();
          },
          icon: Icon(FontAwesomeIcons.plus),
        ),
      ]),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ListView.builder(
              shrinkWrap: true,
              itemCount: list.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                      "${list[index].quantity} ${list[index].magnitude} ${list[index].productName} "),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  _checkList() {
    if (list.isNotEmpty) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("List is not empty"),
              content: Text("Do you wan't to create a new list?"),
              actions: <Widget>[
                FlatButton(
                  child: Text("Cancel"),
                  onPressed: () => Navigator.pop(context),
                ),
                FlatButton(
                  child: Text("OK"),
                  onPressed: () => _createNewList(),
                ),
              ],
            );
          });
    }
  }

  _createNewList() {
    setState(() {
      list.clear();
    });
    Navigator.pop(context);
  }
}
