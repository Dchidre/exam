import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exa_chircea/components/posts/gridPost.dart';
import 'package:flutter/material.dart';

import '../FbObjects/fbPost.dart';
import '../FbObjects/fbUser.dart';
import '../Singletone/DataHolder.dart';

class WebHomeView extends StatefulWidget {
  @override
  State<WebHomeView> createState() => _WebHomeViewState();
}

class _WebHomeViewState extends State<WebHomeView> {
  // Variables
  FirebaseFirestore db = FirebaseFirestore.instance;
  final List<fbPost> postList = [];

  // Métodos
  @override
  void initState() {
    super.initState();
    downloadPosts();
  }

  void downloadPosts() async {
    CollectionReference<fbPost> ref = db.collection("Posts")
        .withConverter(
      fromFirestore: fbPost.fromFirestore,
      toFirestore: (fbPost post, _) => post.toFirestore(),
    );

    QuerySnapshot<fbPost> querySnapshot = await ref.get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
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

  // Widgets
  Widget? gridCreator(BuildContext context, int index) {
    final post = postList[index];
    return FutureBuilder<fbUser>(
      future: DataHolder().fbAdmin.getUser(post.idUser),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LinearProgressIndicator(color: Colors.black, backgroundColor: Colors.grey);
        } else if (snapshot.hasError) {
          return Text('Error fetching user data');
        } else if (!snapshot.hasData) {
          return Text('No user data available');
        } else {
          final user = snapshot.data!;
          return GridPost(
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

  Widget grid() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // Número de columnas en la grilla
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        childAspectRatio: 0.75, // Ajustar el aspect ratio para hacer las tarjetas más pequeñas verticalmente
      ),
      itemCount: postList.length,
      itemBuilder: gridCreator,
    );
  }

  // Pintar
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: DataHolder().platformAdmin.getScreenWidth() * 0.15),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 40.0, bottom: 20.0), // Add padding to the top and bottom of the title
                child: Text(
                  'Review the latest posts!', // Title text
                  textAlign: TextAlign.center, // Center the text
                  style: TextStyle(
                    fontSize: 36, // Larger font size
                    fontWeight: FontWeight.bold, // Bold text
                  ),
                ),
              ),
              Expanded(child: grid()), // Use Expanded to ensure the grid takes available space
            ],
          ),
        ),
      ),
    );
  }
}