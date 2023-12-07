
import 'package:exa_chircea/Home/PhoneHomeView.dart';
import 'package:exa_chircea/Home/WebHomeView.dart';
import 'package:exa_chircea/Settings/SettingView.dart';
import 'package:exa_chircea/Settings/createPostView.dart';
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
          '/initialView':(context) => InitialView(),
          '/splashView':(context) => SplashView(),
          '/homeView':(context) => WebHomeView(),
        },
          initialRoute: '/homeView',
      );
    }

    //******************PHONE***************************
    else {
      return MaterialApp(
          title: "Esta es mi Actividad!",
          debugShowCheckedModeBanner: false,
          routes: {
          '/initialView':(context) => InitialView(),
          '/splashView':(context) => SplashView(),
          '/homeView':(context) => PhoneHomeView(),
          '/settingsView':(context) => SettingsView(),
          '/createPostView':(context) => createPostView(),
          },
          initialRoute: '/initialView',
      );
    }
    }
  }