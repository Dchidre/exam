
import 'package:flutter/material.dart';

class textField extends StatelessWidget {
  final TextEditingController myController;
  final String sLabel;
  final bool blIsPass;
  final IconData icIzq;

  //predeterminados y requeridos
  textField({Key? key,
    required this.sLabel,
    required this.myController,
    this.blIsPass = false,
    this.icIzq = Icons.add_circle_rounded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.symmetric(horizontal: 60, vertical: 16),
      child: TextField(
        //general
        controller: myController,
        //password
        obscureText: blIsPass,
        enableSuggestions: !blIsPass,
        autocorrect: !blIsPass,
        //deco
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: sLabel,
          labelStyle: TextStyle(color: Colors.black),
          prefixIcon: Icon(icIzq),
          prefixIconColor: Colors.black,
        ),
      ),
    );
  }
}