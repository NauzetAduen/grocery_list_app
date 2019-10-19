import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:grocery_list_app/utils/storage_helper.dart';

class UploadImageScreen extends StatefulWidget {
  final File file;
  UploadImageScreen(this.file);
  @override
  _UploadImageScreenState createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: StorageHelper.getStorageBucket());
  StorageUploadTask _uploadTask;
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
