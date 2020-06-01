import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './meetingCustomCard.dart';
import './addClass.dart';
import './classCustomCard.dart';

class Classes extends StatefulWidget {
  Classes({Key key, this.uid}) : super(key: key);
  final String uid;

  @override
  _ClassesState createState() => _ClassesState();
}

class _ClassesState extends State<Classes> {
  TextEditingController taskTitleInputController;

  @override
  initState() {
    taskTitleInputController = new TextEditingController();
    Firestore.instance
        .collection("users")
        .document(widget.uid)
        .collection("classes")
        .document()
        .get()
        .then((DocumentSnapshot result) {})
        .catchError((err) => print(err));
    super.initState();
  }

  Future navigateToSubPage(context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddClassPage(uid: widget.uid)));
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Expanded(
        child: SizedBox(
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection('users')
                  .document(widget.uid)
                  .collection('classes')
                  .orderBy("period")
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
                        return new ClassCustomCard(
                          name: document['name'],
                          period: document["period"],
                          uid: document.documentID,
                          userUID: widget.uid,
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
