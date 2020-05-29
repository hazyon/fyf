import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './meetingCustomCard.dart';

class HomeAll extends StatefulWidget {
  HomeAll({Key key, this.uid}) : super(key: key);

  final String uid;

  @override
  _HomeAllState createState() => _HomeAllState();
}

class _HomeAllState extends State<HomeAll> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Meetings"),
      ),
      body: Column(children: <Widget>[
        Expanded(
          child: SizedBox(
              child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection('meetings')
                    .orderBy("date")
                    .snapshots(),
                builder:
                    (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError)
                    return new Text('Error: ${snapshot.error}');
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
                            uid: document.documentID,
                            userUID: widget.uid,
                          );
                        }).toList(),
                      );
                  }
                },
              )),
        ),
      ]),
    );
  }
}
