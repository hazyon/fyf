// adapted from the following tutorial https://heartbeat.fritz.ai/firebase-user-authentication-in-flutter-1635fb175675

import 'package:flutter/material.dart';
import './friendRequest.dart';

class CustomCard extends StatelessWidget {
  CustomCard({@required this.email, this.name, this.date});

  final email;
  final name;
  final date;

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
                                  name: name, email: email, date: date)));
                    }),
              ],
            )));
  }
}