import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exa_chircea/components/customBtn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/textField.dart';

class ProfileDialog {
  @override
  Future<Object?> showProfileDialog(BuildContext context) {

    //var
    FirebaseFirestore db = FirebaseFirestore.instance;
    final tecName = TextEditingController();
    final tecAge = TextEditingController();
    final tecRepPassword = TextEditingController();

    //methods
    late final profileData = <String, dynamic>{
      "nombre": tecName.text,
      "edad": int.parse(tecAge.text),
    };
    void createProfile(BuildContext context) async {
      String uidUsuario= FirebaseAuth.instance.currentUser!.uid;
      await db.collection("Usuarios").doc(uidUsuario).set(profileData);
    }
    void onClickCreateProfile(BuildContext context) {
      createProfile(context);
      Navigator.of(context).popAndPushNamed('/homeview');
    }

    //paint
    return showGeneralDialog(
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
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
      barrierLabel: "profile",
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
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child:
                          Text(
                            "Set up your profile!",
                            style: TextStyle(fontSize: 62, fontWeight: FontWeight.bold),
                          ),
                      ),
                      SizedBox(height: 50,),
                      //form
                      textField(sLabel: 'Name', myController: tecName, icIzq: Icons.mail_outline),
                      textField(sLabel: 'Age', myController: tecAge, icIzq: Icons.lock_open_outlined),
                      SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          customBtn(fAction: () {onClickCreateProfile(context);}, sText: "Create"),
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
