// set up for a group of check boxes is based on the following tutorial https://flutter-examples.com/get-multiple-checkbox-checked-value-in-flutter/

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './control.dart';

class SelectFrees extends StatefulWidget {
  SelectFrees({Key key, this.uid}) : super(key: key);

  final String uid;

  @override
  _SelectFreesState createState() => _SelectFreesState();
}

class _SelectFreesState extends State<SelectFrees> {
  List<String> days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
  List<String> periods = [
    '1st',
    '2nd',
    '3rd',
    '4th',
    '5th',
    '6th',
    '7th',
    '8th'
  ];

  Map<String, bool> possibleFrees = {};
  var tmpArray = [];

  @override
  void initState() {
    for (String day in days)
      {
        for (String period in periods)
          {
            possibleFrees[day + " " + period] = false;
          }
      }
    super.initState();
  }

  getCheckboxItems() {
    possibleFrees.forEach((key, value) {
      if (value == true) {
        tmpArray.add(key);
      }
    });

    // for debugging purposes
    print(tmpArray);

    tmpArray.forEach((free) {
      Firestore.instance
          .collection("users")
          .document(widget.uid)
          .collection('frees')
          .add({
        "period": free
      }).catchError((err) => print(err));
    });

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ControlPage(
                  uid: widget.uid,
                  title: "Study Buddy"
                )),
            (_) => false);

    tmpArray.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Frees"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
          Expanded(
        child:
            ListView(
              children: possibleFrees.keys.map((String key) {
                return new CheckboxListTile(
                    title: new Text(key),
                    value: possibleFrees[key],
                    onChanged: (bool value) {
                      setState(() {
                        possibleFrees[key] = value;
                      });
                    });
              }).toList(),
            )),
            RaisedButton(
              child: Text("Complete Registration"),
              onPressed: getCheckboxItems,
            ),
          ],
        ),
      ),
    );
  }
}
