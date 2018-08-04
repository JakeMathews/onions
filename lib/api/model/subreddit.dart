import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:onions/model/post.dart';

class Subreddit {
  final String name;

  final List<Post> allPosts = [];
  final List<Post> latestPosts = [];

  Post lastPost;

  Subreddit({@required this.name});

  void addFromHttpResponse(final Response response) {
    final Map<String, dynamic> jsonResponse = json.decode(response.body) as Map<String, dynamic>;
    latestPosts.clear();
    for (var postMap in jsonResponse['data']['children']) {
      final Post post = Post.fromMap(postMap);
      latestPosts.add(post);
    }
    allPosts.addAll(latestPosts);

    if (allPosts.isNotEmpty) {
      lastPost = allPosts.last;
    }
  }

  static Subreddit fromHttpResponse(final String subredditName, final Response response) {
    final Subreddit subreddit = new Subreddit(name: subredditName);
    subreddit.addFromHttpResponse(response);

    return subreddit;
  }
}
