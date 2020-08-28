import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

import 'screens/home/home.screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterDownloader.initialize(
    debug: false,
  );

  runApp(ReplashApp());
}

class ReplashApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primarySwatch: Colors.deepPurple,
      ),
      home: HomeScreen(),
    );
  }
}
