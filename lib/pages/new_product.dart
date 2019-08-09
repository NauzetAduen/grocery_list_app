import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:grocery_list_app/Style/style.dart';
import 'package:grocery_list_app/components/horizontal_separator.dart';
import 'package:grocery_list_app/components/leading_appbar.dart';
import 'package:grocery_list_app/models/product.dart';
import 'package:grocery_list_app/utils/validator_helper.dart';
import 'package:provider/provider.dart';

class NewProduct extends StatefulWidget {
  @override
  _NewProductState createState() => _NewProductState();
}

class _NewProductState extends State<NewProduct> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _icon;
  @override
  void initState() {
    super.initState();
    _icon = "Fruit";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: LeadingAppbar(Text("New product")),
        body: Container(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: TextFormField(
                    controller: _controller,
                    validator: ValidatorHelper.newProductValidator,
                    decoration: InputDecoration(
                        hintText: "Write a product name",
                        prefixIcon: Icon(Icons.search),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.cancel),
                          onPressed: () {
                            _controller.clear();
                          },
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: DropdownButtonFormField<String>(
                    value: _icon,
                    onChanged: (newValue) {
                      setState(() {
                        _icon = newValue;
                      });
                    },
                    items: <DropdownMenuItem<String>>[
                      DropdownMenuItem(
                          value: "Fruit",
                          child: Align(
                            alignment: Alignment.center,
                            child: Icon(FontAwesomeIcons.cloudMeatball),
                          )),
                      // DropdownMenuItem(
                      //     value: "apple",
                      //     child: Icon(FontAwesomeIcons.whatsappSquare)),
                      // DropdownMenuItem(
                      //     value: "fastfood", child: Icon(Icons.fastfood)),
                    ],
                  ),
                ),
                GradientButton(
                    child: Icon(Icons.check),
                    callback: () => _validateNewProduct(),
                    gradient: LinearGradient(
                      colors: [Colors.green, Style.green],
                    )),
                Text("$_icon")
              ],
            ),
          ),
        ));
  }

  void _validateNewProduct() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      if (!_doesProductExist()) {
        _addProduct();
        Navigator.pop(context, _controller.text.toString());
      } else
        _showError();
    }
  }

  void _showError() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Product already exists"),
        duration: Duration(milliseconds: 4000)));
  }

  void _addProduct() {
    Firestore.instance
        .collection("products")
        .add(Product(_controller.text, "Nauzet", 1).toJson());
  }

  bool _doesProductExist() {
    String naturalizedNewProductName = _controller.text.toLowerCase();
    bool found = false;
    QuerySnapshot a = Provider.of<QuerySnapshot>(context);
    a.documents.forEach((doc) {
      String naturalizedName = doc.data['name'].toString().toLowerCase();
      if (naturalizedName == naturalizedNewProductName) found = true;
    });
    return found;
  }
}
