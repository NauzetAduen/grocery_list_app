import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_list_app/models/user.dart';
import 'package:grocery_list_app/pages/homepage_screen.dart';
import 'package:grocery_list_app/pages/login_screen.dart';
import 'package:provider/provider.dart';

class GroceryListApp extends StatelessWidget {
  final String appName = "Grocery List App";

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<FirebaseUser>.value(
          value: FirebaseAuth.instance.onAuthStateChanged,
        ),
      ],
      child: MaterialApp(
        title: appName,
        debugShowCheckedModeBanner: false,
        home: StreamBuilder(
          stream: FirebaseAuth.instance.onAuthStateChanged,
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasData) return HomePageScreen();

            return LoginScreen();
          },
        ),
      ),
    );
  }
}
