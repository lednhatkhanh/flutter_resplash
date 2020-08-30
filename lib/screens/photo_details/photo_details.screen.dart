import 'dart:io';
import 'package:flutter/material.dart';
import 'package:re_splash/screens/photo_details/widgets/photo_details_action_button.dart';
import 'package:re_splash/screens/photo_details/widgets/photo_details_body.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:re_splash/models/photo.model.dart';

enum _PopupMenuValue { description, share }

class PhotoDetailsScreen extends StatefulWidget {
  final Photo _photo;

  PhotoDetailsScreen({@required Photo photo}) : _photo = photo;

  @override
  _PhotoDetailsScreenState createState() => _PhotoDetailsScreenState();
}

class _PhotoDetailsScreenState extends State<PhotoDetailsScreen> {
  Photo get photo {
    return widget._photo;
  }

  String get description {
    return photo.description ?? photo.altDescription;
  }

  void _openInBrowser() async {
    final url = photo.links.html;

    if (await canLaunch(url)) {
      await launch(url);
    } else {}
  }

  void _handleShare() {
    Share.share(photo.links.html);
  }

  void _handlePopupMenuSelected(_PopupMenuValue selected) {
    if (selected == _PopupMenuValue.description) {
      showDialog(
        context: context,
        child: SimpleDialog(
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          children: [Text(description)],
        ),
      );
    } else {
      _handleShare();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: Theme.of(context).iconTheme.copyWith(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_browser),
            tooltip: 'Open in browser',
            onPressed: _openInBrowser,
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            tooltip: 'Menu',
            onSelected: _handlePopupMenuSelected,
            itemBuilder: (context) => [
              if (description != null)
                PopupMenuItem(
                  value: _PopupMenuValue.description,
                  child: Row(
                    children: [
                      Icon(
                        Icons.description,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      SizedBox(width: 30),
                      Text('Description'),
                    ],
                  ),
                ),
              PopupMenuItem(
                value: _PopupMenuValue.share,
                child: Row(
                  children: [
                    Icon(
                      Icons.share,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    SizedBox(width: 30),
                    Text('Share'),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
      body: PhotoDetailsBody(photo: photo),
      floatingActionButton: Platform.isAndroid
          ? PhotoDetailsActionButton(photo: photo)
          : null,
    );
  }
}
