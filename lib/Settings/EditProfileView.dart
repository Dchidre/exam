import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../FbObjects/fbUser.dart';
import '../Singletone/DataHolder.dart';
import '../components/customBtn.dart';
import '../components/textField.dart';

class EditProfileView extends StatefulWidget {
  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  bool _uploading = false;
  FirebaseFirestore db = FirebaseFirestore.instance;
  ImagePicker _picker = ImagePicker();
  File _imagePreview = File("");
  late fbUser user;
  String imagen = "";

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
  Future<String> uploadAvatar() async {
    try {
      //get ref
      final storageRef = FirebaseStorage.instance.ref();
      //set route
      String rutaEnNube = "avatars/" +
          FirebaseAuth.instance.currentUser!.uid +
          DateTime.now().toString() +
          ".jpg";
      final rutaAFicheroEnNube = storageRef.child(rutaEnNube);
      final metadata = SettableMetadata(contentType: "image/jpg");

      //upload the image and return a "download URL" with which we are gonna get the image from now on
      await rutaAFicheroEnNube.putFile(_imagePreview, metadata);
      String url = await rutaAFicheroEnNube.getDownloadURL();
      print("URL de la imagen: $url");
      return url;
    } catch (e) {
      print("Error uploading image: $e");
      return ""; // Return a default URL or handle the error accordingly
    }
  }
  void getUser() async {
    user = await DataHolder().fbAdmin.getCurrentUser();
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Change your avatar!'),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 25),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 50,),
            _imagePreview.path == '' ?
            SizedBox()
            :
            ClipOval( //show profile image before uploading
              child: Image.file(
                _imagePreview,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                customBtn(fAction: openGallery, sText: "Gallery"),
                SizedBox(width: 30,),
                customBtn(fAction: openCamera, sText: "Camera"),
              ],
            ),
            SizedBox(height: 30),
            // Inside onPressed method in ChangeProfileView


            _uploading ?
            CircularProgressIndicator(color: Colors.black, backgroundColor: Colors.grey,)

            :

            customBtn( //upload new photo
              fAction: () async {
                setState(() {
                  _uploading = true;
                });

                if (_imagePreview.path.isNotEmpty) {
                  imagen = await uploadAvatar();
                  setState(() {
                    _uploading = false;
                  });
                  Navigator.of(context).popAndPushNamed('/homeView');
                }
                try {
                  //set user as the current user logged in
                  user = await fbUser.getUserData(FirebaseAuth.instance.currentUser!.uid);
                  //if i have a downlaod url, update the user and place the url on its avatar field
                  if (imagen.isNotEmpty) {
                    await DataHolder().fbAdmin.updateUserData(user.name, user.age, imagen, user.pos, user.address);
                  }
                  if (mounted) { // Check if the widget is still mounted
                    setState(() {
                      // Update any local widget state here if needed
                    });
                  }
                } catch (e) {
                  setState(() {
                    _uploading = false;
                  });
                  print("Error updating user data: $e");
                  // Handle error accordingly
                }
              },
              sText: 'Do it!',
            ),
          ],
        ),
      );
  }
}
