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
      body: Center(
        child: Container(
          height: DataHolder().platformAdmin.getScreenWidth() * 1.5,
          margin: EdgeInsets.all(10.0),
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                spreadRadius: 0,
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: blIsPostLoaded
              ? SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    _dataPost.title,
                    style: TextStyle(fontSize: 40),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    _dataPost.body,
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  width: DataHolder().platformAdmin.getScreenWidth() * 0.85,
                  height: DataHolder().platformAdmin.getScreenWidth() * 0.85,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                    image: DecorationImage(
                      image: NetworkImage(_dataPost.sUrlImg),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                // Comments section placeholder
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.all(10.0),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Comments',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 5.0), // Space between text and icon
                          Icon(Icons.arrow_downward_rounded),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      // Add your comments list or section here
                      Text('This is a comment.'),
                      Text('This is another comment.'),
                    ],
                  ),
                ),
              ],
            ),
          )
              : const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [CircularProgressIndicator()],
            ),
          ),
        ),
      ),
    );
  }
}
