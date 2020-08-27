import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/home.provider.dart';
import 'widgets/home_content.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeProvider(),
      child: HomeContent(),
    );
  }
}
