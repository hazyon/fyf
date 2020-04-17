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

  int _radioValue = 0;

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

    // for the radio buttons in the form
    void _handleRadioValueChange(int value) {
      setState(() {
        _radioValue = value;
      });
    }

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
                    new Text(
                      'Select Recepients',
                      style: new TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Radio(
                          value: 0,
                          groupValue: _radioValue,
                          onChanged: _handleRadioValueChange,
                        ),
                        new Text(
                          'All Class',
                          style: new TextStyle(fontSize: 14.0),
                        ),
                        new Radio(
                          value: 1,
                          groupValue: _radioValue,
                          onChanged: _handleRadioValueChange,
                        ),
                        new Text(
                          'All friends',
                          style: new TextStyle(fontSize: 14.0),
                        ),
                        new Radio(
                          value: 2,
                          groupValue: _radioValue,
                          onChanged: _handleRadioValueChange,
                        ),
                        new Text(
                          'Select',
                          style: new TextStyle(fontSize: 14.0),
                        ),
                      ],
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
                            "recepient": _radioValue
                          }); // adds to database

                          // clears form fields on submit
                          // todo: make sure date and time are cleared; figure out more efficient way to do this
                          titleInputController.clear();
                          descriptionInputController.clear();
                          locationInputController.clear();
                          classInputController.clear();

                          _openNewPage(); // success page on submission
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

  // shows success message on submission of form; adapted from https://fluttercentral.com/Articles/Post/19/Creating_a_Form_in_Flutter
  void _openNewPage() {
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
                          'You have Successfully Sent a Meeting Request!',
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
