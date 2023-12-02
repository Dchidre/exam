
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../FbObjects/fbPost.dart';
import 'PlatformAdmin.dart';

class DataHolder {



  //var
  static final DataHolder _dataHolder = DataHolder._internal();
  FirebaseFirestore db = FirebaseFirestore.instance;
  fbPost? selectedPost;
  late String sPostTitle;
  late PlatformAdmin platformAdmin;

  //methods
  void savePostInCache() async {
    if (selectedPost != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('fbpost_title', selectedPost!.title);
      prefs.setString('fbpost_body', selectedPost!.body);
      prefs.setString('fbpost_surlimg', selectedPost!.sUrlImg);
    }
  }
  Future<fbPost?> loadFbPost() async { //future significa que va a apoder hacerle un await
    if (selectedPost != null) return selectedPost;

    await Future.delayed(Duration(seconds: 4));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? fbpost_title = prefs.getString('fbpost_title');
    fbpost_title ??= "";

    String? fbpost_body = prefs.getString('fbpost_body');
    fbpost_body ??= "";

    String? fbpost_surlimg = prefs.getString('fbpost_surlimg');
    fbpost_surlimg ??= "";

    String? fbpost_siduser = prefs.getString('fbpost_siduser');
    fbpost_siduser ??= "";

    selectedPost = fbPost(title: fbpost_title, body: fbpost_body, sUrlImg: fbpost_surlimg, sUserName: fbpost_siduser);
    return selectedPost;
  }

  factory DataHolder() {
    return _dataHolder;
  }

  //idk
  DataHolder._internal() {}

  //initialize
  void initDataHolder() {
    sPostTitle = "postTitle";
    //loadCachedFbPost();
  }

  //initialize platformAdmin
  void initPlatformAdmin(BuildContext context) {
    platformAdmin = PlatformAdmin(context: context);
  }

}