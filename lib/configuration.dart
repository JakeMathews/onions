import 'package:onions/subreddit_group.dart';

final List<SubredditGroup> defaultSubredditGroups = [
  new SubredditGroup('Onions', subreddits: ['theonion', 'nottheonion']),
  new SubredditGroup('Nononono?', subreddits: ['nononono', 'nonononoyes']),
  new SubredditGroup('Expecting', subreddits: ['expected', 'unexpected']),
];

final Configuration configuration = new Configuration();

class Configuration {
  final Map<String, SubredditGroup> _subredditGroups = {};

  SubredditGroup _defaultSubredditGroup;

  Configuration() {
    defaultSubredditGroups.forEach(addSubredditGroup);
  }

  bool addSubredditGroup(final SubredditGroup subredditGroup) {
    if (subredditGroup == null || _subredditGroups.containsKey(subredditGroup.name)) {
      return false;
    }

    if (_defaultSubredditGroup == null) {
      _defaultSubredditGroup = subredditGroup;
    }

    _subredditGroups[subredditGroup.name] = subredditGroup;

    return true;
  }

  SubredditGroup getDefaultSubredditGroup() => _defaultSubredditGroup;

  List<SubredditGroup> getSubredditGroups() => _subredditGroups.values.toList();
}
