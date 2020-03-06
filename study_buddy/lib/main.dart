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
  final _pageOptions = [  // the array of pages
    HomePage(),
    // next two lines are just placeholders for now
    Text("Item 2", style: TextStyle(fontSize: 36),),
    Text("Item 3", style: TextStyle(fontSize: 36),),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Study Buddy",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Bottom Nav Bar"),
        ),
        body: _pageOptions[_selectedPage], // displays correct page
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedPage,
          onTap: (int index) {
            setState(() {
              _selectedPage = index; // this is what actually keeps track of which page the user is on
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text("Home")
            ),
            // for now I just put in work and landscape icons,
            // but those will be changed later once we know what pages we are including
            BottomNavigationBarItem(
                icon: Icon(Icons.work),
                title: Text("Work")
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.landscape),
                title: Text("Landscape")
            ),
          ],
        ),
      ),
    );
  }
}

