import 'package:flutter/material.dart';

class SplashView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashViewState();
  }
}

void waitTime(BuildContext context) {
  Future.delayed(Duration(seconds: 4)).then((_) {
    Navigator.of(context).pushReplacementNamed('/initialview');
  });
}

class _SplashViewState extends State<SplashView>{
  @override
  void initState() {
    super.initState();
    waitTime(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container( // Wrap in Container to set background color
      color: Colors.white, // Set background color to white
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/phone/smiley.gif',
                width: 250,
                height: 150,
                fit: BoxFit.fitHeight,
              ),
            ],
          ),
          SizedBox(height: 100,),
          CircularProgressIndicator(color: Colors.lightBlueAccent),
        ],
      ),
    );
  }
}
