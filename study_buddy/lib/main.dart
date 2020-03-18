import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:study_buddy/splash.dart';

import './splash.dart';
import './register.dart';
import './login.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]) // app is only vertical
      .then((_) {
    runApp(new MyApp());
  });
}
class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new MyAppState();
}

class MyAppState extends State {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Study Buddy",
      home: SplashPage(),
      routes: <String, WidgetBuilder>{
        /*'/task': (BuildContext context) => SecondPage(title: 'Task'),
        '/home': (BuildContext context) => MyHomePage(title: 'Home'),*/
        '/login': (BuildContext context) => LoginPage(),
        '/register': (BuildContext context) => RegisterPage(),
      }
    );
  }
}
