import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(25),
      child: Text(
        "Home",
        style: TextStyle(fontSize: 36),
      ),
    );
  }
}
