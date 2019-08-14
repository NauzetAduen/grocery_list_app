import 'package:flutter/material.dart';
import 'package:grocery_list_app/app.dart';
import 'package:grocery_list_app/pages/login_screen.dart';
import 'package:provider/provider.dart';

class GroceryListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // StreamProvider<FirebaseUser>.value(
        //   stream: FirebaseAuth.instance.onAuthStateChanged,
        // ),
        // StreamProvider<QuerySnapshot>.value(
        //   stream: Firestore.instance.collection("trails").snapshots(),
        // ),
      ],
      child: MaterialApp(
        title: 'GroceryListApp',
        debugShowCheckedModeBanner: false,
        home: StreamBuilder(
          // stream: FirebaseAuth.instance.onAuthStateChanged,
          builder: (BuildContext context, snapshot) {
            // if (snapshot.connectionState == ConnectionState.waiting)
            // return DefaultPage();
            if (snapshot.hasData) return App();
            return LoginScreen();
          },
        ),
      ),
    );
  }
}
