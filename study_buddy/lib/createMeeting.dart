// adapted from the following tutorial https://heartbeat.fritz.ai/firebase-user-authentication-in-flutter-1635fb175675

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'dart:collection';

class CreateMeetingPage extends StatefulWidget {
  CreateMeetingPage({Key key, this.uid}) : super(key: key);

  final String uid;

  @override
  _CreateMeetingPageState createState() => new _CreateMeetingPageState();
}

class _CreateMeetingPageState extends State<CreateMeetingPage> {
  final GlobalKey<FormState> _addMeetingKey = GlobalKey<FormState>();

  TextEditingController titleInputController;
  TextEditingController descriptionInputController;
  TextEditingController locationInputController;

  String filter;
  Map idToClassMap = new HashMap<String, String>();
  List<String> classNames = new List<String>();
  TextEditingController classInputController;
  bool _haveData = false;
  bool _haveFriends = false;

  Map idToFriendMap = new HashMap<String, String>();
  Map<String, bool> friends = {};

  DateTime date;
  DateTime time;

  int _radioValue = 0;

  String _meetingID = "";
  String _meetingTitle;
  String _meetingDescrip;
  String _meetingLocation;
  String _meetingClass;

  @override
  initState() {
    print("Running initState"); // debug

    // instantiate controllers
    titleInputController = new TextEditingController();
    descriptionInputController = new TextEditingController();
    locationInputController = new TextEditingController();
    classInputController = new TextEditingController();
    classInputController.addListener(() {
      setState(() {
        filter = classInputController.text;
      });
    });

    //_radioValue = 0; // none of the buttons are selected at the beginning
    getClassData();
    getFriends();
    super.initState();
  }

  void getClassData() {
    Firestore.instance
        .collection("dataArray")
        .orderBy("Department")
        .getDocuments()
        .then((docs) {
      print("have data, started putting it in variables");
      setState(() {
        docs.documents.forEach((doc) {
          String name =
              doc["Name"].toLowerCase() + " (" + doc["Department"] + ")";
          idToClassMap[doc["Name"].toLowerCase()] = doc.documentID;
          classNames.add(name);
        });

        print(idToClassMap);
        //print("Expect: " + idToClassMap["news & media lit. in the digi. era - s"]);
        _haveData = true;
      });
    });
  }

  void getFriends() {
    Firestore.instance
        .collection("users")
        .document(widget.uid)
        .collection("acceptedFriends")
        .orderBy("fullName")
        .getDocuments()
        .then((docs) {
      print("have data, started putting it in variables");
      setState(() {
        docs.documents.forEach((doc) {
          idToFriendMap[doc["fullName"]] = doc.documentID;
          friends[doc["fullName"]] = false;
        });

        print(idToClassMap);
        _haveFriends = true;
      });
    });
  }

  @override
  void dispose() {
    classInputController.dispose();
    super.dispose();
  }

  /// handles radio buttons in form
  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;
      print(_radioValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Running build"); // debug
    if (_haveData) {
      // the form itself
      return Scaffold(
          appBar: AppBar(
            title: new Text("Create Meeting"),
          ),
          body: Container(
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
                              hintText: 'Title',
                              contentPadding: EdgeInsets.only(left: 20),
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
                            controller: titleInputController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            onSaved: (value) => _meetingTitle = value,
                          ),
                          new Padding(padding: EdgeInsets.all(1.0)),
                          TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Description',
                                contentPadding: EdgeInsets.only(left: 20),
                                enabledBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100.0)),
                                  borderSide: const BorderSide(
                                      color: Color(0xffD3D3D3)),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100.0)),
                                  borderSide: const BorderSide(
                                      color: Color(0xffD3D3D3)),
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(100)),
                              ),
                              controller: descriptionInputController,
                              onSaved: (value) => _meetingDescrip = value),
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
                                contentPadding: EdgeInsets.only(left: 20),
                                enabledBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100.0)),
                                  borderSide: const BorderSide(
                                      color: Color(0xffD3D3D3)),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100.0)),
                                  borderSide: const BorderSide(
                                      color: Color(0xffD3D3D3)),
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(100)),
                                hasFloatingPlaceholder: false),
                            onChanged: (dt) => setState(() => date = dt),
                          ),
                          new Padding(padding: EdgeInsets.all(1.0)),
                          DateTimePickerFormField(
                            inputType: InputType.time,
                            initialTime: TimeOfDay.now(),
                            editable: false,
                            format: DateFormat("HH:mm"),
                            decoration: InputDecoration(
                              labelText: 'Time',
                              hasFloatingPlaceholder: false,
                              contentPadding: EdgeInsets.only(left: 20),
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
                            onChanged: (t) => setState(() => time = t),
                          ),
                          new Padding(padding: EdgeInsets.all(1.0)),
                          TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Location',
                                contentPadding: EdgeInsets.only(left: 20),
                                enabledBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100.0)),
                                  borderSide: const BorderSide(
                                      color: Color(0xffD3D3D3)),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100.0)),
                                  borderSide: const BorderSide(
                                      color: Color(0xffD3D3D3)),
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(100)),
                              ),
                              controller: locationInputController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              onSaved: (value) => _meetingLocation = value),
                          new Padding(padding: EdgeInsets.all(10.0)),
                          TextFormField(
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(left: 20),
                                hintText: 'Select Class',
                                enabledBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100.0)),
                                  borderSide: const BorderSide(
                                      color: Color(0xffD3D3D3)),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100.0)),
                                  borderSide: const BorderSide(
                                      color: Color(0xffD3D3D3)),
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(100)),
                              ),
                              controller: classInputController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              onSaved: (value) => _meetingClass = value),
                          new Container(
                              width: double.maxFinite,
                              child: new SizedBox(
                                height: 100.0,
                                child: new ListView.builder(
                                    itemCount: classNames.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return filter == null || filter == ""
                                          ? new Card(
                                              child:
                                                  new Text(classNames[index]))
                                          : classNames[index]
                                                  .toLowerCase()
                                                  .contains(
                                                      filter.toLowerCase())
                                              ? new Card(
                                                  child: new Text(
                                                      classNames[index]),
                                                )
                                              : new Container();
                                    }),
                              )),
                          new Padding(padding: EdgeInsets.all(10.0)),
                          new Text(
                            'Select Recipients',
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
                                'All Classmates',
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
                            // adds form values to database on successful validation
                            onPressed: () {
                              if (_addMeetingKey.currentState.validate()) {
                                _addMeetingKey.currentState.save();

                                DocumentReference meetingReference = Firestore
                                    .instance
                                    .collection('meetings')
                                    .document();

                                meetingReference.setData({
                                  // adds to database
                                  'title': titleInputController.text,
                                  'description':
                                      descriptionInputController.text,
                                  "date": date,
                                  "time": time,
                                  "location": locationInputController.text,
                                  "class": classInputController.text,
                                  "recipient": _radioValue
                                }).then((doc) {
                                  _meetingID = meetingReference.documentID;
                                  sendOutMeeting(
                                      _radioValue); // todo: for some reason this is null when you pass it
                                  //sendOutMeeting(0);

                                  // clears form fields on submit
                                  // todo: make sure date and time are cleared

                                  titleInputController.clear();
                                  descriptionInputController.clear();
                                  locationInputController.clear();
                                  classInputController.clear();

                                  if (_radioValue != 2) {
                                    _success(
                                        "Your meeting has successfully been sent.");
                                  }
                                  _radioValue = 0;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )));
    } else {
      return Center(
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation(Colors.blue),
        ),
      );
    }
  }

  void sendOutMeeting(radioNum) {
    if (radioNum == 0) {
      print("chose all classes");
      // send out to everyone in the class
      if (idToClassMap
          .containsKey(classInputController.text.toLowerCase().trim())) {
        print("has the key");
        Firestore.instance
            .collection("dataArray")
            .document(
                idToClassMap[classInputController.text.toLowerCase().trim()])
            .collection("students")
            .getDocuments()
            .then((docs) {
          docs.documents.forEach((doc) {
            if (doc["studentUID"] != widget.uid) {
              Firestore.instance
                  .collection("users")
                  .document(doc["studentUID"])
                  .collection('incomingMeetings')
                  .add({
                "meetingUID": _meetingID,
                'title': _meetingTitle,
                'description': _meetingDescrip,
                "date": date,
                "time": time,
                "location": _meetingLocation,
                "class": _meetingClass,
              }).catchError((err) => print(err));
            }
          });
        });
      } else {
        // todo: print error that you haven't selected a valid class
        print("doesn't have the key");
      }
    } else if (radioNum == 1) {
      // todo: send out to all friends (meeting was sent to your # friends)
      Firestore.instance
          .collection("users")
          .document(widget.uid)
          .collection("acceptedFriends")
          .getDocuments()
          .then((docs) {
        docs.documents.forEach((doc) {
          Firestore.instance
              .collection("users")
              .document(doc["uid"])
              .collection('incomingMeetings')
              .add({
            "meetingUID": _meetingID,
            'title': _meetingTitle,
            'description': _meetingDescrip,
            "date": date,
            "time": time,
            "location": _meetingLocation,
            "class": _meetingClass,
          }).catchError((err) => print(err));
        });
      });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
        title: Text("Select recipients"),
        content: Scaffold(
        appBar: AppBar(),
        body: Container(
          height: 100.0,
          width: 100.0,
          child: ListView(
            children: friends.keys.map((String key) {
              return new CheckboxListTile(
                title: new Text(key),
                value: friends[key],
                onChanged: (bool value) {
                  setState(() {
                    friends[key] = value;
                  });
                },
              );
            }).toList(),
          ),
        )),
        actions: [
          FlatButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.of(context).pop(); // dismiss dialog
            },
          ),
        ],
        );
        },
      );
    }

    // send to yourself
    Firestore.instance
        .collection("users")
        .document(widget.uid)
        .collection('meetings')
        .add({
      "meetingUID": _meetingID,
      'title': _meetingTitle,
      'description': _meetingDescrip,
      "date": date,
      "time": time,
      "location": _meetingLocation,
      "class": _meetingClass,
    }).catchError((err) => print(err));
  }

  /// shows success message on submission of form
  void _success(String message) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop(); // dismiss dialog
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Success"),
      content: Text(message),
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
  }
}
