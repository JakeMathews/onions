import 'package:flutter/material.dart';
import 'package:onions/pages/add_subreddits_page.dart';
import 'package:onions/pages/list_page.dart';
import 'package:onions/subreddit_group.dart';

class SubredditDrawer extends StatelessWidget {
  final List<SubredditGroup> subredditGroups;

  SubredditDrawer(final List<SubredditGroup> subredditGroups) : this.subredditGroups = (subredditGroups != null ? subredditGroups : []);

  @override
  Widget build(BuildContext context) {
    final List<Widget> drawerWidgets = [];

    // Header
    drawerWidgets.add(
      new DrawerHeader(
        child: new Center(
          child: new Text(
            'Subreddits Groups',
            style: new TextStyle(fontSize: 25.0),
          ),
        ),
      ),
    );

    // Add subreddit group tile
    drawerWidgets.add(new ListTile(
      title: new Text('Add Subreddit Group'),
      trailing: new Icon(Icons.add),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(context, new MaterialPageRoute(builder: (final BuildContext buildContext) {
          return new AddSubredditsPage();
        }));
      },
    ));

    // List of subreddit groups
    drawerWidgets.add(new Divider());
    drawerWidgets.add(new Flexible(
      child: new ListView(
        children: subredditGroups.map((final SubredditGroup drawerSubreddit) {
          return new ListTile(
            title: new Text(drawerSubreddit.name),
            onTap: () {
              Navigator.pushReplacement(context, new MaterialPageRoute(builder: (final BuildContext buildContext) {
                return new ListPage(drawerSubreddit);
              }));
            },
          );
        }).toList(),
      ),
    ));

    return new Drawer(
      child: new Column(
        children: drawerWidgets,
      ),
    );
  }
}
