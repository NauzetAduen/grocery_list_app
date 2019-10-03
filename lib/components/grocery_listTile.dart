import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grocery_list_app/Style/style.dart';
import 'package:grocery_list_app/components/product_list_view.dart';
import 'package:grocery_list_app/models/grocery_list.dart';
import 'package:grocery_list_app/utils/date_helper.dart';

class GroceryListTile extends StatelessWidget {
  final GroceryList gl;
  final String documentID;

  const GroceryListTile({Key key, this.gl, this.documentID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color = gl.active ? Style.whiteYellow : Colors.grey.withOpacity(0.8);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      child: Material(
        color: color,
        elevation: 15.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(color: Colors.black)),
        child: ListTile(
          subtitle: Padding(
            padding: const EdgeInsets.only(left: 5),
            child: gl.active
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        FontAwesomeIcons.user,
                        color: Style.darkRed,
                        size: 12,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        gl.users.length.toString(),
                        style: Style.groceryListTyleUserCountTextStyle,
                      )
                    ],
                  )
                : Text(DateHelper.getStringFromDate(gl.finishDate)),
          ),
          title: Text(
            gl.title,
            style: gl.active
                ? Style.groceryListTileTextStyle
                : Style.groceryListTileInnactiveTextStyle,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.shopping_cart,
                color: Style.darkYellow,
              ),
              Text(
                gl.productList.length.toString(),
                style: Style.shopingCardTextStyle,
              )
            ],
          ),
          onTap: () {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => ProductListView(documentID)));
          },
        ),
      ),
    );
  }
}
