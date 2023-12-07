
import 'package:cloud_firestore/cloud_firestore.dart';
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
}