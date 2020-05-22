// adapted from the following tutorial https://heartbeat.fritz.ai/firebase-user-authentication-in-flutter-1635fb175675

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';

import './selectFrees.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();

  TextEditingController firstNameInputController;
  TextEditingController lastNameInputController;
  TextEditingController emailInputController;
  TextEditingController pwdInputController;
  TextEditingController confirmPwdInputController;
  int _radioValue;
  List<int> values = [9, 10, 11, 12];

  /// instantiate controllers
  @override
  initState() {
    firstNameInputController = new TextEditingController();
    lastNameInputController = new TextEditingController();
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    confirmPwdInputController = new TextEditingController();
    _radioValue = 0; // none of the buttons are selected at the beginning
    super.initState();
  }

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;
    });
  }

  /// validates email address
  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value.trim())) {
      return 'Email format is invalid';
    } else {
      return null;
    }
  }

  /// validates password
  String pwdValidator(String value) {
    if (value.length == 0) {
      return 'Password can\'t be empty';
    } else if (value.length < 8) {
      return 'Password must be longer than 8 characters';
    } else {
      return null;
    }
  }

  /// registration page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Register"),
        ),
        body: Container(
            padding: const EdgeInsets.all(12.5),
            child: SingleChildScrollView(
                child: Form(
              key: _registerFormKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'First Name',
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
                      prefixIcon: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: new Icon(Icons.person, color: Colors.blue)),
                    ),
                    controller: firstNameInputController,
                    validator: (value) {
                      if (value.length < 2) {
                        return "Please enter a valid first name.";
                      }
                      return null;
                    },
                  ),
                  new Padding(padding: EdgeInsets.only(top: 7.5)),
                  TextFormField(
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Last Name',
                        enabledBorder: const OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(100.0)),
                          borderSide:
                              const BorderSide(color: Color(0xffD3D3D3)),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(100.0)),
                          borderSide:
                              const BorderSide(color: Color(0xffD3D3D3)),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100)),
                        prefixIcon: Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: new Icon(Icons.person, color: Colors.blue)),
                      ),
                      controller: lastNameInputController,
                      validator: (value) {
                        if (value.length < 2) {
                          return "Please enter a valid last name.";
                        }
                        return null;
                      }),
                  new Padding(padding: EdgeInsets.only(top: 7.5)),
                  TextFormField(
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Email',
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
                      prefixIcon: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: new Icon(Icons.email, color: Colors.blue)),
                    ),
                    controller: emailInputController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (!EmailValidator.validate(value.trim())) {
                        return "Email format is invalid";
                      }
                      return null;
                    },
                  ),
                  new Padding(padding: EdgeInsets.only(top: 7.5)),
                  TextFormField(
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Password',
                        enabledBorder: const OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(100.0)),
                          borderSide:
                              const BorderSide(color: Color(0xffD3D3D3)),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(100.0)),
                          borderSide:
                              const BorderSide(color: Color(0xffD3D3D3)),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100)),
                        prefixIcon: Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: new Icon(Icons.lock, color: Colors.blue))),
                    controller: pwdInputController,
                    obscureText: true,
                    validator: pwdValidator,
                  ),
                  new Padding(padding: EdgeInsets.only(top: 7.5)),
                  TextFormField(
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Confirm Password',
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
                      prefixIcon: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: new Icon(Icons.lock, color: Colors.blue)),
                    ),
                    controller: confirmPwdInputController,
                    obscureText: true,
                    validator: pwdValidator,
                  ),
                  new Padding(padding: EdgeInsets.only(top: 5)),
                  Text(
                    "Grade",
                    style: new TextStyle(
                      fontSize: 15.0,
                      color: Colors.grey,
                    ),
                  ),
                  Row(
                    // todo: create this with a loop
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Radio(
                        value: 9,
                        groupValue: _radioValue,
                        onChanged: _handleRadioValueChange,
                      ),
                      Text(
                        '9',
                        style: new TextStyle(fontSize: 14.0),
                      ),
                      Radio(
                        value: 10,
                        groupValue: _radioValue,
                        onChanged: _handleRadioValueChange,
                      ),
                      Text(
                        '10',
                        style: new TextStyle(fontSize: 14.0),
                      ),
                      Radio(
                        value: 11,
                        groupValue: _radioValue,
                        onChanged: _handleRadioValueChange,
                      ),
                      Text(
                        '11',
                        style: new TextStyle(fontSize: 14.0),
                      ),
                      Radio(
                        value: 12,
                        groupValue: _radioValue,
                        onChanged: _handleRadioValueChange,
                      ),
                      Text(
                        '12',
                        style: new TextStyle(fontSize: 14.0),
                      ),
                    ],
                  ),
                  new Padding(
                      padding: EdgeInsets.only(top: 0.1),
                      child: SizedBox(
                          width: 800,
                          height: 55,
                          child: RaisedButton(
                            child: Text("Register",
                                style: new TextStyle(fontSize: 16)),
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(100.0)),
                            color: Theme.of(context).primaryColor,
                            textColor: Colors.white,
                            onPressed: () {
                              if (_registerFormKey.currentState.validate()) {
                                if (values.contains(_radioValue)) {
                                  if (pwdInputController.text ==
                                      confirmPwdInputController.text) {
                                    FirebaseAuth.instance
                                        .createUserWithEmailAndPassword(
                                            email: emailInputController.text,
                                            password: pwdInputController.text)
                                        .then((currentUser) => Firestore
                                            .instance
                                            .collection("users")
                                            .document(currentUser.uid)
                                            .setData({
                                              "uid": currentUser.uid,
                                              "fname":
                                                  firstNameInputController.text,
                                              "surname":
                                                  lastNameInputController.text,
                                              "email": emailInputController.text
                                                  .toLowerCase()
                                                  .trim(),
                                              "grade": _radioValue,
                                            })
                                            .then((result) => {
                                                  Navigator.pushAndRemoveUntil(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              SelectFrees(
                                                                uid: currentUser
                                                                    .uid,
                                                              )),
                                                      (_) => false),
                                                  firstNameInputController
                                                      .clear(),
                                                  lastNameInputController
                                                      .clear(),
                                                  emailInputController.clear(),
                                                  pwdInputController.clear(),
                                                  confirmPwdInputController
                                                      .clear(),
                                                })
                                            .catchError((err) => print(err)))
                                        .catchError((err) => print(err));
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text("Error"),
                                            content: Text(
                                                "The passwords do not match"),
                                            actions: <Widget>[
                                              FlatButton(
                                                child: Text("Close"),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              )
                                            ],
                                          );
                                        });
                                  }
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("Error"),
                                          content: Text(
                                              "You must choose your grade"),
                                          actions: <Widget>[
                                            FlatButton(
                                              child: Text("Close"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            )
                                          ],
                                        );
                                      });
                                }
                              }
                            },
                          ))),
                  FlatButton(
                      child: Text("I already have an account",
                          style:
                              new TextStyle(fontSize: 14, color: Colors.grey))),
                ],
              ),
            ))));
  }
}
