import 'package:flutter/material.dart';
import 'package:grocery_list_app/Style/style.dart';

class CustomAppbar extends AppBar {
  CustomAppbar(this.title, {this.actions});
  @override
  final Widget title;

  @override
  final bool centerTitle = true;

  @override
  final Color backgroundColor = Style.lightYellow;

  @override
  final List<Widget> actions;
}
