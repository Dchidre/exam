import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashViewState();
  }
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    checkSession();
  }

  void checkSession() async {
    await Future.delayed(Duration(seconds: 3));
    if (FirebaseAuth.instance.currentUser != null) {
      Navigator.of(context).pushReplacementNamed("/homeView");
    } else {
      Navigator.of(context).pushReplacementNamed("/initialView");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Image.asset(
            'assets/phone/splashGIF.gif',
            width: 250,
            height: 150,
            fit: BoxFit.fitHeight,
          ),
        ),
      ),
    );
  }
}
