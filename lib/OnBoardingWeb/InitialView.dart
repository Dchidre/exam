import 'package:flutter/material.dart';
import 'package:exa_chircea/OnBoarding/LoginDialog.dart';

import 'LoginDialog.dart';

class webInitialView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
        Padding(padding: EdgeInsets.symmetric(horizontal: 32),
        child:
        ListView(
          children: [
            Column(
              children: [
                SizedBox(height: 200,),
                Text("Never travel alone anymore", style: TextStyle(fontSize: 100)),
                SizedBox(height: 300,),
                FilledButton(
                  onPressed: () {webLoginDialog().showWebLoginDialog(context);},
                  child: Text("Login"),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.black),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
