import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:onions/api/model/post.dart';
import 'package:onions/api/model/subreddit.dart';
import 'package:onions/api/reddit_api.dart';
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
  final RedditApi redditApi = new RedditApi();

  final List<Post> posts = [];
  final List<Subreddit> subreddits = [];

  bool loading = false;

  ListPageState(final List<String> subredditNames) {
    subredditNames.forEach((final String subredditName) {
      subreddits.add(new Subreddit(name: subredditName));
    });
  }

  @override
  void initState() {
    super.initState();

    _load();
  }

  void _load() {
    print('Loading more data');

    setState(() {
      loading = true;
    });

    Future.wait(redditApi.requestAllUpdatedSubreddits(subreddits)).then((final List<Subreddit> subreddits) {
      setState(() {
        final List<Post> newPosts = [];
        for (final Subreddit subreddit in subreddits) {
          newPosts.addAll(subreddit.latestPosts);
        }

        newPosts.shuffle(new Random());
        posts.addAll(newPosts);
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget body;

    if (posts.length > 0) {
      body = new LazyLoadScrollView(
        child: new ListView.builder(
          itemCount: posts.length + (loading ? 1 : 0),
          itemBuilder: (context, position) {
            if (position >= posts.length) {
              return new Center(
                child: new CircularProgressIndicator(),
              );
            }

            return new HeadlineView(
              post: posts[position],
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
