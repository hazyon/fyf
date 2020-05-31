// adapted from the following tutorial https://heartbeat.fritz.ai/firebase-user-authentication-in-flutter-1635fb175675

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:email_validator/email_validator.dart';

import './control.dart';
import './forgotPassword.dart';

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
    value = value
        .toLowerCase()
        .trim(); // accounts for capitalization and whitespace
    if (value.length == 0) {
      return 'Email can\'t be empty';
    } else if (!EmailValidator.validate(value)) {
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
      return null;
    }
  }

  /// deals with user errors
  /// https://stackoverflow.com/questions/56113778/how-to-handle-firebase-auth-exceptions-on-flutter
  Future<FirebaseUser> signIn(String email, String password) async {
    FirebaseUser user;
    String errorMessage;
    try {
      user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } catch (error) {
      switch (error.code) {
        case "ERROR_INVALID_EMAIL":
          errorMessage = "Invalid Email";
          break;
        case "ERROR_WRONG_PASSWORD":
          errorMessage = "Incorrect Password";
          break;
        case "ERROR_USER_NOT_FOUND":
          errorMessage = "User with this email does not exist";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          errorMessage = "Too many requests. Try again later.";
          break;
        default:
          errorMessage = "Something went wrong.";
      }
    }

    if (errorMessage != null) {
      Widget okButton = FlatButton(
        child: Text("OK"),
        onPressed: () {
          Navigator.of(context).pop(); // dismiss dialog
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text("Error"),
        content: Text(errorMessage),
        actions: [
          okButton,
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
      return Future.error(errorMessage);
    }
    return user;
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
                  new Padding(padding: EdgeInsets.only(top: 20)),
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
                    validator: emailValidator,
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
                            // once validation is passed successfully, database authentication begins
                            if (_loginFormKey.currentState.validate()) {
                              signIn(
                                  emailInputController.text
                                      .toLowerCase()
                                      .trim(),
                                  pwdInputController.text)
                                  .then((currentUser) => Firestore.instance
                                      .collection("users")
                                      .document(currentUser.uid)
                                      .get()
                                      .then((DocumentSnapshot result) =>
                                          // user is redirected to home page upon login
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ControlPage(
                                                        title: "Study Buddy",
                                                        uid: currentUser.uid,
                                                      ))))
                                      .catchError((err) => print(err)));
                            }
                          },
                        ),
                      )),
                  FlatButton(
                    padding: EdgeInsets.only(top: 10),
                    child: Text("Forgot Password?",
                        style: new TextStyle(fontSize: 16, color: Colors.grey)),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgotPasswordPage()));
                    },
                  ),
                  FlatButton(
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
