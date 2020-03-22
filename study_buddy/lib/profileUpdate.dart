// adapted from the following tutorial https://heartbeat.fritz.ai/firebase-user-authentication-in-flutter-1635fb175675

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key, this.uid}) : super(key: key);

  final String uid;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<FormState> _updateNameKey = GlobalKey<FormState>();
  TextEditingController firstNameInputController;
  TextEditingController lastNameInputController;
  final GlobalKey<FormState> _updatePasswordKey = GlobalKey<FormState>();
  TextEditingController pwdInputController;
  TextEditingController confirmPwdInputController;
  DocumentReference userProfileRef;

  @override
  initState() {
    print("Running initState");
    userProfileRef =
        Firestore.instance.collection("users").document(widget.uid);
    // TODO: currently you have to hot reload to show the current value, change so that it automatically loads the current name or it is just blank
    userProfileRef.get().then((result) {
      firstNameInputController =
          new TextEditingController(text: result["fname"]);
      lastNameInputController =
          new TextEditingController(text: result["surname"]);
    });
    //firstNameInputController = new TextEditingController(text: "FirstName");
    //lastNameInputController = new TextEditingController(text: "LastName");
    pwdInputController = new TextEditingController();
    confirmPwdInputController = new TextEditingController();
    super.initState();
  }

  String pwdValidator(String value) {
    if (value.length < 8) {
      return 'Password must be longer than 8 characters';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Running build");
    return Container(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              new Padding(padding: EdgeInsets.only(top: 10.0)),
              Form(
                key: _updateNameKey,
                child: Column(
                  children: <Widget>[
                    //new Padding(padding: EdgeInsets.only(top: 1.0)),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'First Name',
                          //hintText: "John"
                          border: OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(25.0),
                            borderSide: new BorderSide(),
                        ),
                      ),
                      controller: firstNameInputController,
                      validator: (value) {
                        if (value.length < 3) {
                          return "Please enter a valid first name.";
                        }
                        return null;
                      },
                    ),
                    new Padding(padding: EdgeInsets.all(5.0)),
                    TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Last Name',
                            border: OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(25.0),
                              borderSide: new BorderSide(),
                            ),
                            //hintText: "Doe"
                        ),
                        controller: lastNameInputController,
                        validator: (value) {
                          if (value.length < 2) {
                            return "Please enter a valid last name.";
                          }
                          return null;
                        }),
                    new Padding(padding: EdgeInsets.all(10.0)),
                    RaisedButton(
                      child: Text("Update Name"),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16.0))),
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      onPressed: () {
                        if (_updateNameKey.currentState.validate()) {
                          userProfileRef
                              .updateData({
                                "fname": firstNameInputController.text,
                                "surname": lastNameInputController.text
                              })
                              .catchError((err) => print(err))  // TODO: this line might be optional?
                              .catchError((err) => print(err));
                        }
                      },
                    ),
                  ],
                ),
              ),
              Form(
                  key: _updatePasswordKey,
                  child: Column(children: <Widget>[
                    new Padding(padding: EdgeInsets.all(10.0)),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(25.0),
                            borderSide: new BorderSide(),
                          ),
                        //hintText: "********",
                      ),
                      controller: pwdInputController,
                      obscureText: true,
                      validator: pwdValidator,
                    ),
                    new Padding(padding: EdgeInsets.all(5.0)),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Confirm Password',
                        border: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(),
                        ),
                          //hintText: "********",
                      ),
                      controller: confirmPwdInputController,
                      obscureText: true,
                      validator: pwdValidator,
                    ),
                    new Padding(padding: EdgeInsets.all(7.5)),
                    RaisedButton(
                      child: Text("Change Password"),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16.0))),
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      onPressed: () {
                        if (_updatePasswordKey.currentState.validate()) {
                          if (pwdInputController.text ==
                              confirmPwdInputController.text) {
                            FirebaseAuth.instance
                                .currentUser()
                                .then((FirebaseUser user) => user
                                        .updatePassword(pwdInputController.text)
                                        .then((result) {
                                      pwdInputController.clear();
                                      confirmPwdInputController.clear();
                                    }).catchError((err) => print(err)))
                                .catchError((err) => print(err));
                          } else {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Error"),
                                    content: Text("The passwords do not match"),
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
                    ),
                  ]))
            ],
          ),
        ));
  }
}
