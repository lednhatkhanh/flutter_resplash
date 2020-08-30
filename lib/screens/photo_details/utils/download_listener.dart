import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

typedef _Callback = void Function(String id, DownloadTaskStatus status, int progress);

class DownloadListener {
  static void downloadCallback(
      String id,
      DownloadTaskStatus status,
      int progress,
      ) {
    final send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }

  final ReceivePort _port = ReceivePort();
  final _Callback _listener;

  DownloadListener({@required _Callback callback}): _listener = callback;

  void initialize() {
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');

    _port.listen((message) {
      String id = message[0];
      DownloadTaskStatus status = message[1];
      int progress = message[2];

      _listener(id, status, progress);
    });

    FlutterDownloader.registerCallback(
        DownloadListener.downloadCallback);
  }

  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }
}