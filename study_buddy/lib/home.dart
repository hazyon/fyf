import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(25),
      child: Column(
        children: <Widget>[
        Text("Home", style: TextStyle(fontSize: 36),),
      FlatButton(
      child: Text('Add Hardcoded Task'),
      onPressed: () {
      Firestore.instance
          .collection('tasks')
          .add({
            "title": "new meeting",
            "description": "at a specific time"
          })
          .catchError((err) => print(err));
      })]
    ));
  }
}