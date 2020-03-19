import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:study_buddy/splash.dart';

import './splash.dart';
import './register.dart';
import './login.dart';

<<<<<<< HEAD
/*
void main() {
=======
void main() => runApp(MyApp());
/*void main() {
>>>>>>> 04705d81339ec3dc90c511f2a5e9e6d2a2ade0c4
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp]) // app is only vertical
      .then((_) {
    runApp(new MyApp());
<<<<<<< HEAD
  });
}*/

void main() {
  runApp(new MyApp());
}
=======
  }).catchError((err) => print(err));
}*/
>>>>>>> 04705d81339ec3dc90c511f2a5e9e6d2a2ade0c4

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new MyAppState();
}

class MyAppState extends State {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            hintColor: Colors.blue,
            primaryColor: Color(0xFF4EB3D4),
            canvasColor: Colors.white,
            fontFamily: "Montserrat"),
        title: "Study Buddy",
        home: SplashPage(),
        routes: <String, WidgetBuilder>{
          /*'/task': (BuildContext context) => SecondPage(title: 'Task'),
        '/home': (BuildContext context) => MyHomePage(title: 'Home'),*/
          '/login': (BuildContext context) => LoginPage(),
          '/register': (BuildContext context) => RegisterPage(),
        });
  }
}
