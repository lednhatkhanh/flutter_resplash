import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:re_splash/models/photo.model.dart';
import 'package:re_splash/screens/photo_details/providers/photo_details.provider.dart';
import 'package:re_splash/screens/photo_details/utils/download_utils.dart';
import 'package:re_splash/screens/photo_details/widgets/photo_details_exif.dart';
import 'package:re_splash/screens/photo_details/widgets/photo_details_statics.dart';
import 'package:re_splash/screens/photo_details/widgets/photo_details_tags.dart';
import 'photo_details_header.dart';

class PhotoDetailsBody extends StatefulWidget {
  final Photo _photo;

  PhotoDetailsBody({@required Photo photo}) : _photo = photo;

  @override
  _PhotoDetailsBodyState createState() => _PhotoDetailsBodyState();
}

class _PhotoDetailsBodyState extends State<PhotoDetailsBody>
    with SingleTickerProviderStateMixin {
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
    final permissionStatus =
        await DownloadUtils.ensureStoragePermission(context);
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
      showNotification: true,
      openFileFromNotification: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PhotoDetailsProvider>(
      builder: (context, value, child) => Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 320,
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.2),
                BlendMode.darken,
              ),
              child: CachedNetworkImage(
                imageUrl: value.photo.urls.regular,
                fit: BoxFit.cover,
              ),
            ),
          ),
          PhotoDetailsHeader(
            photo: value.photo,
            onDownload: _handleDownload,
          ),
          AnimatedSize(
            vsync: this,
            duration: Duration(milliseconds: 200),
            curve: Curves.linear,
            child: value.photo.exif != null
                ? Container(
                    child: Column(
                      children: [
                        PhotoDetailsExif(photo: value.photo),
                        PhotoDetailsStatics(photo: value.photo),
                        PhotoDetailsTags(photo: value.photo),
                      ],
                    ),
                  )
                : value.isLoading
                    ? Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(top: 10),
                        child: CircularProgressIndicator(),
                      )
                    : Container(),
          ),
        ],
      ),
    );
  }
}
