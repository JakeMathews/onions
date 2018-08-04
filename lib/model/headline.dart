import 'package:flutter/material.dart';
import 'package:onions/api/reddit_api.dart';

class Headline {
  final String text;
  final String source;
  final String name;
  final String subredditName;
  final Uri uri;

  Headline({
    @required this.text,
    @required this.source,
    @required this.uri,
    @required this.name,
    @required this.subredditName,
  });

  static Headline fromMap(final Map<String, dynamic> postMap) {
    return new Headline(
      subredditName: postMap['data']['subreddit'],
      source: postMap['data']['subreddit_name_prefixed'],
      text: postMap['data']['title'],
      uri: RedditApi.baseUri.replace(path: postMap['data']['permalink']),
      name: postMap['data']['name'],
    );
  }
}
