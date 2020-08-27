import 'package:flutter/material.dart';

import 'screens/home/home.screen.dart';

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
      home: HomeScreen(),
    );
  }
}
