import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:study_buddy/splash.dart';

import './splash.dart';
import './register.dart';
import './login.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new MyAppState();
}

class MyAppState extends State {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          hintColor: Colors.grey,
          primaryColor: Colors.blue,
          canvasColor: Colors.white,
          fontFamily: "Montserrat",
        ),
        title: "Study Buddy Test",
        home: SplashPage(),
        routes: <String, WidgetBuilder>{
          //'/task': (BuildContext context) => SecondPage(title: 'Task'),
          //'/home': (BuildContext context) => MyHomePage(title: 'Home'),
          '/login': (BuildContext context) => LoginPage(),
          '/register': (BuildContext context) => RegisterPage(),
        });
  }
}
