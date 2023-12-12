
import 'package:exa_chircea/FbObjects/fbPost.dart';
import 'package:flutter/material.dart';

import '../Singletone/DataHolder.dart';

class PhonePostView extends StatefulWidget {
  @override
  State<PhonePostView> createState() => _PhonePostViewState();
}

class _PhonePostViewState extends State<PhonePostView> {

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
            Text(_dataPost.title, style: TextStyle(fontSize: 40)),
            Text(_dataPost.body, style: TextStyle(fontSize: 20)),
            SizedBox(height: 80),
            Image.network(
              _dataPost.sUrlImg,
              height: DataHolder().platformAdmin.getScreenWidth()*0.9,
              width: DataHolder().platformAdmin.getScreenWidth()*0.9,
              fit: BoxFit.cover),
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