
import 'package:flutter/material.dart';

class customBtn extends StatelessWidget {
  final String sText;
  final Function()? fAction;

  //predeterminados y requeridos
  customBtn({Key? key,
    this.sText = "btn",
    this.fAction = null,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: fAction,
      child: Text(sText),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.black),
          foregroundColor: MaterialStateProperty.all(Colors.white),
      ),
    );
  }
}