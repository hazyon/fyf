// adapted from the following tutorial https://www.youtube.com/watch?v=w0rfZm6a3Hs


import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './login.dart';

class ForgotPasswordPage extends StatefulWidget {
  ForgotPasswordPage({Key key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final GlobalKey<FormState> _emailFormKey = GlobalKey<FormState>();

  TextEditingController emailInputController;

  void sendPasswordResetEmail(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  showAlertDialog(BuildContext context, String sentEmail)
  {
    //button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        // TODO: put the redirect to login page here
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    LoginPage()),
                (_) => false);
      },
    );

    // set up Alert Dialog
    AlertDialog alert = AlertDialog(
      title: Text("Reset Password Email Sent"),
      content: Text("An reset password email has been sent to " + sentEmail + ".\nIf you do not receive an email, then there is no existing account with this email."),
      actions: <Widget>[okButton],
    );

    //show the Dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      }
    );
  }

  /// instantiates controllers
  @override
  initState() {
    emailInputController = new TextEditingController();
    super.initState();
  }

  /// forget password page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Enter email: "),
          centerTitle: true,
        ),
        body: Container(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
                child: Form(
              key: _emailFormKey,
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
                  ),
                  new Padding(padding: EdgeInsets.only(top: 20)),
                  new Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: SizedBox(
                        width: 800,
                        height: 55,
                        child: RaisedButton(
                          child: Text("SUBMIT",
                              style: new TextStyle(fontSize: 16)),
                          color: Theme.of(context).primaryColor,
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(100.0)),
                          onPressed: () {
                            if (_emailFormKey.currentState.validate()) {
                              sendPasswordResetEmail(emailInputController.text
                                  .toLowerCase()
                                  .trim());
                              showAlertDialog(context, emailInputController.text.toLowerCase().trim());

                            }
                            /*
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
                                      .catchError((err) => print(err)));
                            }
                           */
                          },
                        ),
                      )),
                ],
              ),
            ))));
  }
}
