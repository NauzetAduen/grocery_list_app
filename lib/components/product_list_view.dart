import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grocery_list_app/Style/style.dart';
import 'package:grocery_list_app/components/leading_appbar.dart';
import 'package:grocery_list_app/components/user_row.dart';
import 'package:grocery_list_app/models/grocery_list.dart';
import 'package:grocery_list_app/models/user.dart';
import 'package:grocery_list_app/pages/product_selector.dart';
import 'package:grocery_list_app/utils/validator_helper.dart';
import 'package:provider/provider.dart';
import 'package:unicorndial/unicorndial.dart';

class ProductListView extends StatefulWidget {
  final String documentID;
  ProductListView(this.documentID);
  @override
  _ProductListViewState createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  DocumentReference reference;
  List<Map<String, dynamic>> productList = [];
  String errorMessage = "";
  List<User> users = [];
  double labelFontSize = 16;
  final _newUserFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    reference =
        Firestore.instance.collection("lists").document(widget.documentID);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection("lists")
          .document(widget.documentID)
          .snapshots(),
      builder: (context, snapshot) {
        GroceryList gl;
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.done:
            return SizedBox();
          case ConnectionState.active:
            gl = GroceryList.fromJsonFull(snapshot.data.data);
        }
        productList = gl.productList;
        return Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: UnicornDialer(
            backgroundColor: Colors.transparent,
            parentButtonBackground: Style.darkYellow,
            animationDuration: 200,
            orientation: UnicornOrientation.VERTICAL,
            parentButton: Icon(Icons.menu),
            childButtons: [
              UnicornButton(
                hasLabel: true,
                labelFontSize: labelFontSize,
                labelText: "Add product to list",
                currentButton: FloatingActionButton(
                  heroTag: "Addproduct",
                  backgroundColor: Style.lightYellow,
                  onPressed: () {
                    _goToProductListView();
                  },
                  child: Icon(
                    FontAwesomeIcons.plus,
                  ),
                ),
              ),
              UnicornButton(
                hasLabel: true,
                labelText: "Leave group",
                labelFontSize: labelFontSize,
                currentButton: FloatingActionButton(
                  heroTag: "Leavegroup",
                  backgroundColor: Style.darkRed,
                  onPressed: () {
                    _showDialogLeaveGroup(gl);
                  },
                  child: Icon(
                    FontAwesomeIcons.userMinus,
                  ),
                ),
              ),
              UnicornButton(
                hasLabel: true,
                labelFontSize: labelFontSize,
                labelText: "Add an user to group",
                currentButton: FloatingActionButton(
                  heroTag: "adduser",
                  backgroundColor: Style.darkBlue,
                  onPressed: () {
                    _showAddUserDialog(gl);
                  },
                  child: Icon(
                    FontAwesomeIcons.userPlus,
                  ),
                ),
              ),
              UnicornButton(
                labelFontSize: labelFontSize,
                hasLabel: true,
                labelText: "Finish list",
                currentButton: FloatingActionButton(
                  heroTag: "finishlist",
                  backgroundColor: Colors.green,
                  onPressed: () {
                    _showFinishDialog(gl);
                  },
                  child: Icon(
                    FontAwesomeIcons.check,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Style.darkBlue,
          appBar: LeadingAppbar(
            Text(
              "${gl.title}",
              style: Style.appbarStyle,
            ),
            // actions: <Widget>[
            //   IconButton(
            //     icon: Icon(
            //       FontAwesomeIcons.check,
            //     ),
            //     onPressed: () {
            //       _showFinishDialog(gl);
            //     },
            //   ),
            //   // Theme(
            //   //     data: Theme.of(context).copyWith(
            //   //         cardColor: Style.lightYellow,
            //   //         iconTheme: IconThemeData(color: Colors.white)),
            //   //     child: PopupMenuButton<String>(
            //   //       itemBuilder: (BuildContext contest) {
            //   //         return <PopupMenuItem<String>>[
            //   //           PopupMenuItem(
            //   //             child: ListTile(
            //   //               onTap: () {
            //   //                 _showUserDialog(gl);
            //   //               },
            //   //               leading: Icon(Icons.group_add),
            //   //               title: Text('Add user to group',
            //   //                   style: Style.popupItemTextStyle),
            //   //             ),
            //   //           ),
            //   //           PopupMenuItem(
            //   //             child: ListTile(
            //   //               onTap: () {
            //   //                 Navigator.pop(context);
            //   //                 _showDialogLeaveGroup(gl);
            //   //               },
            //   //               leading: Icon(Icons.remove_circle_outline),
            //   //               title: Text('Leave the group',
            //   //                   style: Style.popupItemTextStyle),
            //   //             ),
            //   //           ),
            //   //         ];
            //   //       },
            //   //     )),
            // ],
          ),
          body: ListView(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 15),
                child: UserRow(gl.users),
              ),
              ListView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                itemCount: gl.productList.length,
                itemBuilder: (context, index) {
                  var item = gl.productList[index];
                  String pro = item['productName'];
                  String mag = item['productMagnitude'];
                  return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 8),
                      child: Material(
                          borderRadius: BorderRadius.circular(30),
                          color: Style.whiteYellow,
                          elevation: 10,
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15)),
                              child: Builder(
                                  builder: (context) => ListTile(
                                        title: Text(
                                          "$pro",
                                          style: Style.groceryListTileTextStyle,
                                        ),
                                        subtitle: Text("$mag",
                                            style:
                                                Style.subtitleProductTextStyle),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            IconButton(
                                              icon: Icon(
                                                Icons.edit,
                                                color: Style.darkYellow,
                                              ),
                                              onPressed: () {
                                                _editMagnitude(pro, mag);
                                              },
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                Icons.delete,
                                                color: Style.darkRed,
                                              ),
                                              onPressed: () {
                                                _showDeleteDialog(pro);
                                              },
                                            ),
                                          ],
                                        ),
                                      )))));
                },
              )
            ],
          ),
        );
      },
    );
  }

  _editMagnitude(String product, String magnitude) {
    _showEditingDialog(product, magnitude);
  }

  _showFinishDialog(GroceryList gl) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Style.darkBlue,
            title: Text("Finishing ${gl.title}",
                style: Style.addPhoneTextFieldStyle),
            content: Text(
              "Do you want to finish ${gl.title}?\nA new list will be created",
              style: Style.dialogTextStyle,
            ),
            actions: <Widget>[
              FlatButton(
                color: Style.darkRed,
                child: Text("No", style: Style.dialogFlatButtonTextStyle),
                onPressed: () => Navigator.pop(context),
              ),
              FlatButton(
                  color: Style.darkYellow,
                  child: Text(
                    "Yes",
                    style: Style.dialogFlatButtonTextStyle,
                  ),
                  onPressed: () {
                    _finishList();
                    _createNewList(gl);
                  }),
            ],
          );
        });
  }

  _showAddUserDialog(GroceryList groceryList) {
    TextEditingController _controller = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Style.darkBlue,
            title: Text(
              "New user",
              style: Style.addPhoneTextFieldStyle,
            ),
            content: Form(
                key: _newUserFormKey,
                child: TextFormField(
                  controller: _controller,
                  style: Style.addPhoneTextFieldStyle,
                  cursorColor: Style.whiteYellow,
                  validator: ValidatorHelper.genericEmptyValidator,
                  decoration: InputDecoration(
                    hintText: "Enter a number or an username",
                    hintStyle: Style.hintLoginNumberTextStyle,
                    prefixIcon: Icon(
                      FontAwesomeIcons.userPlus,
                      color: Style.whiteYellow,
                    ),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Style.whiteYellow)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Style.lightYellow)),
                  ),
                )),
            actions: <Widget>[
              FlatButton(
                color: Style.darkRed,
                child: Text("Leave", style: Style.dialogTextStyle),
                onPressed: () => Navigator.pop(context),
              ),
              FlatButton(
                color: Style.darkYellow,
                child: Text("Add", style: Style.dialogTextStyle),
                onPressed: () {
                  _validate(_controller.text, groceryList);
                },
              ),
            ],
          );
        });
  }

  _validate(String value, GroceryList gl) {
    bool userExist = false;
    User userFound;
    if (_newUserFormKey.currentState.validate()) {
      if (value == Provider.of<FirebaseUser>(context).uid &&
          isAlreadyOnList(value)) return;

      Firestore.instance.collection('users').getDocuments().then((doc) {
        print(doc.documents.length);
        for (DocumentSnapshot document in doc.documents) {
          User user = User.fromJson(document.data);
          if (user.username == value || user.phoneNumber == value) {
            userExist = true;
            userFound = user;
          }
        }
        if (userExist) {
          List<String> newList = gl.users;
          newList.add(userFound.id);
          Firestore.instance.runTransaction((Transaction transaction) async {
            DocumentSnapshot snapshot = await transaction.get(reference);
            await transaction.update(snapshot.reference, {"users": newList});
          });
          Navigator.pop(context);
        }
      });
    }
  }

  bool isAlreadyOnList(String value) {
    for (User user in users) {
      if (user.username == value || user.phoneNumber == value) return true;
    }
    return false;
  }

  _showEditingDialog(String product, String magnitude) {
    TextEditingController _controller = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Style.darkBlue,
            title: Text(
              "Editing $product $magnitude",
              style: Style.addPhoneTextFieldStyle,
            ),
            content: Form(
              key: _formKey,
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "Enter new magnitude",
                  hintStyle: Style.hintLoginNumberTextStyle,
                  prefixIcon: Icon(
                    Icons.swap_horiz,
                    color: Style.whiteYellow,
                  ),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Style.whiteYellow)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Style.lightYellow)),
                ),
                style: Style.addPhoneTextFieldStyle,
                cursorColor: Style.whiteYellow,
                controller: _controller,
                validator: ValidatorHelper.editingMagnitudeValidator,
              ),
            ),
            actions: <Widget>[
              FlatButton(
                color: Style.darkRed,
                child: Text("Cancel", style: Style.dialogTextStyle),
                onPressed: () => Navigator.pop(context),
              ),
              FlatButton(
                color: Style.darkYellow,
                child: Text("OK", style: Style.dialogTextStyle),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    _updateMagnitude(product, magnitude, _controller.text);
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          );
        });
  }

  _finishList() {
    Firestore.instance.runTransaction((Transaction transaction) async {
      DocumentSnapshot snapshot = await transaction.get(reference);
      await transaction.update(snapshot.reference,
          {"active": false, "finishDate": DateTime.now().toIso8601String()});
    });
  }

  _createNewList(GroceryList oldGroceryList) {
    GroceryList newGroceryList = GroceryList.fromOther(oldGroceryList);
    Firestore.instance.collection("lists").add(newGroceryList.toJson());
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  _showDeleteDialog(String product) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Style.darkBlue,
            content: Text("Do you want to remove $product from this list?",
                style: Style.dialogTextStyle),
            title: Text(
              "Removing $product",
              style: Style.addPhoneTextFieldStyle,
            ),
            actions: <Widget>[
              FlatButton(
                color: Style.darkRed,
                child: Text("Cancel", style: Style.dialogTextStyle),
                onPressed: () => Navigator.pop(context),
              ),
              FlatButton(
                color: Style.darkYellow,
                child: Text("OK", style: Style.dialogTextStyle),
                onPressed: () {
                  _deleteProductFromList(product);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  _updateMagnitude(String product, String magnitude, String newMagnitude) {
    Firestore.instance.runTransaction((Transaction transaction) async {
      DocumentSnapshot snapshot = await transaction.get(reference);
      List<Map<String, dynamic>> newList = productList;
      newList.removeWhere((prodc) => prodc.containsValue(product));
      newList.add(
          {'productName': '$product', 'productMagnitude': '$newMagnitude'});
      await transaction.update(snapshot.reference, {"productList": newList});
    });
  }

  _deleteProductFromList(String product) {
    Firestore.instance.runTransaction((Transaction transaction) async {
      DocumentSnapshot snapshot = await transaction.get(reference);
      List<Map<String, dynamic>> newList = productList;
      newList.removeWhere((prodc) => prodc.containsValue(product));
      await transaction.update(snapshot.reference, {"productList": newList});
    });
  }

  _leaveGroup(List<String> users) {
    Firestore.instance.runTransaction((Transaction transaction) async {
      DocumentSnapshot snapshot = await transaction.get(reference);
      List<String> newUserList = users;
      newUserList.removeWhere(
          (item) => item == Provider.of<FirebaseUser>(context).uid);
      await transaction.update(snapshot.reference, {"users": newUserList});
      Navigator.popUntil(context, (route) => route.isFirst);
    });
  }

  _goToProductListView() {
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => ProductSelector(widget.documentID)));
  }

  _showDialogLeaveGroup(GroceryList groceryList) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Style.darkBlue,
            content: Text("Are you sure you want to leave this group?",
                style: Style.dialogTextStyle),
            title: Text(
              "Leaving ${groceryList.title} ...",
              style: Style.addPhoneTextFieldStyle,
            ),
            actions: <Widget>[
              FlatButton(
                color: Style.lightYellow,
                onPressed: () => Navigator.pop(context),
                child: Text("No", style: Style.dialogFlatButtonTextStyle),
              ),
              FlatButton(
                color: Style.darkRed,
                onPressed: () {
                  _leaveGroup(groceryList.users);
                  Navigator.pop(context);
                },
                child: Text(
                  "Yes",
                  style: Style.dialogFlatButtonTextStyle,
                ),
              ),
            ],
          );
        });
  }

  List<String> userListToString(List<User> users) {
    List<String> usersStrings = [];
    users.forEach((user) {
      usersStrings.add(user.id);
    });
    usersStrings.add(Provider.of<FirebaseUser>(context).uid);
    return usersStrings;
  }
}
