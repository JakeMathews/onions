import 'package:flutter/material.dart';
import 'package:onions/configuration.dart' as config;
import 'package:onions/pages/list_page.dart';

void main() => runApp(new MaterialApp(
      home: new ListPage(config.subreddits.first),
    ));
