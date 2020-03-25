import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './customCard.dart';

// followed this tutorial for some of the structural details: https://codingwithjoe.com/building-forms-with-flutter/

class MeetingPage extends StatefulWidget {
  MeetingPage({Key key}) : super(key: key);

  @override
  _MeetingPageState createState() => new _MeetingPageState();
}

class _MeetingPageState extends State<MeetingPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
          top: false,
          bottom: false,
          child: new Form(
              key: _formKey,
              autovalidate: true,
              child: new ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: <Widget>[
                  new TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Enter your first and last name',
                      labelText: 'Name',
                    ),
                  ),
                  new TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Enter your date of birth',
                      labelText: 'Dob',
                    ),
                  ),
                  new TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Enter a phone number',
                      labelText: 'Phone',
                    ),
                  ),
                  new TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Enter a email address',
                      labelText: 'Email',
                    ),
                  ),
                  new Container(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: new RaisedButton(
                        child: const Text('Submit'),
                        onPressed: null,
                      )),
                  new Column(
                    children: <Widget>[
                      Text("Ignore everything on this page for now!"),
                    ],
                  )
                ],
              ))),
    );
  }
}