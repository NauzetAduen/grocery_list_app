import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:grocery_list_app/Style/style.dart';
import 'package:grocery_list_app/components/leading_appbar.dart';
import 'package:grocery_list_app/utils/storage_helper.dart';
import 'package:provider/provider.dart';

class UploadImageScreen extends StatefulWidget {
  final File file;

  UploadImageScreen(this.file);
  @override
  _UploadImageScreenState createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  String userID;
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: StorageHelper.getStorageBucket());
  StorageUploadTask _uploadTask;

  void _startUpload() {
    String filePath = 'images/$userID.png';
    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
    });
  }

  @override
  Widget build(BuildContext context) {
    userID = Provider.of<FirebaseUser>(context).uid;
    return Scaffold(
        body: Center(
            child: _uploadTask != null
                ? StreamBuilder<StorageTaskEvent>(
                    stream: _uploadTask.events,
                    builder: (context, snapshot) {
                      var event = snapshot?.data?.snapshot;
                    },
                  )
                : Hero(
                    tag: "uploadTag",
                    child: FlatButton(
                      color: Style.darkRed,
                      child: Column(
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
                      onPressed: () {
                        _startUpload();
                      },
                    ),
                  )),
        backgroundColor: Style.darkBlue,
        appBar: LeadingAppbar(
          Text(
            "Upload to Firebase",
            style: Style.appbarStyle,
          ),
        ));
  }
}
