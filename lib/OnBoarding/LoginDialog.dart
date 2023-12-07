import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exa_chircea/FbObjects/fbUser.dart';
import 'package:exa_chircea/OnBoarding/ProfileDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/customBtn.dart';
import '../components/textField.dart';
import 'SignUpDialog.dart';

class LoginDialog {

  @override
  Future<Object?> showLoginDialog(BuildContext context) {

    //var
    FirebaseFirestore db = FirebaseFirestore.instance;
    final tecEmail = TextEditingController();
    final tecPassword = TextEditingController();

    //methods
    Future<void> onClickLogin() async {
      //signIn
      try {
        final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: tecEmail.text,
            password: tecPassword.text
        );

        //take the UID
        String uid=FirebaseAuth.instance.currentUser!.uid;

        //make a reference to the database profiles
        DocumentReference<fbUser> ref=db.collection("Usuarios")
            .doc(uid)
            .withConverter(fromFirestore: fbUser.fromFirestore,
          toFirestore: (fbUser user, _) => user.toFirestore(),);

        //take the profile if exists
        DocumentSnapshot<fbUser> docSnap=await ref.get();
        fbUser? user=docSnap.data();

        //now, does it exist?
        if(user!=null){
          Navigator.of(context).popAndPushNamed("/homeView");
        }
        else{
          Navigator.of(context).pop();
          ProfileDialog().showProfileDialog(context);
        }

      }
      on FirebaseAuthException catch (e) {


        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
      }
    }

    //paint
    return showGeneralDialog(
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, -1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: Duration(milliseconds: 600),
      barrierDismissible: true,
      barrierLabel: "signIn",
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
            body: ListView(children: [
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 50,),
                    //title
                    Text(
                      "Sign In",
                      style: TextStyle(fontSize: 62, fontWeight: FontWeight.bold),
                    ),
                  SizedBox(height: 50,),
                    //form
                    textField(sLabel: 'Email', myController: tecEmail, icIzq: Icons.mail_outline),
                    textField(sLabel: 'Password', myController: tecPassword, blIsPass: true, icIzq: Icons.lock_open_outlined),
                  SizedBox(height: 30),
                    //btn
                    customBtn(fAction: () {onClickLogin();}, sText: 'Login'),
                  SizedBox(height: 30),
                    //divide
                    Padding(padding: EdgeInsets.symmetric(horizontal: 30),
                        child:
                          const Row(
                            children: [
                              Expanded(
                                child: Divider(color: Colors.black),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  "OR",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              Expanded(
                                child: Divider(color: Colors.black),
                              ),
                            ],
                          ),
                      ),
                  SizedBox(height: 30,),
                    //btn
                    customBtn(fAction: () {
                            Navigator.of(context).pop();
                            SignUpDialog().showSignUpDialog(context);
                          }, sText: 'Sign Up'),
                    ],)
                  // Add your other sign-in elements here
              ),
            ]
          ),
          ),
        ),
      )
    );
  }
}
