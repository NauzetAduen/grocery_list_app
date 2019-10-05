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

  //fonts
  static final String nunito = "Nunito";

  static final TextStyle listTitleTextStyle = TextStyle(
    color: darkYellow,
    fontWeight: FontWeight.bold,
    fontSize: 24,
    fontFamily: nunito,
  );

  static final TextStyle currentUsersListTitle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 25,
    color: Colors.blue,
    fontFamily: nunito,
  );
  static final TextStyle addphoneButtonTextStyle =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.black);
  static final TextStyle welcomeStyle = TextStyle(
    fontFamily: nunito,
    fontWeight: FontWeight.bold,
    fontSize: 25,
    color: whiteYellow,
  );
  static final TextStyle welcomeBiggerStyle = TextStyle(
    fontFamily: nunito,
    fontWeight: FontWeight.bold,
    fontSize: 30,
    color: whiteYellow,
  );
  static final TextStyle appbarStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 30,
    fontFamily: nunito,
  );
  static final TextStyle addPhoneTextFieldStyle = TextStyle(
    fontSize: 22,
    color: whiteYellow,
    fontFamily: nunito,
  );
  static final TextStyle hintLoginNumberTextStyle = TextStyle(
    fontFamily: nunito,
    fontSize: 16,
    color: Colors.blueGrey,
  );
  static final TextStyle dialogActionsTextStyle = TextStyle(
    color: whiteYellow,
    fontSize: 15,
    fontFamily: nunito,
  );

  static final TextStyle groceryListTileTextStyle = TextStyle(
    fontFamily: nunito,
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 25,
  );
  static final TextStyle groceryListTileInactiveTextStyle = TextStyle(
    color: Colors.black,
    fontSize: 20,
    fontFamily: nunito,
  );
  static final TextStyle grocerylistTitleTextStyle = TextStyle(
    fontFamily: nunito,
    color: darkYellow,
    fontWeight: FontWeight.bold,
    fontSize: 30,
  );

  static final TextStyle groceryListTyleUserCountTextStyle = TextStyle(
    fontFamily: nunito,
    fontSize: 15,
  );

  static final TextStyle shopingCardTextStyle = TextStyle(
    fontFamily: nunito,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );
  static final TextStyle shopingCardInactiveTextStyle = TextStyle(
    fontFamily: nunito,
    fontSize: 20,
  );

  static final TextStyle fabTextStyle =
      TextStyle(fontFamily: nunito, fontSize: 13, fontWeight: FontWeight.bold);

  static final TextStyle popupItemTextStyle = TextStyle(
    fontFamily: nunito,
    fontSize: 15,
  );
  static final TextStyle dialogFlatButtonTextStyle =
      TextStyle(fontFamily: nunito, fontSize: 18, color: Colors.white);

  static final TextStyle dialogTextStyle =
      TextStyle(fontFamily: nunito, fontSize: 16, color: whiteYellow);
  static final TextStyle subtitleProductTextStyle = TextStyle(
      fontFamily: nunito,
      fontSize: 14,
      color: Colors.black,
      fontStyle: FontStyle.italic);

  static final TextStyle gridTextStyle =
      TextStyle(fontFamily: nunito, fontSize: 15);
}
