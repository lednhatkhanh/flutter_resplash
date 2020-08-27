import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:re_splash/data/collections.data.dart';
import 'package:re_splash/data/photos.data.dart';
import 'package:re_splash/models/collection.model.dart';
import 'package:re_splash/models/photo.model.dart';

const int perPage = 15;

class HomeProvider extends ChangeNotifier {
  final PhotosData _photoProvider = PhotosData();
  final CollectionsData _collectionsProvider = CollectionsData();

  List<Photo> _photos = [];
  PhotosOrderBy _photosOrderBy;

  List<Collection> _collections = [];
  CollectionsType _collectionsType;

  bool _isLoading = false;

  HomeProvider()
      : _isLoading = false,
        _photosOrderBy = PhotosOrderBy.latest,
        _collectionsType = CollectionsType.all {
    getPhotos();
    getCollections();
  }

  bool get isLoading {
    return _isLoading;
  }

  UnmodifiableListView<Photo> get photos {
    return UnmodifiableListView(_photos);
  }

  UnmodifiableListView<Collection> get collections {
    return UnmodifiableListView(_collections);
  }

  PhotosOrderBy get photosOrderBy {
    return _photosOrderBy;
  }

  set photosOrderBy(PhotosOrderBy value) {
    _photosOrderBy = value;
    getPhotos();
  }

  CollectionsType get collectionsType {
    return _collectionsType;
  }

  set collectionsType(CollectionsType value) {
    _collectionsType = value;
    getCollections();
  }

  Future<void> getPhotos() async {
    try {
      _isLoading = true;
      _photos = [];
      notifyListeners();

      final photos = await _photoProvider.listPhotos(
        page: 1,
        perPage: perPage,
        orderBy: _photosOrderBy,
      );

      _photos = photos;
      _isLoading = false;
      notifyListeners();
    } catch (_) {}
  }

  Future<void> getMorePhotos() async {
    try {
      final nextPage = (_photos.length / perPage).round() + 1;

      _isLoading = true;
      notifyListeners();

      final photos = await _photoProvider.listPhotos(
        page: nextPage,
        perPage: perPage,
        orderBy: _photosOrderBy,
      );

      _photos.addAll(photos);
      _isLoading = false;
      notifyListeners();
    } catch (_) {}
  }

  Future<void> getCollections() async {
    try {
      _isLoading = true;
      _collections = [];
      notifyListeners();

      var collections = <Collection>[];
      if (_collectionsType == CollectionsType.all) {
        collections = await _collectionsProvider.listCollections(
          page: 1,
          perPage: perPage,
        );
      } else {
        collections = await _collectionsProvider.listFeaturedCollections(
          page: 1,
          perPage: perPage,
        );
      }

      _collections = collections;
      _isLoading = false;
      notifyListeners();
    } catch (_) {}
  }

  Future<void> getMoreCollections() async {
    try {
      final nextPage = (_collections.length / perPage).round() + 1;

      _isLoading = true;
      notifyListeners();

      var collections = <Collection>[];
      if (_collectionsType == CollectionsType.all) {
        collections = await _collectionsProvider.listCollections(
          page: nextPage,
          perPage: perPage,
        );
      } else {
        collections = await _collectionsProvider.listFeaturedCollections(
          page: nextPage,
          perPage: perPage,
        );
      }

      _collections.addAll(collections);
      _isLoading = false;
      notifyListeners();
    } catch (_) {}
  }
}
