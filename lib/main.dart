import 'package:flutter/material.dart';
import 'package:onions/pages/list_page.dart';
import 'package:onions/subreddit_group_manager.dart';

void main() {
  final subredditGroupManager = new SubredditGroupManager();

  return runApp(new MaterialApp(
    home: new ListPage(subredditGroupManager.getDefaultSubredditGroup()),
  ));
}
