import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadUtils {
  static Future<String> getDownloadedFile({
    String downloadUrl,
    String savedDir,
  }) async {
    final tasks = await FlutterDownloader.loadTasks();
    final currentTasks =
        tasks.where((element) => element.url == downloadUrl).toList();
    if (currentTasks.isEmpty) {
      return null;
    }

    final filePath = '${savedDir}/${currentTasks[0].filename}';
    if (await File(filePath).exists()) {
      return filePath;
    }

    return null;
  }

  static Future<bool> ensureStoragePermission(BuildContext context) async {
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
}
