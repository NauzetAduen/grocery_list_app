import 'package:flutter/material.dart';
import 'package:grocery_list_app/components/custom_appbar.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(Text("Login")),
      body: Center(
        child: Text("LoginPage"),
      ),
    );
  }
}
