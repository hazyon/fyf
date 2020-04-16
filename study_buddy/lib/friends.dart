// adapted from the following tutorial https://heartbeat.fritz.ai/firebase-user-authentication-in-flutter-1635fb175675
// synchronous and asynchronous validator set up is adapted from https://medium.com/@nocnoc/the-secret-to-async-validation-on-flutter-forms-4b273c667c03

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';

import './customCard.dart';

class Friends extends StatefulWidget {
  Friends({Key key, this.uid, this.date}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String uid;

  final String date;

  @override
  _FriendsState createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  final GlobalKey<FormState> _friendFormKey = GlobalKey<FormState>();
  TextEditingController taskTitleInputController;
  //TextEditingController taskDescripInputController;
  //String currentEmailUID;
  var recipient;

  bool _isInvalidAsyncEmail = false;
  bool _haveValidEmail = false;

  String _emailOfRecipient;

  String _senderFName;
  String _senderSurname;
  String _senderEmail;

  @override
  initState() {
    taskTitleInputController = new TextEditingController();
    //currentEmailUID = "UIDplaceholder";
    Firestore.instance
        .collection("users")
        .document(widget.uid)
        .get()
        .then((DocumentSnapshot result) {
      _senderFName = result["fname"];
      _senderSurname = result["surname"];
      _senderEmail = result["email"];
    }).catchError((err) => print(err));
    //taskDescripInputController = new TextEditingController();
    super.initState();
  }

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Email format is invalid';
    }
    if (_isInvalidAsyncEmail) {
      _isInvalidAsyncEmail = false;
      return "This email doesn't exist";
      /*Firestore.instance
          .collection("users")
          .where("email", isEqualTo: value)
           .getDocuments().then((QuerySnapshot docs) {
             //return "I have the documents";
             if (docs.documents.isNotEmpty)
              {
                // emails are unique, so there should only be one
                recipient = docs.documents[0].data;
                currentEmailUID = recipient["fname"] + " " + recipient["surname"];
                return null;
              }

          });*/
      //return "This email doesn't exist";
      //return(currentEmailUID);

    }
    //return "something went wrong";
    return null;
  }

  _showDialog() async {
    _isInvalidAsyncEmail = false;
    _haveValidEmail = false;

    // run the validators on reload to process async results
    _friendFormKey.currentState?.validate();
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: Column(
          children: <Widget>[
            Text("Please fill all fields to create a new friend request"),
            Form(
                key: _friendFormKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Email', hintText: "john.doe@gmail.com"),
                      controller: taskTitleInputController,
                      keyboardType: TextInputType.emailAddress,
                      validator: emailValidator,
                      onSaved: (value) => _emailOfRecipient = value,
                    ),
                  ],
                )),
          ],
        ),
        actions: <Widget>[
          FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                taskTitleInputController.clear();
                //taskDescripInputController.clear();
                Navigator.pop(context);
              }),
          FlatButton(
              child: Text('Add'),
              onPressed: () {
                if (_friendFormKey.currentState.validate()) {
                  _friendFormKey.currentState.save();

                  // dismiss keyboard during async call
                  FocusScope.of(context).requestFocus(new FocusNode());

                  // TODO: might need to set state here

                  //Future.delayed(Duration(seconds: 1), () {
                  Firestore.instance
                      .collection("users")
                      .where("email", isEqualTo: _emailOfRecipient)
                      .getDocuments()
                      .then((QuerySnapshot docs) {
                    //return "I have the documents";
                    //setState(() {
                    if (docs.documents.isNotEmpty) {
                      // emails are unique, so there should only be one
                      recipient = docs.documents[0].data;
                      //currentEmailUID = recipient["uid"];
                      //recipient["fname"] + " " + recipient["surname"];
                      _isInvalidAsyncEmail = false;
                      //_haveValidEmail = true;
                      Firestore.instance
                          .collection("users")
                          .document(recipient["uid"])
                          .collection('friends')
                          .add({
                        "uid": widget.uid,
                        "status": "incoming",
                        "fullName": _senderFName + " " + _senderSurname,
                        "email": _senderEmail,
                        "date": widget.date
                      }).catchError((err) => print(err));

                      Firestore.instance
                          .collection("users")
                          .document(widget.uid)
                          .collection('friends')
                          .add({
                            "uid": recipient["uid"],
                            "status": "pending",
                            "fullName":
                                recipient["fname"] + " " + recipient["surname"],
                            "email": taskTitleInputController.text,
                            "date": widget.date
                          })
                          .then((result) => {
                                Navigator.pop(context),
                                taskTitleInputController.clear(),
                                //taskDescripInputController.clear(),
                              })
                          .catchError((err) => print(err));
                    } else {
                      _isInvalidAsyncEmail = true;
                      _friendFormKey.currentState.validate();
                    }

                    //_showDialog();
                    //});
                  });
                  //if (_haveValidEmail) {

                  //}
                  //});
                  // TODO: check if this person exists
                  //String placeholder = "placeholder name";
                  /*Firestore.instance
                      .collection('users')
                      .snapshots()
                      .listen((data) =>
                      data.documents.forEach((doc) => placeholder = doc["email"]));*/

                }
              })
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Expanded(
        child: SizedBox(
            child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection("users")
              .document(widget.uid)
              .collection('friends')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return new Text('Loading...');
              default:
                return new ListView(
                  children:
                      snapshot.data.documents.map((DocumentSnapshot document) {
                    return new CustomCard(
                        name: document['fullName'],
                        email: document['email'],
                        date: document['date']);
                  }).toList(),
                );
            }
          },
        )),
      ),
      RaisedButton(
        onPressed: _showDialog,
        child: Icon(Icons.add),
      )
    ]);
  }
}
