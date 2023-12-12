

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exa_chircea/components/bottomMenu.dart';
import 'package:exa_chircea/components/drawer/DrawerView.dart';
import 'package:flutter/material.dart';

import '../FbObjects/fbPost.dart';
import '../FbObjects/fbUser.dart';
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
  late fbUser user;

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
  void bottomMenuActions(int indice) async {
    if (indice == 0) {
      setState(() {
        //blForm = true;
      });
    } else if (indice == 2) {
      setState(() {
        //blForm = false;
      });
    } else if (indice == 1) {
      Navigator.of(context).popAndPushNamed('/homeView');
    }
  }


  //widgets
  Widget? listCreator(BuildContext context, int index) {
    final post = postList[index];
    return FutureBuilder<fbUser>(
      future: DataHolder().fbAdmin.getUser(post.idUser),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Return a placeholder or loading indicator while fetching user data
          return LinearProgressIndicator(color: Colors.black, backgroundColor: Colors.grey,);
        } else if (snapshot.hasError) {
          // Handle error case
          return Text('Error fetching user data');
        } else if (!snapshot.hasData) {
          // Handle no user data case
          return Text('No user data available');
        } else {
          final user = snapshot.data!;
          return listPost(
            sUserName: post.sUserName,
            sAvatar: user.sAvatar,
            urlImg: post.sUrlImg,
            iPos: index,
            onPostTap: onPostTapDo,
          );
        }
      },
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
          list()
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