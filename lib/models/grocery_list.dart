import 'package:json_annotation/json_annotation.dart';

part 'grocery_list.g.dart';

@JsonSerializable()
class GroceryList {
  int groupId;
  DateTime initDate;
  List<Map<String, dynamic>> productList;
  bool active;

  GroceryList(this.groupId, this.initDate, this.productList, this.active);
  factory GroceryList.fromJson(Map<String, dynamic> json) =>
      _$GroceryListFromJson(json);
  Map<String, dynamic> toJson() => _$GroceryListToJson(this);
}
