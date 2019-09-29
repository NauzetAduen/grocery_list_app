// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grocery_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroceryList _$GroceryListFromJson(Map<String, dynamic> json) {
  return GroceryList(
    title: json['title'] as String,
    users: (json['users'] as List)?.map((e) => e as String)?.toList(),
    finishDate: json['finishDate'] == null
        ? null
        : DateTime.parse(json['finishDate'] as String),
    productList: (json['productList'] as List)
        ?.map((e) => e as Map<String, dynamic>)
        ?.toList(),
    active: json['active'] as bool,
  );
}

Map<String, dynamic> _$GroceryListToJson(GroceryList instance) =>
    <String, dynamic>{
      'title': instance.title,
      'users': instance.users,
      'finishDate': instance.finishDate?.toIso8601String(),
      'productList': instance.productList,
      'active': instance.active,
    };
