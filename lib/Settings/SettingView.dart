import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
          Column(
            children: [
              SizedBox(height: 100),
              Text("Setting preview"),
            ],
          )
      ),
    );
  }

}