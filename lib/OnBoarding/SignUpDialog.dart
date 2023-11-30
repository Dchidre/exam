import 'package:flutter/material.dart';

class SignUpDialog {
  @override
  Future<Object?> showSignUpDialog(BuildContext context) {
    void cancelar(BuildContext context) {
      Navigator.of(context).pop();
    }
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
                    "Sign Up",
                    style: TextStyle(fontSize: 34),
                  ),
                  FilledButton(onPressed: () {Navigator.of(context).pop();}, child: Text("Sign up")),
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
