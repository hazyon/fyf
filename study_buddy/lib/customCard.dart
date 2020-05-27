// adapted from the following tutorial https://heartbeat.fritz.ai/firebase-user-authentication-in-flutter-1635fb175675

import 'package:flutter/material.dart';
import './friendRequest.dart';

class CustomCard extends StatelessWidget {
  CustomCard(
      {@required this.email,
      this.name,
      this.date,
      this.status,
      this.uid,
      this.docId,
      this.userEmail,
      this.userFullName,
      this.userUID});

  // information on the card about the person who sent the request
  final email;
  final name;
  final date;
  final status;
  final uid;
  final docId;

  // information about the current user
  final userEmail;
  final userFullName;
  final userUID;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Container(
            padding: const EdgeInsets.only(top: 5.0),
            child: Column(
              children: <Widget>[
                Text(name),
                FlatButton(
                    child: Text("See More"),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FriendRequestDescription(
                                    name: name,
                                    email: email,
                                    date: date,
                                    status: status,
                                    uid: uid,
                                    docId: docId,
                                    userUID: userUID,
                                    userFullName: userFullName,
                                    userEmail: userEmail,
                                  )));
                    }),
              ],
            )));
  }
}
