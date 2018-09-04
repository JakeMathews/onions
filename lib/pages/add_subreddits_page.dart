import 'dart:async';

import 'package:flutter/material.dart';
import 'package:onions/subreddit_group.dart';
import 'package:onions/subreddit_group_manager.dart';

class AddSubredditsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new AddSubredditsPageState();
  }
}

class AddSubredditsPageState extends State<AddSubredditsPage> {
  final TextEditingController groupNameTextEditingController = new TextEditingController();
  final Set<String> subreddits = new Set();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Add Subreddit Group"),
        actions: <Widget>[
          new IconButton(
              icon: new Icon(
                Icons.check,
                color: Theme.of(context).buttonColor,
              ),
              onPressed: () {
                final bool validated = _formKey.currentState.validate();
                if (validated && subreddits.length < 2) {
                  _showValidationDialogBox(context);
                } else if (validated) {
                  Navigator.pop(context, new SubredditGroup(groupNameTextEditingController.text.trim(), subreddits: subreddits.toList()));
                }
              })
        ],
      ),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add),
        onPressed: () {
          _showSubredditDialogBox(context);
        },
      ),
      body: new Padding(
        padding: const EdgeInsets.all(8.0),
        child: new Form(
          key: _formKey,
          child: new Column(
            children: <Widget>[
              new TextFormField(
                controller: groupNameTextEditingController,
                decoration: new InputDecoration(labelText: 'Subreddit Group Name'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'The name of the subreddit group is required';
                  }

                  if (subredditGroupManager.exists(value)) {
                    return 'A subreddit group with that name already exists';
                  }
                },
              ),
              new Flexible(
                child: new Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new ListView(
                    children: subreddits.map((final String subreddit) {
                      return new Card(
                        child: new ListTile(
                          title: new Text(subreddit),
                          onLongPress: () {
                            _removeSubreddit(subreddit);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Null> _showValidationDialogBox(final BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (final BuildContext buildContext) {
        return new AlertDialog(
          title: new Text('You must have at least 2 subreddits to make a group'),
          actions: <Widget>[
            new FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: new Text('Okay'),
            )
          ],
        );
      },
    );
  }

  Future<Null> _showSubredditDialogBox(final BuildContext context) async {
    final TextEditingController textEditingController = new TextEditingController();
    return showDialog<Null>(
      context: context,
      barrierDismissible: true,
      builder: (final BuildContext context) {
        return new AlertDialog(
          title: new Text('Add subreddit to group'),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Text('Type in name of subbredit'),
                new TextField(
                  controller: textEditingController,
                  autofocus: true,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text('Add'),
              onPressed: () {
                _addSubreddit(textEditingController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _removeSubreddit(final String subreddit) {
    final String cleanSubreddit = cleanSubredditName(subreddit);

    if (cleanSubreddit == null || cleanSubreddit.isEmpty) {
      return;
    }

    setState(() {
      subreddits.remove(cleanSubreddit);
    });
  }

  void _addSubreddit(final String subreddit) {
    final String cleanSubreddit = cleanSubredditName(subreddit);

    if (cleanSubreddit == null || cleanSubreddit.isEmpty) {
      return;
    }

    setState(() {
      subreddits.add(cleanSubreddit);
    });
  }

  String cleanSubredditName(final String subreddit) {
    return subreddit?.trim()?.toLowerCase();
  }
}
