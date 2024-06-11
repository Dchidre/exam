import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../components/customBtn.dart';
import '../../components/textField.dart';

class PhoneDialog {
  @override
  Future<Object?> showPhoneDialog(BuildContext context) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    final tecPhone = TextEditingController();

    void onClickSendCode(BuildContext context) async {

    }

    return showGeneralDialog(
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
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
      barrierLabel: "signUp",
      context: context,
      pageBuilder: (context, _, __) => Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(40)),
          ),
          height: 500,
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
                      Text(
                        "Phone", // Change the title here
                        style: TextStyle(fontSize: 62, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 50,),
                      textField(
                          sLabel: 'Phone', // Change label to 'Phone'
                          myController: tecPhone,
                          icIzq: Icons.phone), // Add icon for phone
                      SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          customBtn(
                              fAction: () {
                                onClickSendCode(context);
                              },
                              sText: "Send Code"), // Change button text to 'Send Code'
                          SizedBox(width: 40,),
                          customBtn(
                              fAction: () {
                                Navigator.of(context).pop();
                              },
                              sText: "Cancel"),
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
