import 'dart:async';

import 'package:http/http.dart';
import 'package:onions/api/model/post.dart';
import 'package:onions/api/model/subreddit.dart';

class RedditApi {
  static final Uri baseUri = new Uri(scheme: 'https', host: 'www.reddit.com');

  final int limit = 20;

  Future<Response> getSubredditResponse(final String subredditName, {final Post last}) {
    final Map<String, String> params = {
      'limit': limit.toString(),
    };

    if (last != null) {
      params['after'] = last.name;
    }

    final Uri uri = baseUri.replace(path: 'r/$subredditName/hot.json', queryParameters: params);
    return get(uri);
  }

  Future<List<Post>> requestPosts(final String subredditName, {final Post lastPost}) async {
    final Response response = await getSubredditResponse(subredditName, last: lastPost);
    final List<Post> posts = Post.fromHttpResponse(response);

    return posts;
  }

  Future<List<Post>> requestPostsFromSubreddit(final Subreddit subreddit) async {
    return requestPosts(subreddit.name, lastPost: subreddit.getLastPost());
  }

  Future<Subreddit> requestUpdatedSubreddit(final Subreddit subreddit) async {
    final List<Post> posts = await requestPostsFromSubreddit(subreddit);
    subreddit.latestPosts.clear();
    subreddit.latestPosts.addAll(posts);

    return subreddit;
  }

  List<Future<Subreddit>> requestAllUpdatedSubreddits(final List<Subreddit> subreddits) {
    final List<Future<Subreddit>> updatedSubreddits = [];
    subreddits.forEach((final Subreddit subreddit) {
      updatedSubreddits.add(requestUpdatedSubreddit(subreddit));
    });

    return updatedSubreddits;
  }
}
