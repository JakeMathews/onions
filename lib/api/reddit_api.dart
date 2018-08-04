import 'dart:async';

import 'package:http/http.dart';
import 'package:onions/api/model/subreddit.dart';
import 'package:onions/model/headline.dart';

class RedditApi {
  static final Uri baseUri = new Uri(scheme: 'https', host: 'www.reddit.com');

  final int limit = 20;

  Future<Response> getSubredditResponse(final String subredditName, {final Headline last}) {
    final Map<String, String> params = {
      'limit': limit.toString(),
    };

    if (last != null) {
      params['after'] = last.name;
    }

    final Uri uri = baseUri.replace(path: 'r/$subredditName/hot.json', queryParameters: params);
    return get(uri);
  }

  Future<Subreddit> getSubreddit(final String subredditName, {final Headline lastHeadline}) async {
    final Response subredditResponse = await getSubredditResponse(subredditName, last: lastHeadline);
    final Subreddit subreddit = Subreddit.fromHttpResponse(subredditName, subredditResponse);

    return subreddit;
  }

  Future<Subreddit> getMoreSubreddit(final Subreddit subreddit) {
    return getSubreddit(subreddit.name, lastHeadline: subreddit.lastHeadline);
  }

  List<Future<Subreddit>> getMoreSubreddits(final List<Subreddit> subreddits) {
    final List<Future<Subreddit>> subredditFutures = subreddits.map((final Subreddit subreddit) {
      return getMoreSubreddit(subreddit);
    }).toList();

    return subredditFutures;
  }
}
