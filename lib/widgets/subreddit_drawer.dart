import 'package:flutter/material.dart';
import 'package:onions/pages/add_subreddits_page.dart';
import 'package:onions/pages/list_page.dart';
import 'package:onions/subreddit_group.dart';
import 'package:onions/subreddit_group_manager.dart';

class SubredditDrawer extends StatelessWidget {
  final SubredditGroupManager subredditGroupManager;

  const SubredditDrawer(this.subredditGroupManager);

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
          return new AddSubredditsPage(subredditGroupManager);
        })).then((final dynamic subreddit) {
          if (subreddit == null || !(subreddit is SubredditGroup)) {
            return;
          }

          final SubredditGroup subredditGroup = subreddit as SubredditGroup;
          subredditGroupManager.add(subredditGroup);
        });
      },
    ));

    // List of subreddit groups
    drawerWidgets.add(new Divider());
    drawerWidgets.add(new Flexible(
      child: new ListView(
        children: subredditGroupManager.getSubredditGroups().map((final SubredditGroup drawerSubreddit) {
          return new ListTile(
            title: new Text(drawerSubreddit.name),
            onTap: () {
              Navigator.push(context, new MaterialPageRoute(builder: (final BuildContext buildContext) {
                return new ListPage(subredditGroupManager, drawerSubreddit);
              }));
            },
            trailing: new IconButton(
                icon: new Icon(Icons.close),
                // TODO: Show a confirmation dialog first or swipe to reveal delete button
                onPressed: () {
                  subredditGroupManager.removeByName(drawerSubreddit.name);
                  // TODO: Only load default when subreddit group being removed is the rendered one
                  Navigator.pushReplacement(context, new MaterialPageRoute(builder: (final BuildContext buildContext) {
                    return new ListPage(subredditGroupManager, subredditGroupManager.getDefaultSubredditGroup());
                  }));
                }),
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
