// adapted from the following tutorial https://heartbeat.fritz.ai/firebase-user-authentication-in-flutter-1635fb175675

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ClassCustomCard extends StatelessWidget {
  ClassCustomCard(
      {@required this.name,
        this.period,
        this.uid,
        this.userUID});

  // information on the card about the meeting
  final name;
  final period;
  final uid;
  final userUID;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Container(
            padding: const EdgeInsets.only(top: 5.0, bottom: 10.0),
            child: Column(
              children: <Widget>[
                Text(name),
                Text("Period " + period.toString()),
              ]
            ),
        ),
    );
  }
}
