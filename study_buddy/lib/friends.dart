// adapted from the following tutorial https://heartbeat.fritz.ai/firebase-user-authentication-in-flutter-1635fb175675
// synchronous and asynchronous validator set up is adapted from https://medium.com/@nocnoc/the-secret-to-async-validation-on-flutter-forms-4b273c667c03
// filtering is based on this tutorial https://medium.com/@thedome6/how-to-create-a-searchable-filterable-listview-in-flutter-4faf3e300477

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import './customCard.dart';

class Friends extends StatefulWidget {
  Friends({Key key, this.uid, this.date}) : super(key: key);

  final String uid;
  final String date;

  @override
  _FriendsState createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  final GlobalKey<FormState> _friendFormKey = GlobalKey<FormState>();
  TextEditingController taskTitleInputController;
  String filter;
  List<String> emails = [];
  List<String> tmpEmailsArray = [];
  StreamController<List<String>> emailsStream;
  //TextEditingController taskDescripInputController;
  //String currentEmailUID;
  var recipient;

  bool _isInvalidAsyncEmail = false;
  bool _haveValidEmail = false;

  String _emailOfRecipient;

  //String _senderFName;
  //String _senderSurname;
  bool _haveData = false;
  String _senderFullName;
  String _senderEmail;

  @override
  initState() {
    // TODO: commenting out the following text edit line
    taskTitleInputController = new TextEditingController();
    //emailsStream = StreamController<List<String>>();
    //emailsStream.add(tmpEmailsArray);
    /* taskTitleInputController.addListener(() {
      filter = taskTitleInputController.text;
      tmpEmailsArray.clear();
      if (filter == null || filter == "") {
        for (String email in emails)
          {
            tmpEmailsArray.add(email);
          }
      }
      else
        {
          for (String email in emails)
            {
              if (email.contains(filter))
                {
                  tmpEmailsArray.add(email);
                }
            }
        }

      //_showDialog();
      /*setState(() {
        filter = taskTitleInputController.text;
      });*/
    });*/
    //currentEmailUID = "UIDplaceholder";

    getUserInfo();
    super.initState();
  }

  void getUserInfo() {
    /*await Firestore.instance
        .collection("users")
        .document(widget.uid)
        .get()
        .then((DocumentSnapshot result) {
      //_senderFName = result["fname"];
      _senderFullName = result["fname"] + " " + result["surname"];
      //_senderSurname = result["surname"];
      _senderEmail = result["email"];
    }).catchError((err) => print(err));*/
    //taskDescripInputController = new TextEditingController();

    Firestore.instance.collection("users").getDocuments().then((docs) {
      setState(() {
        docs.documents.forEach((doc) {
          emails.add(
              doc["email"] + " (" + doc["fname"] + " " + doc["surname"] + ")");
          if (doc["uid"] == widget.uid) {
            _senderFullName = doc["fname"] + " " + doc["surname"];
            //_senderSurname = result["surname"];
            _senderEmail = doc["email"];
            _haveData = true;
          }
        });
      });
    });
  }

  // TODO: I don't know if the following is necessary
  @override
  void dispose() {
    taskTitleInputController.dispose();
    super.dispose();
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
                    Container(
                      width: double.maxFinite,
                      child: SizedBox(
                          height: 200.0,
                          child: new MyDialogContent(
                            emails: emails,
                            textController: taskTitleInputController,
                          )
                          /*StreamBuilder(
                          stream: emailsStream.stream,
                          builder: (context, snapshot) {
                            return tmpEmailsArray.isEmpty ? new Container() : new Container(child: ListView.builder(
                              itemCount: tmpEmailsArray.length,
                              itemBuilder: (BuildContext context, int index) {
                                return new Card(child: new Text(tmpEmailsArray[index]));
                              },
                            ));
                          },
                        )*/
                          /*ListView.builder(
                          itemCount: emails.length,
                          itemBuilder: (BuildContext context, int index) {
                            return filter == null || filter == ""
                                ? new Card(child: new Text(emails[index]))
                                : emails[index].contains(filter)
                                    ? new Card(child: new Text(emails[index]))
                                    : new Container();
                          },
                        ),*/
                          ),
                    )
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
                        "fullName": _senderFullName,
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
    if (_haveData) {
      return Column(children: <Widget>[
        Expanded(
          child: SizedBox(
              child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection("users")
                    .document(widget.uid)
                    .collection('friends')
                    .orderBy("status")
                    .snapshots(),
                builder:
                    (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError)
                    return new Text('Error: ${snapshot.error}');
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return new Text('Loading...');
                    default:
                      return new ListView(
                        children:
                        snapshot.data.documents.map((
                            DocumentSnapshot document) {
                          return new CustomCard(
                            name: document['fullName'],
                            email: document['email'],
                            date: document['date'],
                            status: document['status'],
                            uid: document["uid"],
                            docId: document.documentID,
                            userEmail: _senderEmail,
                            userFullName: _senderFullName,
                            userUID: widget.uid,
                          );
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
    else
      {
        /*return ModalProgressHUD(
          opacity: 0.5,
          progressIndicator: CircularProgressIndicator(),
        );*/
        return Center(
          child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation(Colors.blue),),
        );
      }
  }
}

class MyDialogContent extends StatefulWidget {
  MyDialogContent({Key key, this.emails, this.textController})
      : super(key: key);

  List<String> emails;
  TextEditingController textController;

  @override
  _MyDialogContentState createState() => new _MyDialogContentState();
}

class _MyDialogContentState extends State<MyDialogContent> {
  String filter;

  @override
  void initState() {
    //widget.textController = new TextEditingController();
    widget.textController.addListener(() {
      if (!mounted) {
        return;
      }
      setState(() {
        filter = widget.textController.text;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.builder(
      itemCount: widget.emails.length,
      itemBuilder: (BuildContext context, int index) {
        return (filter == null || filter == "")
            ? new Card(child: new Text(widget.emails[index]))
            : widget.emails[index].toLowerCase().contains(filter.toLowerCase())
                ? new Card(child: new Text(widget.emails[index]))
                : new Container();
      },
    );
  }
}
