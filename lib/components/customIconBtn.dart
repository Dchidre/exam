
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class customIconBtn extends StatelessWidget {
  final Icon icono;
  final Function()? fAction;

  //predeterminados y requeridos
  customIconBtn({Key? key,
    this.icono = const Icon(Icons.question_mark),
    this.fAction = null,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: fAction,
      icon: icono,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.black),
        foregroundColor: MaterialStateProperty.all(Colors.white),
      ),
    );
  }
}