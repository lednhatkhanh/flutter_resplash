import 'package:flutter/material.dart';
import 'package:re_splash/routes/home/home.dart';

void main() {
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
      home: HomeRoute(),
    );
  }
}
