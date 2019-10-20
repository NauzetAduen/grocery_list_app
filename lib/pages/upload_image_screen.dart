import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:grocery_list_app/Style/style.dart';
import 'package:grocery_list_app/components/leading_appbar.dart';
import 'package:grocery_list_app/utils/storage_helper.dart';
import 'package:provider/provider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class UploadImageScreen extends StatefulWidget {
  final File file;
  final String documentID;

  UploadImageScreen(this.file, this.documentID);
  @override
  _UploadImageScreenState createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  String userID;
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: StorageHelper.getStorageBucket());
  StorageUploadTask _uploadTask;

  void _startUpload() {
    String filePath = '$userID.png';
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
                      if (!snapshot.hasData) return SizedBox();
                      StorageTaskSnapshot event = snapshot?.data?.snapshot;
                      double progressValue =
                          event.bytesTransferred / event.totalByteCount;
                      if (_uploadTask.isComplete) {
                        // Firestore.instance
                        //     .runTransaction((Transaction transaction) async {
                        //   DocumentReference reference = Firestore.instance
                        //       .collection("users")
                        //       .document(widget.documentID);
                        //   DocumentSnapshot snapshot =
                        //       await transaction.get(reference);
                        //   await _storage.ref().getDownloadURL().then((newURL) {
                        //     print(newURL);
                        //     transaction.update(
                        //         snapshot.reference, {"photoURL": newURL});
                        //   }
                        //   );
                        // }).then((onValue) {
                        //   Navigator.popUntil(context, (route) => route.isFirst);
                        // });
                      }

                      return SleekCircularSlider(
                        appearance: CircularSliderAppearance(),
                        initialValue: progressValue,
                      );
                    },
                  )
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
                        Text("Upload", style: Style.cameraButtonsTextStyle),
                      ],
                    ),
                    onPressed: () {
                      _startUpload();
                    },
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
