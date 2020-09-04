import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void openLink(BuildContext context, String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    final snackBar = SnackBar(
      content: Text(
        'Failed to open link',
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }
}
