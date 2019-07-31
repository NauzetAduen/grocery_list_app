import 'package:json_annotation/json_annotation.dart';

part 'grocery_list.g.dart';

@JsonSerializable()
class GroceryList {
  String title;
  List<String> users;
  DateTime initDate;
  List<Map<String, dynamic>> productList;
  bool active;

  GroceryList(this.users, this.initDate, this.productList, this.active);
  factory GroceryList.fromJson(Map<String, dynamic> json) =>
      _$GroceryListFromJson(json);
  Map<String, dynamic> toJson() => _$GroceryListToJson(this);
}
