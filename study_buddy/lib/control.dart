import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './home.dart';

class ControlPage extends StatefulWidget
{
  ControlPage({Key key, this.title, this.uid}) : super(key: key);

  final String title;
  final String uid;

  @override
  State<StatefulWidget> createState() => new ControlPageState();
}

class ControlPageState extends State
{
  int _selectedPage = 0;
  // the array of pages
  final _pageOptions = [
    // the array of pages
    HomePage(),
    // next few lines are just placeholders for now
    MessagePage(),
    Text(
      "Item 3",
      style: TextStyle(fontSize: 36),
    ),
    Text(
      "Item 4",
      style: TextStyle(fontSize: 36),
    ),
    Text(
      "Item 5",
      style: TextStyle(fontSize: 36),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Study Buddy"),
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
              icon: Icon(Icons.add_box),
              title: Text("Add")
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.school),
              title: Text("Feed")
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