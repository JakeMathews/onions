import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:onions/model/headline.dart';
import 'package:onions/widgets/headline_view.dart';

class ListPage extends StatefulWidget {
  final List<String> subreddits;

  ListPage(this.subreddits);
  @override
  State<StatefulWidget> createState() {
    return new ListPageState(subreddits);
  }
}

class ListPageState extends State<ListPage> {
  final List<String> subreddits;

  List<Headline> headlines = [];

  ListPageState(this.subreddits);

  @override
  void initState() {
    super.initState();

    final List<Future<http.Response>> subredditFutures = subreddits.map((final String subreddit) {
      return getContent(subreddit);
    }).toList();

    Future.wait(subredditFutures).then((final List<http.Response> responses) {
      setState(() {
        for (final http.Response response in responses) {
          final Map<String, dynamic> jsonResponse = json.decode(response.body) as Map<String, dynamic>;
          //print(jsonResponse);
          for (var post in jsonResponse['data']['children']) {
            //print(post);
            headlines.add(new Headline(source: 'r/${post['data']['subreddit']}', text: post['data']['title']));
          }
        }

        headlines.shuffle(new Random());
      });
    });
  }

  Future<http.Response> getContent(final String subreddit) {
    return http.get("https://reddit.com/r/$subreddit/hot.json?limit=100");
  }

  @override
  Widget build(BuildContext context) {
    final List<HeadlineView> headLineViews = [];
    for (final Headline headline in headlines) {
      headLineViews.add(new HeadlineView(
        headline: headline,
      ));
    }

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Onions'),
      ),
      body: new ListView(
        children: headLineViews,
      ),
    );
  }
}
