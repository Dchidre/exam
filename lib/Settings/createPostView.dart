


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

class createPostView extends StatefulWidget {
  @override
  State<createPostView> createState() => _createPostViewState();
}


class _createPostViewState extends State<createPostView> {

  //var
  final tecTitle = TextEditingController();
  final tecBody = TextEditingController();
  FirebaseFirestore db = FirebaseFirestore.instance;
  ImagePicker _picker = ImagePicker();
  File _imagePreview = File("");
  late fbUser user;

  //methods
  void openGallery() async {
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imagePreview = File(image.path);
      });
    }
  }
  void openCamera() async {
    XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _imagePreview = File(image.path);
      });
    }
  }
  void getUser() async {
    user = await DataHolder().fbAdmin.getUser();
  }
  void uploadPost() async {
    //---------- INICIO SUBIR IMAGEN ----------
    final storageRef = FirebaseStorage.instance.ref();
    String rutaEnNube = "posts/" +
        FirebaseAuth.instance.currentUser!.uid +
        "/imgs/"+
        DateTime.now().toString()+
        ".jpg";
    final rutaAFicheroEnNube = storageRef.child(rutaEnNube);
    final metadata = SettableMetadata(contentType: "image/jpg");

    try {
      await rutaAFicheroEnNube.putFile(_imagePreview, metadata);
    }
    on FirebaseException catch (e) {

    }

    print("SE HA SUBIDO LA IMAGEEEEEENNNNNN");

    String imgUrl = await rutaAFicheroEnNube.getDownloadURL();

    print("Se ha subido la imagen ----------->>>>>>>>" + imgUrl);

    //---------- FIN DE SUBIR IMAGEN ----------

    //---------- INICIO DE SUBIR POST ----------

    fbPost newPost = fbPost(
      title: tecTitle.text,
      body: tecBody.text,
      sUrlImg: imgUrl,
      sUserName: user.name,
    );
    DataHolder().createPostInFB(newPost);

    //---------- FIN DE SUBIR POST ----------

    Navigator.of(context).pop();
  }

  //initialize
  @override
  void initState() {
    getUser();
    super.initState();
  }

  //paint
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Create post'),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 25),
      ),
      body:
      SingleChildScrollView(
          child:
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              textField(sLabel: 'Title', myController: tecTitle, icIzq: Icons.title_outlined),
              textField(sLabel: 'Body', myController: tecBody, icIzq: Icons.textsms_outlined),
              Image.file(_imagePreview, width: 400, height: 400,),
              Row (
                children: [
                  FilledButton(onPressed: openGallery, child: Text("Gallery")),
                  FilledButton(onPressed: openCamera, child: Text("Cámara")),
                ],
              ),
              SizedBox(height: 30,),
              FilledButton(onPressed:() {uploadPost();}, child: const Text('Post!'),),
            ],
          )
      ),
    );
  }
}