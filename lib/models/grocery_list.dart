import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'grocery_list.g.dart';

@JsonSerializable()
class GroceryList {
  String title;
  List<String> users;
  DateTime finishDate;
  List<Map<String, dynamic>> productList;
  bool active;

  GroceryList(
      {this.title, this.users, this.finishDate, this.productList, this.active});
  factory GroceryList.fromJson(Map<String, dynamic> json) =>
      _$GroceryListFromJson(json);
  Map<String, dynamic> toJson() => _$GroceryListToJson(this);

  factory GroceryList.fromJsonFull(Map<String, dynamic> object) {
    return GroceryList.fromJson(json.decode(json.encode(object)));
  }
  factory GroceryList.fromOther(GroceryList old) {
    return GroceryList(
        title: old.title,
        users: old.users,
        finishDate: DateTime.now(),
        productList: [],
        active: true);
  }
}
