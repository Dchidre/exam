import 'package:flutter/material.dart';

import 'SignUpDialog.dart';

class LoginDialog {
  @override
  Future<Object?> showLoginDialog(BuildContext context) {
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
            body: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Sign In",
                    style: TextStyle(fontSize: 34),
                  ),
                  FilledButton(onPressed: () {
                    Navigator.of(context).pop();
                    SignUpDialog().showSignUpDialog(context);}, child: Text("Sign up")),
                  // Add your other sign-in elements here
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
