import 'package:flutter/material.dart';
import 'package:onions/api/model/post.dart';
import 'package:url_launcher/url_launcher.dart';

class HeadlineView extends StatelessWidget {
  final Post post;

  HeadlineView({@required this.post});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        new ListTile(
          title: new Text(headline.text != null ? headline.text.toLowerCase() : 'No'),
          onTap: () {
            Scaffold.of(context).showSnackBar(new SnackBar(
                  content: new Text(post.source),
                  action: new SnackBarAction(label: 'View Post', onPressed: _launchURL),
                ));
          },
        ),
        new Divider()
      ],
    );
  }

  _launchURL() async {
    final String url = post.uri.toString();
    if (await canLaunch(url)) {
      print('Launching URL: $url');
      await launch(url, forceWebView: false);
    } else {
      throw 'Could not launch $url';
    }
  }
}
