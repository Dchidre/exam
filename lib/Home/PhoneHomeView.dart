

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exa_chircea/components/bottomMenu.dart';
import 'package:exa_chircea/components/drawer/DrawerView.dart';
import 'package:flutter/material.dart';

import '../FbObjects/fbPost.dart';
import '../Singletone/DataHolder.dart';
import '../components/posts/gridPost.dart';
import '../components/posts/listPost.dart';

class PhoneHomeView extends StatefulWidget {
  @override
  State<PhoneHomeView> createState() => _PhoneHomeViewState();
}

  class _PhoneHomeViewState extends State<PhoneHomeView>{

  //var
  FirebaseFirestore db = FirebaseFirestore.instance;
  final List<fbPost> postList = [];
  bool blForm = false;

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
    Navigator.of(context).pushNamed('/postView');
  }
  void bottomMenuActions(int indice) {
    setState(() {
      if(indice == 0){
        blForm = true;
      }
      else if(indice==2){
        blForm = false;
      }
      else if(indice==1){
        Navigator.popAndPushNamed(context, '/homeView');
      }
    });
  }


  //widgets
  Widget? listCreator(BuildContext context, int index){
    return listPost(
      sUserName: postList[index].sUserName,
      urlImg: postList[index].sUrlImg,
      iPos: index, //para que el propio post sea consciente de su posición
      onPostTap: onPostTapDo,
    );
  }
  Widget listSeparator(BuildContext context, int index) {
    //return Divider(thickness: 5,);
    return const Column(
      children: [
        Divider(),
        //CircularProgressIndicator(),
        //Image.network("https://media.tenor.com/zBc1XhcbTSoAAAAC/nyan-cat-rainbow.gif")
      ],
    );
  }
  Widget list() {
    return ListView.separated(
      padding: EdgeInsets.all(8),
      itemCount: postList.length,
      itemBuilder: listCreator,
      separatorBuilder: listSeparator,
    );
  }
  //--------------------GRID-----------------------
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
  //--------------------BOTH-----------------------
  Widget posts(bool blForm) {
    return
      blForm ? list() : grid();
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
      body:
      Center(
        child:
          posts(blForm),
      ),
      appBar: AppBar(backgroundColor: Colors.black, foregroundColor: Colors.white,),
      bottomNavigationBar: bottomMenu(onTap: bottomMenuActions),
      drawer: DrawerView(),
      floatingActionButton: FloatingActionButton(
          onPressed: () {Navigator.of(context).pushNamed('/createPostView');},
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          child: Icon(Icons.add_circle),
      ),
    );
  }
  }