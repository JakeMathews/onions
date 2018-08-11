import 'package:flutter/material.dart';
import 'package:onions/pages/list_page.dart';

void main() => runApp(new MaterialApp(
      home: new ListPage(['theonion', 'nottheonion']),
    ));
