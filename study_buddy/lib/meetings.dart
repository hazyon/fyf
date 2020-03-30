// adapted from the following tutorial https://heartbeat.fritz.ai/firebase-user-authentication-in-flutter-1635fb175675

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class MeetingPage extends StatefulWidget {
  MeetingPage({Key key, this.uid}) : super(key: key);

  final String uid;

  @override
  _MeetingPageState createState() => new _MeetingPageState();
}

class _MeetingPageState extends State<MeetingPage> {
  final GlobalKey<FormState> _addMeetingKey = GlobalKey<FormState>();

  TextEditingController titleInputController;
  TextEditingController descriptionInputController;
  TextEditingController dateInputController;
  TextEditingController timeInputController;
  TextEditingController locationInputController;
  TextEditingController classInputController;

  DocumentReference userProfileRef;

  @override
  initState() {
    print("Running initState");
    userProfileRef =
        Firestore.instance.collection("users").document(widget.uid);
    // TODO: currently you have to hot reload to show the current value, change so that it automatically loads the current name or it is just blank
    userProfileRef.get().then((result) {
      titleInputController =
        new TextEditingController(text: result["title"]);
      descriptionInputController =
        new TextEditingController(text: result["description"]);
      dateInputController =
          new TextEditingController(text: result["date"]);
      timeInputController =
          new TextEditingController(text: result["time"]);
      locationInputController =
          new TextEditingController(text: result["location"]);
      classInputController =
      new TextEditingController(text: result["class"]);

    });
    super.initState();
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
                key: _addMeetingKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(17.0),
                          borderSide: new BorderSide(),
                        ),
                      ),
                      controller: titleInputController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(17.0),
                          borderSide: new BorderSide(),
                        ),
                      ),
                      controller: descriptionInputController,
                    ),
                    new Padding(padding: EdgeInsets.all(10.0)),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Date',
                        border: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(17.0),
                          borderSide: new BorderSide(),
                        ),
                      ),
                      keyboardType: TextInputType.datetime,
                      controller: dateInputController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Time',
                        border: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(17.0),
                          borderSide: new BorderSide(),
                        ),
                        //hintText: "Doe"
                      ),
                      keyboardType: TextInputType.datetime,
                      controller: timeInputController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Location',
                        border: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(17.0),
                          borderSide: new BorderSide(),
                        ),
                      ),
                      controller: locationInputController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    new Padding(padding: EdgeInsets.all(10.0)),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Select Class',
                        border: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(17.0),
                          borderSide: new BorderSide(),
                        ),
                      ),
                      controller: classInputController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    new Padding(padding: EdgeInsets.all(10.0)),
                    RaisedButton(
                      child: Text("Submit"),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(16.0))),
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      onPressed: () {
                        if (_addMeetingKey.currentState.validate()) {
                          userProfileRef.updateData({
                                "title": titleInputController.text,
                                "description": descriptionInputController.text,
                                "date": dateInputController.text,
                                "time": timeInputController.text,
                                "location": locationInputController.text,
                                "class": classInputController.text,
                              })
                              .catchError((err) => print(err)) // TODO: this line might be optional?
                              .catchError((err) => print(err));
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
