
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exa_chircea/FbObjects/fbUser.dart';
import 'package:exa_chircea/Singletone/GeolocAdmin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../FbObjects/fbPost.dart';
import 'FirebaseAdmin.dart';
import 'PlatformAdmin.dart';

class DataHolder {

  //var
  static final DataHolder _dataHolder = DataHolder._internal();
  FirebaseFirestore db = FirebaseFirestore.instance;
  fbPost? selectedPost;
  late String sPostTitle;
  late PlatformAdmin platformAdmin;
  FirebaseAdmin fbAdmin = FirebaseAdmin();
  GeolocAdmin geolocAdmin = GeolocAdmin();
  late fbUser user;
  //Function(int i)? fAction;
  Function(Position position)? gpsPostChange;

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

    String? fbpost_username = prefs.getString('fbpost_username');
    fbpost_username ??= "";

    String? fbpost_idpost = prefs.getString('fbpost_idpost');
    fbpost_idpost ??= "";

    String? fbpost_iduser = prefs.getString('fbpost_iduser');
    fbpost_iduser ??= "";

    selectedPost = fbPost(title: fbpost_title, body: fbpost_body, sUrlImg: fbpost_surlimg, sUserName: fbpost_username, idPost: fbpost_idpost, idUser: fbpost_iduser);
    return selectedPost;
  }
  Future<fbUser?> loadFbUser() async {
    //take the UID
    String uid=FirebaseAuth.instance.currentUser!.uid;

    //make a reference to the database profiles
    DocumentReference<fbUser> ref=db.collection("Usuarios")
        .doc(uid)
        .withConverter(fromFirestore: fbUser.fromFirestore,
      toFirestore: (fbUser user, _) => user.toFirestore(),);

    //take the profile if exists
    DocumentSnapshot<fbUser> docSnap=await ref.get();
    user=docSnap.data()!;

    return user;
  }
  Future<void> createPostInFB(fbPost postNuevo) async {
    CollectionReference<fbPost> ref = db.collection("Posts")
        .withConverter(
      fromFirestore: fbPost.fromFirestore,
      toFirestore: (fbPost post, _) => post.toFirestore(),
    );

    // Add the new post with Firestore's auto-generated ID
    DocumentReference<fbPost> postDocRef = ref.doc();
    String idPost = postDocRef.id;

    // Create the post with a temporary ID first
    await postDocRef.set(postNuevo.copyWith(idPost: idPost));

    // Retrieve the newly created post from Firestore
    DocumentSnapshot<fbPost> snapshot = await postDocRef.get();
    fbPost newlyCreatedPost = snapshot.data()!;

    // Update the post with its own ID
    String postId = snapshot.id;
    await ref.doc(postId).set(newlyCreatedPost.copyWith(idPost: postId));
  }
  void listenPosChange(Function(Position? position)? gpsPostChange) {
    GeolocAdmin().registrarCambiosLoc(changePosPhone);
    this.gpsPostChange=gpsPostChange;
  }
  void changePosPhone(Position? position) {
    user.pos = GeoPoint(position!.latitude, position.longitude);
    //print("ENTRE!!!!!!!!!! ${position.toString()}");
    fbAdmin.updateUser(user);
    //fAction!(5);
    if(gpsPostChange!=null){
      gpsPostChange!(position);
    }
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