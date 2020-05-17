// adapted from the following tutorial https://heartbeat.fritz.ai/firebase-user-authentication-in-flutter-1635fb175675

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';

import './control.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  TextEditingController emailInputController;
  TextEditingController pwdInputController;

  /// instantiates controllers
  @override
  initState() {
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    super.initState();
  }

  /// validates email address
  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Email format is invalid';
    } else {
      return null;
    }
  }

  /// validates password
  String pwdValidator(String value) {
    if (value.length == 0) {
      return 'Password can\'t be empty';
    } else {
      /* TODO: when logging in, you have to consider the possible errors of having a username that doesn't exist and having the incorrect password*/
      return null;
    }
  }

  /// login page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Login"),
          centerTitle: true,
        ),
        body: Container(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
                child: Form(
              key: _loginFormKey,
              child: Column(
                children: <Widget>[
                  new Padding(padding: EdgeInsets.only(top: 30)),
                  SizedBox(
                    width: 85, // hard coding child width
                    child: Image.asset("assets/pencil.png"),
                  ),
                  new Padding(padding: EdgeInsets.only(top: 60)),
                  TextFormField(
                    decoration: new InputDecoration(
                      hintText: 'Email',
                      prefixIcon: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: new Icon(Icons.mail, color: Colors.blue)),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(100.0)),
                        borderSide: const BorderSide(color: Color(0xffD3D3D3)),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(100.0)),
                        borderSide: const BorderSide(color: Color(0xffD3D3D3)),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100)),
                    ),
                    controller: emailInputController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (!EmailValidator.validate(value.trim())) {
                        return "Email format is invalid";
                      }
                      return null;
                    },
                    //validator: emailValidator,
                  ),
                  new Padding(padding: EdgeInsets.only(top: 20)),
                  TextFormField(
                    decoration: new InputDecoration(
                      hintText: 'Password',
                      prefixIcon: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: new Icon(Icons.lock, color: Colors.blue)),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(100.0)),
                        borderSide: const BorderSide(color: Color(0xffD3D3D3)),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(100.0)),
                        borderSide: const BorderSide(color: Color(0xffD3D3D3)),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100)),
                    ),
                    controller: pwdInputController,
                    obscureText: true, // hides password
                    validator: pwdValidator,
                  ),
                  new Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: SizedBox(
                        width: 800,
                        height: 55,
                        child: RaisedButton(
                          child:
                              Text("LOGIN", style: new TextStyle(fontSize: 16)),
                          color: Theme.of(context).primaryColor,
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(100.0)),
                          onPressed: () {
                            if (_loginFormKey.currentState.validate()) {
                              FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                      email: emailInputController.text
                                          .toLowerCase()
                                          .trim(),
                                      password: pwdInputController.text)
                                  .then((currentUser) => Firestore.instance
                                      .collection("users")
                                      .document(currentUser.uid)
                                      .get()
                                      .then((DocumentSnapshot result) =>
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ControlPage(
                                                        title: result["fname"] +
                                                            "'s Tasks",
                                                        uid: currentUser.uid,
                                                      ))))
                                      .catchError((err) => print(err)))
                                  .catchError((err) => print(err));
                            }
                          },
                        ),
                      )),
                  FlatButton(
                    padding: EdgeInsets.only(top: 20),
                    child: Text("Create an account",
                        style: new TextStyle(fontSize: 16, color: Colors.grey)),
                    onPressed: () {
                      Navigator.pushNamed(context, "/register");
                    },
                  )
                ],
              ),
            ))));
  }
}
