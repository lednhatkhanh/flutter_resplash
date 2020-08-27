import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:re_splash/models/collection.model.dart';

import 'providers/collection_details.provider.dart';
import 'widgets/collection_details_content.dart';

class CollectionDetailsScreen extends StatelessWidget {
  final Collection _collection;

  CollectionDetailsScreen({@required Collection collection})
      : _collection = collection;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CollectionDetailsProvider(collection: _collection),
      child: CollectionDetailsContent(
        collection: _collection,
      ),
    );
  }
}
