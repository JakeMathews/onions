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
          title: new Text(post.text != null ? post.text.toLowerCase() : 'No'),
          onLongPress: () {
            Scaffold.of(context).showSnackBar(
                  new SnackBar(
                    content: new Text(post.source),
                    action: new SnackBarAction(
                        label: 'View Post',
                        onPressed: () {
                          _launchURL(post.permalink.toString());
                        }),
                  ),
                );
          },
          onTap: () {
            _launchURL(post.url);
          },
        ),
        new Divider()
      ],
    );
  }

  _launchURL(final String url) async {
    if (await canLaunch(url)) {
      print('Launching URL: $url');
      await launch(url, forceWebView: false);
    } else {
      throw 'Could not launch $url';
    }
  }
}
