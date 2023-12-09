import 'package:exa_chircea/FbObjects/fbUser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../OnBoarding/InitialView.dart';

class userInfo extends StatelessWidget {
  final sAvatar;
  final bool isCollapsed;

  const userInfo({
    Key? key,
    required this.isCollapsed,
    this.sAvatar = "https://ih1.redbubble.net/image.1046392292.3346/st,medium,507x507-pad,600x600,f8f8f8.jpg",
  }) : super(key: key);

  void logOut(BuildContext context) {
    FirebaseAuth.instance.signOut();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => InitialView()),
        ModalRoute.withName('/initialView')
    );
  }
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: isCollapsed ? 70 : 100,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(20),
      ),
      child: isCollapsed
          ? Center(
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(sAvatar),
                ),
              ),
            ),
            // ... rest of the widget
          ],
        ),
      )
          : Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 10),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(sAvatar),
              ),
            ),
          ),
          Expanded(
            child: IconButton(
              onPressed: () {
                logOut(context);
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}