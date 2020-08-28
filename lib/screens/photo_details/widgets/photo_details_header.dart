import 'dart:async';
import 'dart:io';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:re_splash/models/photo.model.dart';
import 'package:re_splash/widgets/user_avatar_item.dart';

class PhotoDetailsHeader extends StatefulWidget {
  final Photo _photo;

  PhotoDetailsHeader({@required Photo photo}) : _photo = photo;

  @override
  _PhotoDetailsHeaderState createState() => _PhotoDetailsHeaderState();
}

class _PhotoDetailsHeaderState extends State<PhotoDetailsHeader> {
  Photo get photo {
    return widget._photo;
  }

  Future<String> get _downloadPath async {
    Directory downloadPath;

    if (Platform.isIOS) {
      downloadPath = await getApplicationDocumentsDirectory();
    } else {
      downloadPath = await getExternalStorageDirectory();
    }

    return downloadPath.path;
  }

  String get _downloadUrl {
    final parsedUri = Uri.parse(photo.links.download);

    return parsedUri.replace(queryParameters: {
      ...parsedUri.queryParameters,
      'force': 'true',
    }).toString();
  }

  Future<bool> _enstureStoragePermission() async {
    final status = await Permission.storage.request();

    if (status != PermissionStatus.granted) {
      final snackBar = SnackBar(
        content: Text(
          'Resplash needs access to your phone\'s storage to download the photo.',
        ),
      );
      Scaffold.of(context).showSnackBar(snackBar);
      return false;
    }

    return true;
  }

  Future<bool> _checkFileExists() async {
    final tasks = await FlutterDownloader.loadTasks();
    final currentTasks =
        tasks.where((element) => element.url == _downloadUrl).toList();
    if (currentTasks.isEmpty) {
      return false;
    }

    final filePath = '${await _downloadPath}/${currentTasks[0].filename}';
    return await File(filePath).exists();
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

  void _handleDownload(BuildContext context) async {
    final canDownload =
        await _checkFileExists() ? await _confirmReDownload() : true;
    if (!canDownload) {
      return;
    }

    final permissionStatus = await _enstureStoragePermission();
    if (!permissionStatus) {
      return;
    }

    final snackBar = SnackBar(content: Text('Download started'));
    Scaffold.of(context).showSnackBar(snackBar);

    await FlutterDownloader.enqueue(
      url: _downloadUrl,
      savedDir: await _downloadPath,
      showNotification:
          true, // show download progress in status bar (for Android)
      openFileFromNotification:
          true, // click on notification to open downloaded file (for Android)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: UserAvatarItem(
              image: photo.user.profileImage.medium,
              name: photo.user.name,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: () => _handleDownload(context),
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
