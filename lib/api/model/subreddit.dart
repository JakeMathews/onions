import 'package:flutter/material.dart';
import 'package:onions/api/model/post.dart';

class Subreddit {
  final String name;

  final List<Post> latestPosts = [];

  Subreddit({@required this.name});

  Post getLastPost() {
    if (latestPosts.isNotEmpty) {
      return latestPosts.last;
    }

    return null;
  }
}
