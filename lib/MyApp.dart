
import 'package:flutter/material.dart';
import 'OnBoarding/InitialView.dart';

class exaApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Esta es mi Actividad!",
      debugShowCheckedModeBanner: false,
      routes: {
        '/initialview':(context) => InitialView(),
      },
        initialRoute: '/initialview',
    );
    }
  }