class SubredditGroup {
  final String name;
  final List<String> subreddits;

  SubredditGroup(this.name, {final List<String> subreddits}) : this.subreddits = (subreddits != null ? subreddits : []);
}
