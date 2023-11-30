import 'package:flutter/material.dart';
import 'package:exa_chircea/OnBoarding/LoginDialog.dart';

class InitialView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
        Padding(padding: EdgeInsets.symmetric(horizontal: 32),
        child:
        Column(
          children: [
            SizedBox(height: 250,),
            Text("Never travel alone anymore", style: TextStyle(fontSize: 60)),
            SizedBox(height: 130,),
            FilledButton(
              onPressed: () {LoginDialog().showLoginDialog(context);},
              child: Text("Login"),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
