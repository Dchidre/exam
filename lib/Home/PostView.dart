
import 'package:exa_chircea/FbObjects/fbPost.dart';
import 'package:flutter/material.dart';

import '../Singletone/DataHolder.dart';

class PostView extends StatefulWidget {
  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {

  late fbPost _dataPost;
  bool blIsPostLoaded = false;

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
            const TextButton(onPressed: null, child: Text("Like")),
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