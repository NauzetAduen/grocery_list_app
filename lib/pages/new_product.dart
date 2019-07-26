import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:grocery_list_app/Style/style.dart';
import 'package:grocery_list_app/components/horizontal_separator.dart';
import 'package:grocery_list_app/components/leading_appbar.dart';
import 'package:grocery_list_app/utils/validator_helper.dart';

class NewProduct extends StatefulWidget {
  @override
  _NewProductState createState() => _NewProductState();
}

class _NewProductState extends State<NewProduct> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      Hero(
                        tag: 'newProduct',
                        child: GradientButton(
                            child: Icon(Icons.check),
                            callback: () => _validateNewProduct(),
                            gradient: LinearGradient(
                              colors: [Colors.green, Style.green],
                            )),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  _validateNewProduct() {}
}
