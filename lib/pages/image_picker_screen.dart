import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_list_app/Style/style.dart';
import 'package:grocery_list_app/components/leading_appbar.dart';
import 'package:grocery_list_app/pages/upload_image_screen.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerScreen extends StatefulWidget {
  final String documentID;

  const ImagePickerScreen({Key key, this.documentID}) : super(key: key);
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
          _imageFile == null
              ? SizedBox()
              : FlatButton(
                  color: Style.darkRed,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.cloud_upload,
                        size: 40,
                        color: Style.darkBlue,
                      ),
                      Text("Firebase", style: Style.cameraButtonsTextStyle),
                    ],
                  ),
                  onPressed: () => Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => UploadImageScreen(
                              _imageFile, widget.documentID))),
                )
        ],
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);
    setState(() {
      _imageFile = selected;
    });
  }
}
