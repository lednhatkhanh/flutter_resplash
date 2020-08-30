import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:re_splash/models/photo.model.dart';
import 'package:re_splash/screens/photo_details/utils/download_listener.dart';
import 'package:re_splash/screens/photo_details/utils/download_utils.dart';

class PhotoDetailsActionButton extends StatefulWidget {
  final Photo _photo;

  PhotoDetailsActionButton({@required Photo photo}) : _photo = photo;

  @override
  _PhotoDetailsActionButtonState createState() =>
      _PhotoDetailsActionButtonState();
}

class _PhotoDetailsActionButtonState extends State<PhotoDetailsActionButton> {
  final MethodChannel _channel =
      const MethodChannel('dev.khanhle.re_splash/wallpaper');
  DownloadListener _downloadManagerPort;

  String _cacheWallpaperTask;

  String get _downloadUrl {
    final parsedUri = Uri.parse(widget._photo.links.download);
    return parsedUri.replace(queryParameters: {
      ...parsedUri.queryParameters,
      'force': 'true'
    }).toString();
  }

  @override
  void initState() {
    super.initState();

    _cacheWallpaperTask = null;
    _downloadManagerPort = DownloadListener(callback: _cacheWallpaperListener);

    _downloadManagerPort.initialize();
  }

  @override
  void dispose() {
    super.dispose();
    _downloadManagerPort.dispose();
  }

  void _cacheWallpaperListener(String id, DownloadTaskStatus status, int progress) {
    if (_cacheWallpaperTask != null &&
        id == _cacheWallpaperTask &&
        status == DownloadTaskStatus.complete) {
      _handleSetWallpaper();
    }
  }

  void _handleSetWallpaper() async {
    final permissionStatus = await DownloadUtils.ensureStoragePermission(context);
    if (!permissionStatus) {
      return;
    }

    final tempDirPath = (await getTemporaryDirectory()).absolute.path;
    var filePath = await DownloadUtils.getDownloadedFile(
      downloadUrl: _downloadUrl,
      savedDir: tempDirPath,
    );

    if (filePath != null) {
      try {
        await _channel.invokeMethod(
          'setWallpaper',
          {'filePath': filePath},
        );
      } catch (_) {}
    } else {
      final snackBar = SnackBar(
        content: Text(
          'Setting wallpaper',
        ),
      );
      Scaffold.of(context).showSnackBar(snackBar);

      _cacheWallpaperTask = await FlutterDownloader.enqueue(
        url: _downloadUrl,
        savedDir: tempDirPath,
        showNotification: false,
        openFileFromNotification: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      icon: Icon(Icons.image),
      label: Text('SET AS WALLPAPER'),
      onPressed: _handleSetWallpaper,
    );
  }
}
