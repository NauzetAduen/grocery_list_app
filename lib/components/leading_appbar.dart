import 'package:flutter/material.dart';
import 'package:grocery_list_app/components/custom_appbar.dart';

class LeadingAppbar extends CustomAppbar {
  LeadingAppbar(this.title, {this.actions}) : super(null);
  @override
  final Widget title;

  @override
  final List<Widget> actions;

  @override
  final bool centerTitle = true;

  @override
  final Widget leading = Builder(builder: (BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_left), onPressed: () => Navigator.pop(context));
  });
}
