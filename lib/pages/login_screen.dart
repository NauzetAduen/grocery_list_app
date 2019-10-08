import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grocery_list_app/Style/style.dart';
import 'package:grocery_list_app/models/user.dart';
import 'package:grocery_list_app/utils/validator_helper.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String phoneNo;
  String smsOTP;
  String verificationId;
  String errorMessage = '';
  final _formKey = GlobalKey<FormState>();
  FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Style.darkBlue,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(children: <TextSpan>[
                    TextSpan(text: "Welcome to "),
                    TextSpan(
                        text: "GroceryListApp", style: Style.welcomeBiggerStyle)
                  ], style: Style.welcomeStyle),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60),
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    style: Style.addPhoneTextFieldStyle,
                    cursorColor: Style.whiteYellow,
                    validator: ValidatorHelper.genericEmptyValidator,
                    decoration: InputDecoration(
                      hintText: "Enter your phone number",
                      hintStyle: Style.hintLoginNumberTextStyle,
                      prefixIcon: Icon(
                        Icons.phone,
                        color: Style.whiteYellow,
                      ),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Style.whiteYellow)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Style.lightYellow)),
                    ),
                    controller: _controller,
                    keyboardType: TextInputType.phone,
                  ),
                ),
              ),
              RaisedButton(
                elevation: 22,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35),
                ),
                padding: EdgeInsets.all(15),
                color: Style.whiteYellow,
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    setState(() {
                      phoneNo = _controller.text;
                      verifyPhone();
                    });
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      FontAwesomeIcons.check,
                      size: 24,
                      color: Style.darkRed,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Sign Up",
                      style: Style.addphoneButtonTextStyle,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Future<void> verifyPhone() async {
    final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      smsOTPDialog(context).then((value) {
        print('sign in');
      });
    };
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: this.phoneNo, // PHONE NUMBER TO SEND OTP
          codeAutoRetrievalTimeout: (String verId) {
            //Starts the phone number verification process for the given phone number.
            //Either sends an SMS with a 6 digit code to the phone number specified, or sign's the user in and [verificationCompleted] is called.
            this.verificationId = verId;
          },
          codeSent:
              smsOTPSent, // WHEN CODE SENT THEN WE OPEN DIALOG TO ENTER OTP.
          timeout: const Duration(seconds: 20),
          verificationCompleted: (AuthCredential phoneAuthCredential) {
            print(phoneAuthCredential);
          },
          verificationFailed: (AuthException exceptio) {
            print('${exceptio.message}');
          });
    } catch (e) {
      handleError(e);
    }
  }

  Future<bool> smsOTPDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            backgroundColor: Style.darkBlue,
            title: Text(
              'Enter SMS Code',
              style: Style.addPhoneTextFieldStyle,
            ),
            content: Container(
              height: 85,
              child: Column(children: [
                TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.confirmation_number,
                      color: Style.whiteYellow,
                    ),
                    hintText: "Enter the code that you received",
                    hintStyle: Style.hintLoginNumberTextStyle,
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Style.whiteYellow)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Style.lightYellow)),
                  ),
                  onChanged: (value) {
                    this.smsOTP = value;
                  },
                ),
                (errorMessage != ''
                    ? Text(
                        errorMessage,
                        style: TextStyle(color: Colors.red),
                      )
                    : Container())
              ]),
            ),
            contentPadding: EdgeInsets.all(10),
            actions: <Widget>[
              FlatButton(
                color: Style.darkRed,
                child: Text(
                  "Cancel",
                  style: Style.dialogActionsTextStyle,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                color: Style.darkYellow,
                child: Text('Done', style: Style.dialogActionsTextStyle),
                onPressed: () {
                  _auth.currentUser().then((user) {
                    if (user != null) {
                      Navigator.of(context).pop();
                    } else {
                      signIn();
                    }
                  });
                },
              )
            ],
          );
        });
  }

  signIn() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: verificationId,
        smsCode: smsOTP,
      );
      final AuthResult result = await _auth.signInWithCredential(credential);
      final FirebaseUser user = result.user;
      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);
      User dbUser = User(
          id: currentUser.uid,
          phoneNumber: currentUser.phoneNumber,
          photoURL: currentUser.photoUrl ?? "",
          username: "");
      Firestore.instance.collection('users').getDocuments().then((doc) {
        bool exist = false;
        doc.documents.forEach((docu) {
          User tempUser = User.fromJson(docu.data);
          if (tempUser.id == dbUser.id) exist = true;
        });
        if (!exist) {
          Firestore.instance.collection("users").add(dbUser.toJson());
        }
      });
    } catch (e) {
      handleError(e);
    }
  }

  handleError(dynamic error) {
    print(error);
    switch (error.code) {
      case 'ERROR_INVALID_VERIFICATION_CODE':
        FocusScope.of(context).requestFocus(new FocusNode());
        setState(() {
          errorMessage = 'Invalid Code';
        });
        Navigator.of(context).pop();
        smsOTPDialog(context).then((value) {
          print('sign in');
        });
        break;
      default:
        setState(() {
          errorMessage = error.message;
        });

        break;
    }
  }
}
