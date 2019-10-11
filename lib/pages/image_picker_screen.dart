import 'dart:io';

import 'package:flutter/material.dart';
import 'package:grocery_list_app/Style/style.dart';
import 'package:grocery_list_app/components/leading_appbar.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerScreen extends StatefulWidget {
  @override
  _ImagePickerScreenState createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  File _imageFile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.darkBlue,
      appBar: LeadingAppbar(Text(
        "Add picture",
        style: Style.appbarStyle,
      )),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);
    _imageFile = selected;
  }

  void _clear() {
    setState(() {
      _imageFile = null;
    });
  }
}
