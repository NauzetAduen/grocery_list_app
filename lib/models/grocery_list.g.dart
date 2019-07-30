// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grocery_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroceryList _$GroceryListFromJson(Map<String, dynamic> json) {
  return GroceryList(
    (json['users'] as List)?.map((e) => e as String)?.toList(),
    json['initDate'] == null
        ? null
        : DateTime.parse(json['initDate'] as String),
    (json['productList'] as List)
        ?.map((e) => e as Map<String, dynamic>)
        ?.toList(),
    json['active'] as bool,
  );
}

Map<String, dynamic> _$GroceryListToJson(GroceryList instance) =>
    <String, dynamic>{
      'users': instance.users,
      'initDate': instance.initDate?.toIso8601String(),
      'productList': instance.productList,
      'active': instance.active,
    };
