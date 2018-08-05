import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Settings'),
      ),
      body: new Padding(
        padding: const EdgeInsets.all(8.0),
        child: new ListView(
          children: <Widget>[],
        ),
      ),
    );
  }
}
