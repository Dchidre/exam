import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exa_chircea/OnBoarding/ProfileDialog.dart';
import 'package:exa_chircea/components/customBtn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/textField.dart';

class SignUpDialog {
  @override
  Future<Object?> showSignUpDialog(BuildContext context) {

    //var
    FirebaseFirestore db = FirebaseFirestore.instance;
    final tecEmail = TextEditingController();
    final tecPassword = TextEditingController();
    final tecRepPassword = TextEditingController();

    //methods
    void onClickRegister(BuildContext context) async {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: tecEmail.text, password: tecPassword.text);
        Navigator.of(context).pop();
        ProfileDialog().showProfileDialog(context);
      }
      on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
        }
      } catch (e) {
        print(e);
      }
      }

    //paint
    return showGeneralDialog(
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;
        /*
        Left-to-Right (Leftwards): (x: -1.0, y: 0.0) - This moves from left to right.
        Right-to-Left (Rightwards): (x: 1.0, y: 0.0) - Moves from right to left.
        Top-to-Bottom (Downwards): (x: 0.0, y: -1.0) - Slides from top to bottom.
        Bottom-to-Top (Upwards): (x: 0.0, y: 1.0) - Moves from bottom to top.
        */

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: Duration(milliseconds: 600),
      barrierDismissible: true,
      barrierLabel: "signUp",
      context: context,
      pageBuilder: (context, _, __) => Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(40)),
          ),
          height: 620,
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: ListView(
              children: [
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 50,),
                      //title
                      Text(
                        "Sign Up",
                        style: TextStyle(fontSize: 62, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 50,),
                      //form
                      textField(sLabel: 'Email', myController: tecEmail, icIzq: Icons.mail_outline),
                      textField(sLabel: 'Password', myController: tecPassword, blIsPass: true, icIzq: Icons.lock_open_outlined),
                      textField(sLabel: 'Repeat password', myController: tecRepPassword, blIsPass: true, icIzq: Icons.lock_open_outlined),
                      SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          customBtn(fAction: () {onClickRegister(context);}, sText: "Sign Up"),
                          SizedBox(width: 40,),
                          customBtn(fAction: () {Navigator.of(context).pop();}, sText: "Cancel"),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
