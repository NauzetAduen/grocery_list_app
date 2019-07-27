import 'package:flutter/material.dart';

class CustomAppbar extends AppBar {
  CustomAppbar(this.title);
  @override
  final Widget title;

  @override
  final bool centerTitle = true;
}
