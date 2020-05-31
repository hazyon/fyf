// adapted from the following tutorial https://heartbeat.fritz.ai/firebase-user-authentication-in-flutter-1635fb175675

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'dart:collection';

class AddClassPage extends StatefulWidget {
  AddClassPage({Key key, this.uid}) : super(key: key);

  final String uid;

  @override
  _AddClassPageState createState() => new _AddClassPageState();
}

class _AddClassPageState extends State<AddClassPage> {
  final GlobalKey<FormState> _addClassKey = GlobalKey<FormState>();

  TextEditingController titleInputController;
  TextEditingController descriptionInputController;
  TextEditingController locationInputController;
  TextEditingController classInputController;


  String filter;
  Map idToClassMap = new HashMap<String, String>();
  List<String> classNames = new List<String>();
  bool _haveData = false;
  String _class;
  int _radioValue = 1;

  @override
  initState() {
    print("Running initState"); // for debug

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

    getClassData();
    super.initState();
  }

  void getClassData() {
    Firestore.instance
        .collection("dataArray")
        .orderBy("Department")
        .getDocuments()
        .then((docs) {
      setState(() {
        docs.documents.forEach((doc) {
          String name =
              doc["Name"].toLowerCase() + " (" + doc["Teacher"] + ")";
          idToClassMap[doc["Name"].toLowerCase()] = doc.documentID;
          classNames.add(name);
        });
        _haveData = true;
      });
    });
  }

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;
      print(_radioValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Running build");
    if (_haveData) {
      return Scaffold(
          appBar: AppBar(
            title: new Text("Add Class"),
          ),
          body: Container(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                  child: Column(
                      children: <Widget>[
                        new Padding(padding: EdgeInsets.only(top: 10.0)),
                        Form(
                          key: _addClassKey,
                          child: Column(
                              children: <Widget>[
                                TextFormField(
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(left: 20),
                                      hintText: 'Select Class',
                                      enabledBorder: const OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.all(
                                            Radius.circular(100.0)),
                                        borderSide: const BorderSide(
                                            color: Color(0xffD3D3D3)),
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.all(
                                            Radius.circular(100.0)),
                                        borderSide: const BorderSide(
                                            color: Color(0xffD3D3D3)),
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              100)),
                                    ),
                                    controller: classInputController,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Please enter some text';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) => _class = value),
                                new Container(
                                    width: double.maxFinite,
                                    child: new SizedBox(
                                      height: 100.0,
                                      child: new ListView.builder(
                                          itemCount: classNames.length,
                                          itemBuilder:
                                              (BuildContext context,
                                              int index) {
                                                return filter == null ||
                                                filter == ""
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
                                                }
                                      ),
                                    )
                                ),
                                new Padding(padding: EdgeInsets.all(10.0)),
                                new Text(
                                  'Select Period',
                                  style: new TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                ),
                                new Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    new Radio(
                                      value: 1,
                                      groupValue: _radioValue,
                                      onChanged: _handleRadioValueChange,
                                    ),
                                    new Text(
                                      '1',
                                      style: new TextStyle(fontSize: 14.0),
                                    ),
                                    new Radio(
                                      value: 2,
                                      groupValue: _radioValue,
                                      onChanged: _handleRadioValueChange,
                                    ),
                                    new Text(
                                      '2',
                                      style: new TextStyle(fontSize: 14.0),
                                    ),
                                    new Radio(
                                      value: 3,
                                      groupValue: _radioValue,
                                      onChanged: _handleRadioValueChange,
                                    ),
                                    new Text(
                                      '3',
                                      style: new TextStyle(fontSize: 14.0),
                                    ),
                                    new Radio(
                                      value: 4,
                                      groupValue: _radioValue,
                                      onChanged: _handleRadioValueChange,
                                    ),
                                    new Text(
                                      '4',
                                      style: new TextStyle(fontSize: 14.0),
                                    ),
                                  ],
                                ),
                                new Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    new Radio(
                                      value: 5,
                                      groupValue: _radioValue,
                                      onChanged: _handleRadioValueChange,
                                    ),
                                    new Text(
                                      '5',
                                      style: new TextStyle(fontSize: 14.0),
                                    ),
                                    new Radio(
                                      value: 6,
                                      groupValue: _radioValue,
                                      onChanged: _handleRadioValueChange,
                                    ),
                                    new Text(
                                      '6',
                                      style: new TextStyle(fontSize: 14.0),
                                    ),
                                    new Radio(
                                      value: 7,
                                      groupValue: _radioValue,
                                      onChanged: _handleRadioValueChange,
                                    ),
                                    new Text(
                                      '7',
                                      style: new TextStyle(fontSize: 14.0),
                                    ),
                                    new Radio(
                                      value: 8,
                                      groupValue: _radioValue,
                                      onChanged: _handleRadioValueChange,
                                    ),
                                    new Text(
                                      '8',
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
                                    _addClassKey.currentState.save();

                                    Firestore.instance
                                        .collection("users")
                                        .document(widget.uid)
                                        .collection('classes')
                                        .add({
                                      "name": _class,
                                      "period": _radioValue,
                                    }).catchError((err) => print(err))
                                    .then((doc) {
                                      classInputController.clear();
                                      _radioValue = 1;
                                      _success(
                                          "Your class has been added.");
                                    });
                                  },
                                ),
                            ],
                        ),
                    ),
                  ],
                )
            )
          )
        );
    } else {
      return Center(
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation(Colors.blue),
        ),
      );
    }
  }

  // shows success message on submission of form; adapted from https://fluttercentral.com/Articles/Post/19/Creating_a_Form_in_Flutter
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
