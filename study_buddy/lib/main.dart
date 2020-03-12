import 'package:flutter/material.dart';

import './home.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new MyAppState();
}

class MyAppState extends State {
  int _selectedPage = 0;
  // the array of pages
  final _pageOptions = [
    // the array of pages
    HomePage(),
    // next few lines are just placeholders for now
    Text(
      "Item 2",
      style: TextStyle(fontSize: 36),
    ),
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
    return MaterialApp(
      title: "Study Buddy",
      home: Scaffold(
        appBar: AppBar(
          title: Text("Study Buddy"),
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
      ),
    );
  }
}
