import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './meetingCustomCard.dart';
import './createMeeting.dart';

class Meetings extends StatefulWidget {
  Meetings({Key key, this.uid, this.date}) : super(key: key);

  final String uid;

  final String date;

  @override
  _MeetingsState createState() => _MeetingsState();
}

class _MeetingsState extends State<Meetings> {
  TextEditingController taskTitleInputController;

  @override
  initState() {
    taskTitleInputController = new TextEditingController();
    Firestore.instance
        .collection("meetings")
        .document(widget.uid)
        .get()
        .then((DocumentSnapshot result) {})
        .catchError((err) => print(err));
    super.initState();
  }

  Future navigateToSubPage(context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => CreateMeetingPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Expanded(
        child: SizedBox(
            child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('meetings')
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
                  children:
                      snapshot.data.documents.map((DocumentSnapshot document) {
                    return new MeetingCustomCard(
                      course: document['class'],
                      date: document['date'],
                      description: document['description'],
                      location: document['location'],
                      time: document['time'],
                      title: document["title"],
                    );
                  }).toList(),
                );
            }
          },
        )),
      ),
      RaisedButton(
        onPressed: () {
          navigateToSubPage(context);
        },
        child: Icon(Icons.add),
      )
    ]);
  }
}
