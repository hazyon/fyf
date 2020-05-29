import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './meetingCustomCard.dart';
import './createMeeting.dart';
import './homeAll.dart';

class HomeJoined extends StatefulWidget {
  HomeJoined({Key key, this.uid}) : super(key: key);

  final String uid;

  @override
  _HomeJoinedState createState() => _HomeJoinedState();
}

class _HomeJoinedState extends State<HomeJoined> {
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      FlatButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HomeAll(uid: widget.uid)));
        },
        child: Text("See All Meetings"),
      ),
      Expanded(
        child: SizedBox(
            child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('users').document(widget.uid).collection("meetings")
              .orderBy("date")
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return new Text('Loading...');
              default:
                return new ListView(
                  children: snapshot.data.documents
                      .map((DocumentSnapshot document) {
                    return new MeetingCustomCard(
                      course: document['class'],
                      date: document['date'],
                      description: document['description'],
                      location: document['location'],
                      time: document['time'],
                      title: document["title"],
                      uid: document["meetingUID"],
                      userUID: widget.uid,
                    );
                  }).toList(),
                );
            }
          },
        )),
      ),
    ]);
  }
}