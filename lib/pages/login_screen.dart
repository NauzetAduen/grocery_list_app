import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:grocery_list_app/components/custom_appbar.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String phoneNumber = "";
  String smsCode = "";
  String verificationCode = "";

  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppbar(Text("Login")),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GradientButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text("Log In"),
                    Icon(Icons.person),
                  ],
                ),
                callback: () {
                  print("Log IN Pressed");
                },
              ),
              GradientButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text("Sign In"),
                    Icon(Icons.account_box),
                  ],
                ),
                callback: () {
                  print("Sign Pressed");
                },
              ),
              GradientButton(
                elevation: 10,
                increaseWidthBy: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text("Add your phone"),
                    Icon(Icons.phone),
                  ],
                ),
                callback: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            "test",
                            textAlign: TextAlign.center,
                          ),
                          content: ListTile(
                            leading: Icon(Icons.phone),
                            title: TextField(
                              controller: _controller,
                              keyboardType: TextInputType.phone,
                            ),
                          ),
                          actions: <Widget>[
                            RaisedButton(
                              onPressed: () {
                                setState(() {
                                  // phoneNumber = "+34" + _controller.text;
                                  phoneNumber = _controller.text;
                                  print("Phone --> $phoneNumber");
                                  verifyPhone();
                                });
                              },
                              child: Text(
                                "Try",
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          ],
                        );
                      });
                },
              ),
            ],
          ),
        ));
  }

  Future<void> verifyPhone() async {
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      this.verificationCode = verId;
    };
    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      this.verificationCode = verId;
      smsCodeDialog(context).then((value) {
        print("smscodeDialog--> signed in");
      });
    };
    final PhoneVerificationCompleted verifiedSuccess =
        (AuthCredential authCredential) {
      print(authCredential);
      // FirebaseAuth.instance.signInWithCredential(authCredential).then((result){
      //   print(result);
      // });
    };
    final PhoneVerificationFailed veriFailed = (AuthException e) {
      print(e.message);
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        codeAutoRetrievalTimeout: autoRetrieve,
        codeSent: smsCodeSent,
        timeout: Duration(seconds: 5),
        verificationCompleted: verifiedSuccess,
        verificationFailed: veriFailed,
        phoneNumber: _controller.text);
    print("awaited");
  }

  Future<bool> smsCodeDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(10),
            title: Text("Enter sms code"),
            content: TextField(
              onChanged: (newValue) {
                this.smsCode = newValue;
              },
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Done"),
                onPressed: () {
                  FirebaseAuth.instance.currentUser().then((user) {
                    if (user != null) {
                      Navigator.of(context).pop();
                      //pushhomepage
                    } else {
                      Navigator.of(context).pop();
                      //13:56
                    }
                  });
                },
              )
            ],
          );
        });
  }
}
