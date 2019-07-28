import 'package:grocery_list_app/models/item.dart';

class GroceryList {
  String title;
  DateTime initDate;
  List<Item> productList;
  bool active;

  GroceryList(this.title, this.initDate, this.productList, this.active);
}
