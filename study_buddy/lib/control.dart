import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './home.dart';

import './friends.dart';

class ControlPage extends StatefulWidget
{
  ControlPage({Key key, this.title, this.uid}) : super(key: key);

  final String title;
  final String uid;

  @override
  State<StatefulWidget> createState() => new ControlPageState();
}

class ControlPageState extends State<ControlPage>
{
  String date;

  // the array of pages
  List _pageOptions;

  @override
  void initState() {
    DateTime now = DateTime.now();
    date = now.year.toString() + "-" + now.month.toString() + "-" + now.day.toString();
    _pageOptions = [
      // the array of pages
      HomePage(),
      // next few lines are just placeholders for now
      MessagePage(),
      Text(
        "Item 3",
        style: TextStyle(fontSize: 36),
      ),
      Friends(uid: widget.uid, date: date),
      Text(
        "Item 5",
        style: TextStyle(fontSize: 36),
      ),
    ];
    super.initState();
  }

  int _selectedPage = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Study Buddy"),
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
          ]
      ),
      body: _pageOptions[_selectedPage], // displays correct page
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // so that the navbar doesn't move around and shows up in the correct colors
        currentIndex: _selectedPage,
        onTap: (int index) {
          setState(() {
            _selectedPage = index; // this is what actually keeps track of which page the user is on
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text("Home"),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.message),
              title: Text("Message")
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_call),
              title: Text("Meetings")
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.people_outline),
              title: Text("Friends")
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              title: Text("Profile")
          ),
        ],
      ),
    );
  }
}