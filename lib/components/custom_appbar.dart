import 'package:flutter/material.dart';

class CustomAppbar extends AppBar {
  CustomAppbar(this.title, {this.actions});
  @override
  final Widget title;

  @override
  final bool centerTitle = true;

  @override
  final List<Widget> actions;
}
