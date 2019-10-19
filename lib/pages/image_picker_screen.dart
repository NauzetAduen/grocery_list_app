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
  Image defaultImage = Image.asset(
    "assets/images/nophotodefault.jpg",
    width: 200,
    height: 200,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.darkBlue,
      appBar: LeadingAppbar(Text(
        "Add picture",
        style: Style.appbarStyle,
      )),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _imageFile == null
              ? Container(
                  alignment: Alignment.center,
                  child: defaultImage,
                )
              : Container(
                  alignment: Alignment.center,
                  width: 300,
                  height: 300,
                  child: Image.file(_imageFile),
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: FlatButton(
                  color: Style.darkYellow,
                  child: Column(
                    children: <Widget>[
                      Icon(
                        Icons.photo_camera,
                        color: Style.darkBlue,
                        size: 40,
                      ),
                      Text("Camera", style: Style.cameraButtonsTextStyle),
                    ],
                  ),
                  onPressed: () {
                    _pickImage(ImageSource.camera);
                  },
                ),
              ),
              FlatButton(
                color: Style.lightYellow,
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.photo_library,
                      color: Style.darkBlue,
                      size: 40,
                    ),
                    Text("Gallery", style: Style.cameraButtonsTextStyle),
                  ],
                ),
                onPressed: () {
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
          _imageFile != null
              ? SizedBox()
              : FlatButton(
                  color: Style.darkRed,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.cloud_upload,
                        size: 40,
                        color: Style.darkBlue,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Upload", style: Style.cameraButtonsTextStyle),
                    ],
                  ),
                  onPressed: _uploadToFireStore,
                )
        ],
      ),
    );
  }

  _uploadToFireStore() {
    print("PRessed");
  }

  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);
    setState(() {
      _imageFile = selected;
    });
  }
}
