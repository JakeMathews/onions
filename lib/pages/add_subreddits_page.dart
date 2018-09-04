import 'package:flutter/material.dart';

class AddSubredditsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextEditingController groupNameTextEditingController = new TextEditingController();

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Add Subreddit Group"),
      ),
      body: new Padding(
        padding: const EdgeInsets.all(8.0),
        child: new Form(
          child: new Column(
            children: <Widget>[
              new TextFormField(
                controller: groupNameTextEditingController,
                decoration: new InputDecoration(labelText: 'Subreddit Group Name'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'The name of the subreddit group is required';
                  }
                  // TODO: Verify that the subreddit group doesn't already exist
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
