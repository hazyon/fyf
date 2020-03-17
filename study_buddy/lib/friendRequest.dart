import 'package:flutter/material.dart';

class FriendRequestDescription extends StatelessWidget {
  FriendRequestDescription({@required this.name, this.email, this.date});

  final name;
  final email;
  final date;

  @override
  Widget build(BuildContext context) {
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
                RaisedButton(
                    child: Text('Back To HomeScreen'),
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    onPressed: () => Navigator.pop(context)),
              ]),
        ));
  }
}