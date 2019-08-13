import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:grocery_list_app/components/custom_appbar.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppbar(Text("Profile")),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              GradientButton(
                callback: () {
                  _createNewGroup(context);
                },
                child: Text("Create"),
              ),
              Text("Groups"),
              ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Align(
                    child: Text("Caca"),
                    alignment: Alignment.center,
                  );
                },
                itemCount: 2,
              ),
            ],
          ),
        ));
  }

  void _createNewGroup(BuildContext context) {
    print("Creating new group");
    _currentStep = 0;
    final _formKey = GlobalKey<FormState>();
    List<String> users = [];
    String groupName = "";
    TextEditingController _controller = TextEditingController();

    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              print(_currentStep);
              if (_currentStep == 0)
                return (AlertDialog(
                  actions: <Widget>[
                    RaisedButton(
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    RaisedButton(
                      child:
                          Text("Next", style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          setState(() {
                            groupName = _controller.text;
                            _currentStep = 1;
                          });
                        }
                      },
                    )
                  ],
                  title: Text("Add a name"),
                  content: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          TextFormField(
                            controller: _controller,
                            validator: (value) {
                              if (value.isEmpty) return "Please";
                              return null;
                            },
                          ),
                        ],
                      )),
                ));
              else
                return AlertDialog(
                  actions: <Widget>[
                    RaisedButton(
                      child:
                          Text("Back", style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        setState(() {
                          _currentStep = 0;
                        });
                      },
                    ),
                    RaisedButton(
                      child:
                          Text("Finish", style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        setState(() {
                          // _currentStep = 0;
                        });
                      },
                    ),
                  ],
                  content: Container(
                    width: double.maxFinite,
                    height: 300,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: 20,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text("$index"),
                          onTap: () {
                            print("$index pressed");
                          },
                        );
                      },
                    ),
                  ),
                );
            },
          );
        });
  }
}
