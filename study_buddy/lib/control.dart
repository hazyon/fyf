import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:study_buddy/profileUpdate.dart';

import './home.dart';
import './friends.dart';
import './profileUpdate.dart';
import './meetings.dart';
import './classes.dart';

class ControlPage extends StatefulWidget {
  ControlPage({Key key, this.title, this.uid}) : super(key: key);

  final String title;
  final String uid;

  @override
  State<StatefulWidget> createState() => new ControlPageState();
}

class ControlPageState extends State<ControlPage> {
  String date;

  // the array of pages
  List _pageOptions;
  int _selectedPage;

  @override
  void initState() {
    DateTime now = DateTime.now();
    date = now.year.toString() +
        "-" +
        now.month.toString() +
        "-" +
        now.day.toString();
    _pageOptions = [
      // the array of pages
      HomeJoined(uid: widget.uid),
      Classes(uid: widget.uid),
      Meetings(uid: widget.uid, date: date),
      Friends(uid: widget.uid, date: date),
      ProfilePage(uid: widget.uid),
    ];
    _selectedPage = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title),
          // log out feature adapted from the following tutorial https://heartbeat.fritz.ai/firebase-user-authentication-in-flutter-1635fb175675
          actions: <Widget>[
            FlatButton(
              child: Text("Log Out"),
              textColor: Colors.white,
              onPressed: () {
                FirebaseAuth.instance
                    .signOut()
                    .then((result) =>
                        Navigator.pushReplacementNamed(context, "/login"))
                    .catchError((err) => print(err));
              },
            )
          ]),
      body: _pageOptions[_selectedPage], // displays correct page
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType
            .fixed, // so nav bar doesn't move around and shows up in the correct colors
        currentIndex: _selectedPage,
        onTap: (int index) {
          setState(() {
            _selectedPage = index; // keeps track of which page the user is on
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text("Home"),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), title: Text("Classes")),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_box), title: Text("Meetings")),
          BottomNavigationBarItem(
              icon: Icon(Icons.people), title: Text("Friends")),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), title: Text("Profile")),
        ],
      ),
    );
  }
}
