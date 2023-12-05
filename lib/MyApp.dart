
import 'package:exa_chircea/Home/PhoneHomeView.dart';
import 'package:exa_chircea/Home/WebHomeView.dart';
import 'package:exa_chircea/Singletone/DataHolder.dart';
import 'package:exa_chircea/Splash/SplashView.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'OnBoarding/InitialView.dart';

class exaApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    //initialize
    DataHolder().initPlatformAdmin(context);

    //******************WEB***************************
    if (kIsWeb) {
      return MaterialApp(
        title: "Esta es mi Actividad!",
        debugShowCheckedModeBanner: false,
        routes: {
          '/initialview':(context) => InitialView(),
          '/splashview':(context) => SplashView(),
          '/homeview':(context) => WebHomeView(),
        },
          initialRoute: '/homeview',
      );
    }

    //******************PHONE***************************
    else {
      return MaterialApp(
          title: "Esta es mi Actividad!",
          debugShowCheckedModeBanner: false,
          routes: {
          '/initialview':(context) => InitialView(),
          '/splashview':(context) => SplashView(),
          '/homeview':(context) => PhoneHomeView(),
          },
          initialRoute: '/homeview',
      );
    }
    }
  }