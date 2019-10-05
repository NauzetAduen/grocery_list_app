import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grocery_list_app/Style/style.dart';
import 'package:grocery_list_app/components/leading_appbar.dart';
import 'package:grocery_list_app/models/product.dart';
import 'package:grocery_list_app/utils/icon_selector_helper.dart';
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
  String _category;
  @override
  void initState() {
    super.initState();
    _category = "Default";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Style.darkBlue,
        key: _scaffoldKey,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Style.darkYellow,
          onPressed: _validateNewProduct,
          child: Icon(FontAwesomeIcons.check),
        ),
        appBar: LeadingAppbar(Text("New product")),
        body: Container(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: TextFormField(
                      cursorColor: Style.whiteYellow,
                      controller: _controller,
                      validator: ValidatorHelper.editingMagnitudeValidator,
                      style: Style.addPhoneTextFieldStyle,
                      decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Style.whiteYellow)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Style.lightYellow)),
                          hintText: "Enter a product name",
                          hintStyle: Style.hintLoginNumberTextStyle,
                          prefixIcon: Icon(
                            FontAwesomeIcons.productHunt,
                            color: Style.whiteYellow,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.cancel,
                              color: Style.whiteYellow,
                            ),
                            onPressed: () {
                              _controller.clear();
                            },
                          )),
                    )),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                        cardColor: Style.whiteYellow,
                        iconTheme: IconThemeData(color: Style.darkYellow)),
                    child: DropdownButtonFormField<String>(
                        value: _category,
                        onChanged: (newValue) {
                          setState(() {
                            _category = newValue;
                          });
                        },
                        items: IconSelectorHelper.list),
                  ),
                ),
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
        .add(Product(_controller.text, "Nauzet", 1, _category).toJson());
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
