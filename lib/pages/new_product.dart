import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:grocery_list_app/Style/style.dart';
import 'package:grocery_list_app/components/horizontal_separator.dart';
import 'package:grocery_list_app/components/leading_appbar.dart';
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
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        flex: 4,
                        child: TextFormField(
                          controller: _controller,
                          validator: ValidatorHelper.newProductValidator,
                        ),
                      ),
                      HorizontalSeparator(
                        width: 30,
                      ),
                      GradientButton(
                          child: Icon(Icons.check),
                          callback: () => _validateNewProduct(),
                          gradient: LinearGradient(
                            colors: [Colors.green, Style.green],
                          ))
                    ],
                  ),
                )
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
    Firestore.instance.collection("products").add({'name': _controller.text});
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
