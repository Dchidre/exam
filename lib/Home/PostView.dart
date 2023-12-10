
import 'package:exa_chircea/FbObjects/fbPost.dart';
import 'package:flutter/material.dart';

import '../Settings/EditPostView.dart';
import '../Singletone/DataHolder.dart';

class PostView extends StatefulWidget {
  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {

  late fbPost _dataPost;
  bool blIsPostLoaded = false;
  final List<fbPost> postList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadCachePost();
  }

  void loadCachePost() async {
    var temp1 = await DataHolder().loadFbPost();
    setState(() {
      _dataPost = temp1!;
      blIsPostLoaded = true;
    });
  }
  void onTapEditDo(int index) {
    DataHolder().selectedPost = postList[index];
    DataHolder().savePostInCache();
    Navigator.of(context).pushNamed('/EditPostView');
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('Post'),
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 25),
        ),
        body: blIsPostLoaded?
        Center(child:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_dataPost.title),
            Text(_dataPost.body),
            Image.network(_dataPost.sUrlImg),
            TextButton(onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditPostView(idPost: _dataPost.idPost),
                ),
              );
            }, child: Text("Edit")),
          ],
        )
        )
            :
        const Center(child:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [CircularProgressIndicator()],
        )
        )

    );
  }
}