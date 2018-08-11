import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:onions/api/reddit_api.dart';

class Post {
  final String text;
  final String source;
  final String name;
  final String subredditName;
  final Uri permalink;
  final String url;

  Post({
    @required this.text,
    @required this.source,
    @required this.name,
    @required this.subredditName,
    @required this.permalink,
    @required this.url,
  });

  static Post fromMap(final Map<String, dynamic> postMap) {
    return new Post(
      subredditName: postMap['data']['subreddit'],
      source: postMap['data']['subreddit_name_prefixed'],
      text: postMap['data']['title'],
      permalink: RedditApi.baseUri.replace(path: postMap['data']['permalink']),
      url: postMap['data']['url'],
      name: postMap['data']['name'],
    );
  }

  static List<Post> fromHttpResponse(final Response response) {
    final Map<String, dynamic> jsonResponse = json.decode(response.body) as Map<String, dynamic>;
    final List<Post> posts = [];
    for (var postMap in jsonResponse['data']['children']) {
      final Post post = Post.fromMap(postMap);
      posts.add(post);
    }

    return posts;
  }
}
