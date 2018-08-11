import 'package:flutter/material.dart';
import 'package:onions/configuration.dart' as config;
import 'package:onions/drawer_subreddit.dart';
import 'package:onions/pages/list_page.dart';

class SubredditDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Widget> tiles = config.subreddits.map((final DrawerSubreddit drawerSubreddit) {
      return new ListTile(
        title: new Text(drawerSubreddit.title),
        onTap: () {
          Navigator.pushReplacement(context, new MaterialPageRoute(builder: (final BuildContext buildContext) {
            return new ListPage(drawerSubreddit);
          }));
        },
      );
    }).toList();

    return new Drawer(
      child: new ListView(
        children: tiles,
      ),
    );
  }
}
