import 'package:flutter/material.dart';

class Style {
  // Colors
  //https://coolors.co/003049-d62828-f77f00-fcbf49-eae2b7
  static final Color green = Color(0xff84E0A1);
  static final Color darkBlue = Color(0xFF003049);
  static final Color darkRed = Color(0xFFd62828);
  static final Color darkYellow = Color(0xFFf77f00);
  static final Color lightYellow = Color(0xFFfcbf49);
  static final Color whiteYellow = Color(0xFFeae2b7);

  static final TextStyle listTitleTextStyle =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 24);

  static final TextStyle currentUsersListTitle =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.blue);
  static final TextStyle addphoneButtonTextStyle =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.black);
  static final TextStyle welcomeStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 25,
    color: whiteYellow,
  );
  static final TextStyle welcomeBiggerStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 30,
    color: whiteYellow,
  );
  static final TextStyle appbarStyle =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 30);
  static final TextStyle addPhoneTextFieldStyle =
      TextStyle(fontSize: 22, color: whiteYellow);
}
