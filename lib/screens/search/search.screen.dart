import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:re_splash/screens/search/providers/query.provider.dart';
import 'package:re_splash/screens/search/providers/search_collections.provider.dart';
import 'package:re_splash/screens/search/providers/search_photos.provider.dart';
import 'package:re_splash/screens/search/widgets/search_content.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<QueryProvider>(
          create: (context) => QueryProvider(),
        ),
        ChangeNotifierProxyProvider<QueryProvider, SearchPhotosProvider>(
          create: (context) => SearchPhotosProvider(
            queryProvider: Provider.of<QueryProvider>(context, listen: false),
          ),
          update: (context, value, previous) => SearchPhotosProvider(
            queryProvider: value,
          ),
        ),
        ChangeNotifierProxyProvider<QueryProvider, SearchCollectionsProvider>(
          create: (context) => SearchCollectionsProvider(
            queryProvider: Provider.of<QueryProvider>(context, listen: false),
          ),
          update: (context, value, previous) => SearchCollectionsProvider(
            queryProvider: value,
          ),
        ),
      ],
      child: SearchContent(),
    );
  }
}
