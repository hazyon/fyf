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
  final GlobalKey<FormState> _updatePasswordKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _updateGradeKey = GlobalKey<FormState>();

  TextEditingController firstNameInputController;
  TextEditingController lastNameInputController;
  TextEditingController pwdInputController;
  TextEditingController confirmPwdInputController;

  DocumentReference userProfileRef;

  int _radioValue;
  List<int> values = [9, 10, 11, 12];

  @override
  initState() {
    print("running initState");
    userProfileRef =
        Firestore.instance.collection("users").document(widget.uid);
    // TODO: currently you have to hot reload to show the current value, change so that it automatically loads the current name or it is just blank
    userProfileRef.get().then((result) {
      firstNameInputController =
          new TextEditingController(text: result["fname"]);
      lastNameInputController =
          new TextEditingController(text: result["surname"]);
    });
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

  String pwdValidator(String value) {
    if (value.length < 8) {
      return 'Password must be longer than 8 characters';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    print("running build");
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
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'First Name',
                        prefixIcon: Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: new Icon(Icons.person, color: Colors.blue)),
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
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'Last Name',
                          prefixIcon: Padding(
                              padding: EdgeInsets.only(left: 10),
                              child:
                                  new Icon(Icons.person, color: Colors.blue)),
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
                          borderRadius:
                              BorderRadius.all(Radius.circular(16.0))),
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      onPressed: () {
                        if (_updateNameKey.currentState.validate()) {
                          userProfileRef.updateData({
                            "fname": firstNameInputController.text,
                            "surname": lastNameInputController.text
                          }).catchError((err) => print(err));
                          firstNameInputController.clear();
                          lastNameInputController.clear();
                          pwdInputController.clear();
                          confirmPwdInputController.clear();
                          _openNewPage(
                              "Your name has been successfully updated!");
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
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Password',
                        prefixIcon: Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: new Icon(Icons.lock, color: Colors.blue)),
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
                      ),
                      controller: pwdInputController,
                      obscureText: true,
                      validator: pwdValidator,
                    ),
                    new Padding(padding: EdgeInsets.all(5.0)),
                    TextFormField(
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Confirm Password',
                        prefixIcon: Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: new Icon(Icons.lock, color: Colors.blue)),
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
                      ),
                      controller: confirmPwdInputController,
                      obscureText: true,
                      validator: pwdValidator,
                    ),
                    new Padding(padding: EdgeInsets.all(7.5)),
                    RaisedButton(
                      child: Text("Change Password"),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(16.0))),
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
                                      firstNameInputController.clear();
                                      lastNameInputController.clear();
                                      pwdInputController.clear();
                                      confirmPwdInputController.clear();
                                    }).catchError((err) => print(err)))
                                .catchError((err) => print(err));
                            _openNewPage(
                                "Your password has been successfully updated!");
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
                    new Padding(padding: EdgeInsets.all(10.0)),
                    Form(
                      key: _updateGradeKey,
                      child: Column(
                        children: <Widget>[
                          Text(
                            "Grade",
                            style: new TextStyle(
                              fontSize: 15.0,
                              color: Colors.grey,
                            ),
                          ),
                          Row(
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
                          new Padding(padding: EdgeInsets.all(5.0)),
                          RaisedButton(
                            child: Text("Update Grade"),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16.0))),
                            color: Theme.of(context).primaryColor,
                            textColor: Colors.white,
                            onPressed: () {
                              if (values.contains(_radioValue)) {
                                userProfileRef.updateData({
                                  "grade": _radioValue,
                                }).catchError((err) => print(err));
                                // clear controllers and radios
                                firstNameInputController.clear();
                                lastNameInputController.clear();
                                pwdInputController.clear();
                                confirmPwdInputController.clear();
                                _radioValue = null;
                                _openNewPage(
                                    "Your grade has been successfully updated!");
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    RaisedButton(
                        child: Text("Classes"),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(16.0))),
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        onPressed: () {}),
                  ]))
            ],
          ),
        ));
  }

  // shows success message on submission of form; adapted from https://fluttercentral.com/Articles/Post/19/Creating_a_Form_in_Flutter
  void _openNewPage(String message) {
    Navigator.of(context).push(
      new MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return new Scaffold(
            appBar: new AppBar(
              title: new Text('Success'),
            ),
            body: new Center(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 19.0),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 19.0),
                        ),
                        Text(
                          message,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: new TextStyle(fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
