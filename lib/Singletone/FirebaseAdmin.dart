

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exa_chircea/FbObjects/fbPost.dart';
import 'package:exa_chircea/Home/PostView.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../FbObjects/fbUser.dart';


class FirebaseAdmin {
  FirebaseFirestore db = FirebaseFirestore.instance;
  Future<fbUser> getUser() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    fbUser user;

    DocumentReference<fbUser> ref = db.collection("Usuarios")
        .doc(uid).withConverter(fromFirestore: fbUser.fromFirestore,
      toFirestore: (fbUser user, _) => user.toFirestore(),);

    DocumentSnapshot<fbUser> docSnap = await ref.get();
    user = docSnap.data()!;

    return user;
  }
  Future<void> updateUserData(String name, int age, String image) async {
    fbUser usuario = fbUser(age: age, name: name, sAvatar: image);
    String uidUsuario = FirebaseAuth.instance.currentUser!.uid;
    await db.collection("Usuarios").doc(uidUsuario).set(usuario.toFirestore());
  }
  Future<void> updatePostData(String sUserName, String title, String body, String sUrlImg, String idPost, idUser) async {
    fbPost post = fbPost(sUserName: sUserName, title: title, body: body, sUrlImg: sUrlImg, idPost: idPost, idUser: idUser);
    await db.collection("Posts").doc(idPost).set(post.toFirestore());
  }
}