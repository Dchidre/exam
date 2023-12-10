import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../FbObjects/fbPost.dart';
import '../FbObjects/fbUser.dart';
import '../Singletone/DataHolder.dart';
import '../components/textField.dart';

class EditPostView extends StatefulWidget {
  @override
  State<EditPostView> createState() => _EditPostViewState();
}

class _EditPostViewState extends State<EditPostView> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  late fbPost post;
  late fbPost _dataPost;
  bool blIsPostLoaded = false;
  final List<fbPost> postList = [];

  void loadCachePost() async {
    var temp1 = await DataHolder().loadFbPost();
    setState(() {
      _dataPost = temp1!;
      blIsPostLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    loadCachePost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Edit post!'),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 25),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 30),

            FilledButton( //upload new photo
              onPressed: () async {

              },
              child: const Text('Do it!'),
            ),
          ],
        ),
      ),
    );
  }
}
