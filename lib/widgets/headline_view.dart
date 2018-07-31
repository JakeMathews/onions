import 'package:flutter/material.dart';
import 'package:onions/model/headline.dart';

class HeadlineView extends StatelessWidget {
  final Headline headline;

  const HeadlineView({Key key, this.headline}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        new ListTile(
          title: new Text(headline.text != null ? headline.text : 'No'),
          onTap: () {
            Scaffold.of(context).showSnackBar(new SnackBar(content: new Text(headline.source)));
          },
        ),
        new Divider()
      ],
    );
  }
}
