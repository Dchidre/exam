import 'package:flutter/material.dart';

import '../components/customBtn.dart';
import '../components/textField.dart';
import 'SignUpDialog.dart';

class LoginDialog {
  @override
  Future<Object?> showLoginDialog(BuildContext context) {
    late BuildContext _context;
    final tecEmail = TextEditingController();
    final tecPassword = TextEditingController();
    final snackFalloLogin = SnackBar(content: Text('Algo ha fallado :('),);


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
                    customBtn(fAction: () {}, sText: 'Login'),
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
