import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:onions/model/headline.dart';

class Subreddit {
  final String name;

  final List<Headline> allHeadlines = [];
  final List<Headline> latestHeadlines = [];

  Headline lastHeadline;

  Subreddit({@required this.name});

  void addFromHttpResponse(final Response response) {
    final Map<String, dynamic> jsonResponse = json.decode(response.body) as Map<String, dynamic>;
    latestHeadlines.clear();
    for (var post in jsonResponse['data']['children']) {
      final Headline headline = Headline.fromMap(post);
      latestHeadlines.add(headline);
    }
    allHeadlines.addAll(latestHeadlines);

    if (allHeadlines.isNotEmpty) {
      lastHeadline = allHeadlines.last;
    }
  }

  static Subreddit fromHttpResponse(final String subredditName, final Response response) {
    final Subreddit subreddit = new Subreddit(name: subredditName);
    subreddit.addFromHttpResponse(response);

    return subreddit;
  }
}
