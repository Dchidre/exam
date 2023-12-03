

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exa_chircea/components/posts/gridPost.dart';
import 'package:flutter/material.dart';

import '../FbObjects/fbPost.dart';
import '../Singletone/DataHolder.dart';
import '../components/posts/listPost.dart';

class WebHomeView extends StatefulWidget {
  @override
  State<WebHomeView> createState() => _WebHomeViewState();
}

class _WebHomeViewState extends State<WebHomeView>{

  //var
  FirebaseFirestore db = FirebaseFirestore.instance;
  final List<fbPost> postList = [];

  //methods
  @override
  void downloadPosts() async{
    CollectionReference<fbPost> ref=db.collection("Posts")
        .withConverter(fromFirestore: fbPost.fromFirestore,
      toFirestore: (fbPost post, _) => post.toFirestore(),);


    QuerySnapshot<fbPost> querySnapshot=await ref.get();
    for(int i=0;i<querySnapshot.docs.length;i++){
      setState(() {
        postList.add(querySnapshot.docs[i].data());
      });

    }

  }
  void onPostTapDo(int index) {
    DataHolder().selectedPost = postList[index];
    DataHolder().savePostInCache();
    Navigator.of(context).pushNamed('/postview');
  }

  //widgets
  Widget? gridCreator(BuildContext context, int index){
    return gridPost(
        sUserName: postList[index].sUserName,
        urlImg: postList[index].sUrlImg,
        iPos: index, //para que el propio post sea consciente de su posición
        onPostTap: onPostTapDo,
    );
  }
  Widget grid() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemCount: postList.length,
      itemBuilder: gridCreator,

    );
  }

  //initialize statics
  @override
  void initState() {
    super.initState();
    downloadPosts();
  }

  //paint
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
          Padding(padding: EdgeInsets.symmetric(horizontal: DataHolder().platformAdmin.getScreenWidth()*0.15),
            child:
              grid(),
          ),
      )
    );
  }
}