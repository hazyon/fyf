// adapted from the following tutorial https://heartbeat.fritz.ai/firebase-user-authentication-in-flutter-1635fb175675

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

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
  TextEditingController locationInputController;
  TextEditingController classInputController;

  DateTime date;
  DateTime time;

  //DocumentReference userProfileRef;

  @override
  initState() {
    print("Running initState"); // for debug

    // instantiate controllers
    titleInputController = new TextEditingController();
    descriptionInputController = new TextEditingController();
    locationInputController = new TextEditingController();
    classInputController = new TextEditingController();

    // userProfileRef = Firestore.instance.collection("users").document(widget.uid);

    /*userProfileRef.get().then((result) {
      titleInputController = new TextEditingController(text: result["title"]);
      descriptionInputController =
          new TextEditingController(text: result["description"]);
      locationInputController =
          new TextEditingController(text: result["location"]);
      classInputController = new TextEditingController(text: result["class"]);
    });*/

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Running build"); // debug
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
                    DateTimePickerFormField(
                      inputType: InputType.date,
                      format: DateFormat("yyyy-MM-dd"),
                      initialDate: DateTime.now(),
                      // todo: fix firstDate so that it doesn't cause issues with initialDate
                      //firstDate: DateTime.now(),
                      editable: false,
                      decoration: InputDecoration(
                          labelText: 'Date',
                          border: OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(17.0),
                            borderSide: new BorderSide(),
                          ),
                          hasFloatingPlaceholder: false),
                      onChanged: (dt) => setState(() => date = dt),
                      /*
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      */
                    ),
                    DateTimePickerFormField(
                      inputType: InputType.time,
                      initialTime: TimeOfDay.now(),
                      editable: false,
                      format: DateFormat("HH:mm"),
                      decoration: InputDecoration(
                        labelText: 'Time',
                        hasFloatingPlaceholder: false,
                        border: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(17.0),
                          borderSide: new BorderSide(),
                        ),
                        //hintText: "Doe"
                      ),
                      onChanged: (t) => setState(() => time = t),
                      /*
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      */
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
                          Firestore.instance
                              .collection('meetings')
                              .document()
                              .setData({
                            // adds to database
                            'title': titleInputController.text,
                            'description': descriptionInputController.text,
                            "date": date,
                            "time": time,
                            "location": locationInputController.text,
                            "class": classInputController.text,
                          }); // adds to database
                          /*userProfileRef.updateData({
                            "title": titleInputController.text,
                            "description": descriptionInputController.text,
                            "date": date,
                            "time": time,
                            "location": locationInputController.text,
                            "class": classInputController.text,
                          }).catchError((err) => print(err));*/
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
