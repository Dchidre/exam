import 'package:exa_chircea/FbObjects/fbUser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../OnBoarding/InitialView.dart';
import '../../Singletone/DataHolder.dart';

class userInfo extends StatefulWidget {
  final bool isCollapsed;



  userInfo({
    Key? key,
    required this.isCollapsed,
  }) : super(key: key);

  @override
  State<userInfo> createState() => _userInfoState();
}

class _userInfoState extends State<userInfo> {
  late fbUser user;

  @override
  void initState() {
    super.initState();
    // Fetch user data initially when the widget is created
    fetchUser();
  }

  void logOut() {
    FirebaseAuth.instance.signOut();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => InitialView()),
        ModalRoute.withName('/initialView')
    );
  }
  Future<void> fetchUser() async {
    fbUser currentUser = await DataHolder().fbAdmin.getCurrentUser();
    setState(() {
      user = currentUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<fbUser>(
      future: DataHolder().fbAdmin.getCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(color: Colors.white);
        } else if (snapshot.hasError || snapshot.data == null) {
          return Text('Error: Unable to fetch user data');
        } else {
          fbUser user = snapshot.data!;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: widget.isCollapsed ? 70 : 100,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(20),
            ),
            child: widget.isCollapsed
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
                        child: Image.network(
                          user.sAvatar,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              'User Name',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.clip,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'MEMBER',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.logout,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
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
                      child: Image.network(
                        user.sAvatar,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: IconButton(
                    onPressed: () {logOut();},
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
      },
    );
  }
}