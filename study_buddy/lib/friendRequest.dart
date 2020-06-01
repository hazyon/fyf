// adapted from the following tutorial https://heartbeat.fritz.ai/firebase-user-authentication-in-flutter-1635fb175675

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FriendRequestDescription extends StatelessWidget {
  FriendRequestDescription(
      {@required this.name,
      this.email,
      this.date,
      this.status,
      this.uid,
      this.docId,
      this.userEmail,
      this.userFullName,
      this.userUID});

  final name;
  final email;
  final date;
  final status;
  final uid;
  final docId;

  final userEmail;
  final userFullName;
  final userUID;

  /// deletes the pending request from the person that sent the friend request
  void deleteRequest() {
    Firestore.instance
        .collection("users")
        .document(userUID)
        .collection("friends")
        .document(docId)
        .delete();

    Firestore.instance
        .collection("users")
        .document(uid)
        .collection("friends")
        .where("email", isEqualTo: userEmail)
        .getDocuments()
        .then((QuerySnapshot docs) {
      if (docs.documents.isNotEmpty) {
        // emails are unique, so there should only be one
        DocumentSnapshot toDelete = docs.documents[0];

        Firestore.instance
            .collection("users")
            .document(uid)
            .collection("friends")
            .document(toDelete.documentID)
            .delete();
      }
    }).catchError((err) => print(err));
  }

  @override
  Widget build(BuildContext context) {
    if (status == "incoming") {
      return Scaffold(
          appBar: AppBar(
            title: Text(name),
          ),
          body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(email),
                  Text("Date sent: " + date),
                  Text("Status: " + status),
                  RaisedButton(
                    child: Text("Accept"),
                    color: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0))),
                    textColor: Colors.white,
                    onPressed: () {
                      deleteRequest();
                      Firestore.instance
                          .collection("users")
                          .document(userUID)
                          .collection('acceptedFriends')
                          .add({
                        "uid": uid,
                        "fullName": name,
                        "email": email,
                      }).catchError((err) => print(err));

                      Firestore.instance
                          .collection("users")
                          .document(uid)
                          .collection('acceptedFriends')
                          .add({
                        "uid": userUID,
                        "fullName": userFullName,
                        "email": userEmail,
                      }).catchError((err) => print(err));
                      Navigator.pop(context);
                    },
                  ),
                  RaisedButton(
                    child: Text("Decline"),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0))),
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    onPressed: () {
                      deleteRequest();
                      Navigator.pop(context);
                    },
                  ),
                  RaisedButton(
                      child: Text('Back To Home'),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(16.0))),
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      onPressed: () => Navigator.pop(context)),
                ]),
          ));
    } else // status == "pending"
    {
      return Scaffold(
          appBar: AppBar(
            title: Text(name),
          ),
          body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(email),
                  Text("Date sent: " + date),
                  Text("Status: " + status),
                  new Padding(padding: EdgeInsets.only(top: 10.0)),
                  RaisedButton(
                      child: Text('Back'),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(16.0))),
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      onPressed: () => Navigator.pop(context)),
                ]),
          ));
    }
  }
}
