import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
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
  final Map<String, String> subredditNameMap = {};
  final List<Headline> headlines = [];
  final List<String> subreddits;

  ListPageState(this.subreddits);

  @override
  void initState() {
    super.initState();

    _load();
  }

  Future<http.Response> getContent(final String subreddit, {final String last}) {
    final Map<String, String> params = {
      'limit': '20',
    };

    if (last != null) {
      params['after'] = last;
    }

    final Uri uri = new Uri(scheme: 'https', host: 'reddit.com', path: 'r/$subreddit/hot.json', queryParameters: params);
    return http.get(uri);
  }

  void _load() {
    print('Loading more data');

    final List<Future<http.Response>> subredditFutures = subreddits.map((final String subreddit) {
      return getContent(subreddit, last: subredditNameMap[subreddit]);
    }).toList();

    Future.wait(subredditFutures).then((final List<http.Response> responses) {
      setState(() {
        final List<Headline> preshuffleHeadlines = [];
        for (final http.Response response in responses) {
          final Map<String, dynamic> jsonResponse = json.decode(response.body) as Map<String, dynamic>;
          //print(jsonResponse);
          for (var post in jsonResponse['data']['children']) {
            final Headline headline = new Headline(
              subredditName: post['data']['subreddit'].toString().toLowerCase(),
              source: 'r/${post['data']['subreddit']}',
              text: post['data']['title'],
              url: 'https://www.reddit.com${post['data']['permalink']}',
              name: post['data']['name'],
            );

            // TODO: Don't do this every time...
            subredditNameMap[headline.subredditName] = headline.name;

            preshuffleHeadlines.add(headline);
          }
        }

        preshuffleHeadlines.shuffle(new Random());
        headlines.addAll(preshuffleHeadlines);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget body;

    if (headlines.length > 0) {
      body = new LazyLoadScrollView(
        child: ListView.builder(
          itemCount: headlines.length,
          itemBuilder: (context, position) {
            return new HeadlineView(
              headline: headlines[position],
            );
          },
        ),
        onEndOfPage: _load,
        scrollOffset: 300,
      );
    } else {
      body = new Center(
        child: new CircularProgressIndicator(),
      );
    }

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Onions'),
      ),
      body: body,
    );
  }
}
