
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../FbObjects/fbPost.dart';
import 'PlatformAdmin.dart';

class DataHolder {

  //var
  static final DataHolder _dataHolder = DataHolder._internal();
  FirebaseFirestore db = FirebaseFirestore.instance;
  late String sPostTitle;
  late PlatformAdmin platformAdmin;

  //idk
  DataHolder._internal() {}

  //initialize
  void initDataHolder() {
    sPostTitle = "postTitle";
    //loadCachedFbPost();
  }

  factory DataHolder() {
    return _dataHolder;
  }

  //initialize platformAdmin
  void initPlatformAdmin(BuildContext context) {
    platformAdmin = PlatformAdmin(context: context);
  }
}