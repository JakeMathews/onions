import 'package:onions/subreddit_group.dart';

final List<SubredditGroup> defaultSubredditGroups = [
  new SubredditGroup('Onions', subreddits: ['theonion', 'nottheonion']),
  new SubredditGroup('Nononono?', subreddits: ['nononono', 'nonononoyes']),
  new SubredditGroup('Expecting', subreddits: ['expected', 'unexpected']),
];

final SubredditGroupManager subredditGroupManager = new SubredditGroupManager();

class SubredditGroupManager {
  final Map<String, SubredditGroup> _subredditGroups = {};

  SubredditGroup _defaultSubredditGroup;

  SubredditGroupManager() {
    defaultSubredditGroups.forEach(add);
  }

  bool add(final SubredditGroup subredditGroup) {
    if (subredditGroup?.name == null || exists(subredditGroup.name)) {
      return false;
    }

    if (_defaultSubredditGroup == null) {
      _defaultSubredditGroup = subredditGroup;
    }

    _subredditGroups[getKeyName(subredditGroup.name)] = subredditGroup;

    return true;
  }

  bool remove(final SubredditGroup subredditGroup) {
    if (subredditGroup?.name == null && !exists(subredditGroup.name)) {
      return false;
    }

    _subredditGroups.remove(subredditGroup);

    if (subredditGroup == _defaultSubredditGroup && _subredditGroups.isNotEmpty) {
      _defaultSubredditGroup = _subredditGroups.values.first;
    } else if (subredditGroup == _defaultSubredditGroup) {
      _defaultSubredditGroup = null;
    }

    _subredditGroups[getKeyName(subredditGroup.name)] = subredditGroup;

    return true;
  }

  void removeByName(final String subredditGroupName) {
    _subredditGroups.removeWhere((final String subredditGroupKey, final SubredditGroup subredditGroup) {
      return subredditGroup.name == subredditGroupName;
    });
  }

  bool exists(final String subredditGroupName) {
    return subredditGroupName != null && _subredditGroups.containsKey(getKeyName(subredditGroupName));
  }

  String getKeyName(final String subredditGroupName) {
    return subredditGroupName?.trim()?.toLowerCase();
  }

  SubredditGroup getDefaultSubredditGroup() => _defaultSubredditGroup;

  List<SubredditGroup> getSubredditGroups() => _subredditGroups.values.toList();
}
