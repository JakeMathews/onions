import 'package:flutter/material.dart';
import 'package:onions/configuration.dart';
import 'package:onions/pages/list_page.dart';

void main() {
  final configuration = new Configuration();

  return runApp(new MaterialApp(
    home: new ListPage(configuration.getDefaultSubredditGroup()),
  ));
}
