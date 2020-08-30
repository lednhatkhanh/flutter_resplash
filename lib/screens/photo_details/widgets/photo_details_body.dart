import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:re_splash/models/photo.model.dart';
import 'package:re_splash/screens/photo_details/utils/download_utils.dart';
import 'photo_details_header.dart';

class PhotoDetailsBody extends StatefulWidget {
  final Photo _photo;

  PhotoDetailsBody({@required Photo photo}) : _photo = photo;

  @override
  _PhotoDetailsBodyState createState() => _PhotoDetailsBodyState();
}

class _PhotoDetailsBodyState extends State<PhotoDetailsBody> {
  Future<String> get _downloadDir async {
    Directory downloadPath;

    if (Platform.isIOS) {
      downloadPath = await getApplicationDocumentsDirectory();
    } else {
      downloadPath = await getExternalStorageDirectory();
    }

    return downloadPath.path;
  }

  Future<bool> _confirmReDownload() async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Download again?',
          style: Theme.of(context).textTheme.subtitle1,
        ),
        content: Text(
          'The photo has already been downloaded. Do you want to download this photo again?',
          style: Theme.of(context).textTheme.bodyText2,
        ),
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: Text('No'),
          ),
          FlatButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: Text('Yes'),
          ),
        ],
      ),
    ).then((value) => value == true);
  }

  void _handleDownload() async {
    final permissionStatus = await DownloadUtils.ensureStoragePermission(context);
    if (!permissionStatus) {
      return;
    }

    final fileExists = await DownloadUtils.getDownloadedFile(
          downloadUrl: widget._photo.links.download,
          savedDir: await _downloadDir,
        ) !=
        null;
    final canDownload = fileExists ? await _confirmReDownload() : true;
    if (!canDownload) {
      return;
    }

    final snackBar = SnackBar(content: Text('Download started'));
    Scaffold.of(context).showSnackBar(snackBar);

    await FlutterDownloader.enqueue(
      url: widget._photo.links.download,
      savedDir: await _downloadDir,
      showNotification:
          true, // show download progress in status bar (for Android)
      openFileFromNotification:
          true, // click on notification to open downloaded file (for Android)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 350,
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.2),
              BlendMode.darken,
            ),
            child: FadeInImage(
              image: NetworkImage(widget._photo.urls.regular),
              placeholder: AssetImage('assets/images/placeholder.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        PhotoDetailsHeader(
          photo: widget._photo,
          onDownload: _handleDownload,
        ),
      ],
    );
  }
}
