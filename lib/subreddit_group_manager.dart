import 'dart:async';

import 'package:onions/subreddit_group.dart';
import 'package:shared_preferences/shared_preferences.dart';

final List<SubredditGroup> defaultSubredditGroups = [
  new SubredditGroup('Onions', subreddits: ['theonion', 'nottheonion']),
  new SubredditGroup('Nononono?', subreddits: ['nononono', 'nonononoyes']),
  new SubredditGroup('Expecting', subreddits: ['expected', 'unexpected']),
];

// TODO: Save and load SharedPreferences
class SubredditGroupManager {
  final Map<String, SubredditGroup> _subredditGroups = {};

  SubredditGroup _defaultSubredditGroup;

  bool add(final SubredditGroup subredditGroup, {final bool save = true}) {
    if (subredditGroup?.name == null || exists(subredditGroup.name)) {
      return false;
    }

    if (_defaultSubredditGroup == null) {
      _defaultSubredditGroup = subredditGroup;
    }

    _subredditGroups[getKeyName(subredditGroup)] = subredditGroup;
    if (save) {
      _saveToPreferences();
    }

    return true;
  }

  bool remove(final SubredditGroup subredditGroup, {final bool save = true}) {
    if (subredditGroup?.name == null && !exists(subredditGroup.name)) {
      return false;
    }

    _subredditGroups.remove(getKeyName(subredditGroup));

    if (subredditGroup == _defaultSubredditGroup && _subredditGroups.isNotEmpty) {
      _defaultSubredditGroup = _subredditGroups.values.first;
    } else if (subredditGroup == _defaultSubredditGroup) {
      _defaultSubredditGroup = null;
    }

    _subredditGroups[getKeyName(subredditGroup)] = subredditGroup;
    if (save) {
      _saveToPreferences();
    }

    return true;
  }

  void removeByName(final String subredditGroupName) {
    for (final SubredditGroup subredditGroup in _subredditGroups.values) {
      if (subredditGroup.name == subredditGroupName) {
        remove(subredditGroup);
        break;
      }
    }
  }

  bool exists(final String subredditGroupName) {
    return subredditGroupName != null && _subredditGroups.containsKey(getKeyNameFromString(subredditGroupName));
  }

  String getKeyNameFromString(final String subredditGroupName) {
    return subredditGroupName?.trim()?.toLowerCase();
  }

  String getKeyName(final SubredditGroup subredditGroup) {
    return getKeyNameFromString(subredditGroup.name);
  }

  SubredditGroup getDefaultSubredditGroup() => _defaultSubredditGroup;

  List<SubredditGroup> getSubredditGroups() => _subredditGroups.values.toList();

  Future<void> load() async {
    bool loaded = await _loadFromPreferences();
    if (!loaded) {
      defaultSubredditGroups.forEach(add);
    }
  }

  Future<void> _saveToPreferences() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setStringList('names', _subredditGroups.values.map((final SubredditGroup subredditGroup) => subredditGroup.name).toList());
    _subredditGroups.values.forEach((final SubredditGroup subredditGroup) {
      preferences.setStringList(subredditGroup.name, subredditGroup.subreddits);
    });
  }

  Future<bool> _loadFromPreferences() async {
    try {
      final SharedPreferences preferences = await SharedPreferences.getInstance();
      final List<String> groupNames = preferences.getStringList('names');
      groupNames.forEach((final String groupName) {
        final List<String> subreddits = preferences.getStringList(groupName);
        final SubredditGroup subredditGroup = new SubredditGroup(groupName, subreddits: subreddits);
        add(subredditGroup, save: false);
      });
      return true;
    } catch (exception) {
      print('Failed to load preferences');
      return false;
    }
  }
}
