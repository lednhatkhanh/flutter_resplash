import 'dart:collection';
import 'package:flutter/material.dart';

import 'package:re_splash/data/collections.data.dart';
import 'package:re_splash/models/collection.model.dart';
import 'package:re_splash/models/photo.model.dart';

const int PER_PAGE = 15;

class CollectionDetailsProvider extends ChangeNotifier {
  final Collection _collection;
  final CollectionsData _collectionsData = CollectionsData();

  List<Photo> _photos;
  bool _isLoading;
  bool _canLoadMore;

  CollectionDetailsProvider({@required Collection collection})
      : _collection = collection,
        _photos = [],
        _canLoadMore = true,
        _isLoading = false;

  UnmodifiableListView<Photo> get photos {
    return UnmodifiableListView(_photos);
  }

  bool get isLoading {
    return _isLoading;
  }

  bool get canLoadMore {
    return _canLoadMore;
  }

  Future<void> getPhotos() async {
    try {
      _isLoading = true;
      _photos = [];
      notifyListeners();

      final photos = await _collectionsData.getCollectionPhotos(
        id: _collection.id,
        page: 1,
        perPage: PER_PAGE,
      );
      final canLoadMore = photos.length == PER_PAGE;

      _photos = photos;
      _isLoading = false;
      _canLoadMore = canLoadMore;
      notifyListeners();
    } catch (_) {}
  }

  Future<void> loadMorePhotos() async {
    try {
      final nextPage = (_photos.length / PER_PAGE).round() + 1;

      _isLoading = true;
      notifyListeners();

      final photos = await _collectionsData.getCollectionPhotos(
        id: _collection.id,
        page: nextPage,
        perPage: PER_PAGE,
      );
      final canLoadMore = photos.length == PER_PAGE;

      _photos.addAll(photos);
      _isLoading = false;
      _canLoadMore = canLoadMore;
      notifyListeners();
    } catch (_) {}
  }
}
