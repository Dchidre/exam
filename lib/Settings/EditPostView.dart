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

  final String idPost;

  EditPostView({required this.idPost});

  @override
  State<EditPostView> createState() => _EditPostViewState(idPost: idPost);
}

class _EditPostViewState extends State<EditPostView> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  late fbPost post;
  late fbPost _dataPost;
  bool blIsPostLoaded = false;
  final List<fbPost> postList = [];
  late TextEditingController tecTitle = new TextEditingController();
  late TextEditingController tecBody = new TextEditingController();
  final String idPost; // Declare postId variable

  _EditPostViewState({required this.idPost});

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
            textField(sLabel: 'New title', myController: tecTitle),
            textField(sLabel: 'New body', myController: tecBody),
            SizedBox(height: 30),
            FilledButton(
              onPressed: () async {
                DataHolder().fbAdmin.updatePostData(title: tecTitle.text, body: tecBody.text, idPost: idPost);
                Navigator.pop(context);
              },
              child: const Text('Do it!'),
            ),
          ],
        ),
      ),
    );
  }
}
