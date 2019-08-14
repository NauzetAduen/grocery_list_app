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
                                  phoneNumber = _controller.text;
                                  print(phoneNumber);
                                  // FirebaseAuth.instance.verifyPhoneNumber(
                                  //     codeAutoRetrievalTimeout: (val) {},
                                  //     codeSent: (val, [array]) {},
                                  //     timeout: Duration(seconds: 5),
                                  //     verificationCompleted: (val) {},
                                  //     verificationFailed: (val) {},
                                  //     phoneNumber: _controller.text);
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
}
