import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:re_splash/data/collections.data.dart';
import 'package:re_splash/models/collection.model.dart';

import 'query.provider.dart';

const int perPage = 15;

class SearchCollectionsProvider extends ChangeNotifier {
  final CollectionsData _collectionsData = CollectionsData();
  final QueryProvider _queryProvider;

  bool _canLoadMore;
  List<Collection> _collections;
  bool _isLoading;

  SearchCollectionsProvider({@required QueryProvider queryProvider})
      : _queryProvider = queryProvider,
        _canLoadMore = true,
        _collections = [],
        _isLoading = false {
    if (queryProvider.query?.isNotEmpty == true) {
      searchCollections();
    }
  }

  bool get canLoadMore {
    return _canLoadMore;
  }

  bool get isLoading {
    return _isLoading;
  }

  UnmodifiableListView<Collection> get collections {
    return UnmodifiableListView(_collections);
  }

  Future<void> searchCollections() async {
    try {
      _isLoading = true;
      _collections = [];
      notifyListeners();

      final photos = await _collectionsData.searchCollections(
        query: _queryProvider.query,
        page: 1,
        perPage: perPage,
      );
      final canLoadMore = photos.length == perPage;

      _collections = photos;
      _isLoading = false;
      _canLoadMore = canLoadMore;
      notifyListeners();
    } catch (_) {}
  }

  Future<void> loadMoreCollections() async {
    try {
      final nextPage = (_collections.length / perPage).round() + 1;
      _isLoading = true;
      notifyListeners();

      final photos = await _collectionsData.searchCollections(
        query: _queryProvider.query,
        page: nextPage,
        perPage: perPage,
      );
      final canLoadMore = photos.length == perPage;

      _collections.addAll(photos);
      _isLoading = false;
      _canLoadMore = canLoadMore;
      notifyListeners();
    } catch (_) {}
  }
}
