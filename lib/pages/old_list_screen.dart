import 'package:flutter/material.dart';
import 'package:grocery_list_app/components/custom_appbar.dart';

class OldListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(Text("OldList")),
      body: Center(
        child: Text("OLD LIST"),
      ),
    );
  }
}
