import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:re_splash/data/photos.data.dart';
import 'package:re_splash/models/photo.model.dart';

import 'query.provider.dart';

const int perPage = 15;

class SearchPhotosProvider extends ChangeNotifier {
  final PhotosData _photosData = PhotosData();
  final QueryProvider _queryProvider;

  bool _canLoadMore;
  List<Photo> _photos;
  bool _isLoading;
  SearchPhotosOrderBy _orderBy;
  SearchPhotosContentFilter _contentFilter;
  SearchPhotosColor _color;
  SearchPhotosOrientation _orientation;

  SearchPhotosProvider({@required QueryProvider queryProvider})
      : _queryProvider = queryProvider,
        _canLoadMore = true,
        _photos = [],
        _isLoading = false,
        _orderBy = SearchPhotosOrderBy.relevant,
        _contentFilter = SearchPhotosContentFilter.low,
        _color = SearchPhotosColor.any,
        _orientation = SearchPhotosOrientation.any {
    if (queryProvider.query?.isNotEmpty == true) {
      searchPhotos();
    }
  }

  bool get canLoadMore {
    return _canLoadMore;
  }

  bool get isLoading {
    return _isLoading;
  }

  UnmodifiableListView<Photo> get photos {
    return UnmodifiableListView(_photos);
  }

  SearchPhotosOrderBy get orderBy {
    return _orderBy;
  }

  SearchPhotosContentFilter get contentFilter {
    return _contentFilter;
  }

  SearchPhotosColor get color {
    return _color;
  }

  SearchPhotosOrientation get orientation {
    return _orientation;
  }

  void applyFilter({
    SearchPhotosOrderBy orderBy,
    SearchPhotosContentFilter contentFilter,
    SearchPhotosColor color,
    SearchPhotosOrientation orientation,
  }) {
    _orderBy = orderBy;
    _contentFilter = contentFilter;
    _color = color;
    _orientation = orientation;

    searchPhotos();
  }

  Future<void> searchPhotos() async {
    try {
      _isLoading = true;
      _photos = [];
      notifyListeners();

      final photos = await _photosData.searchPhotos(
        query: _queryProvider.query,
        page: 1,
        perPage: perPage,
        color: _color,
        contentFilter: _contentFilter,
        orderBy: _orderBy,
        orientation: _orientation,
      );
      final canLoadMore = photos.length == perPage;

      _photos = photos;
      _isLoading = false;
      _canLoadMore = canLoadMore;
      notifyListeners();
    } catch (_) {}
  }

  Future<void> loadMorePhotos() async {
    try {
      final nextPage = (_photos.length / perPage).round() + 1;
      _isLoading = true;
      notifyListeners();

      final photos = await _photosData.searchPhotos(
        query: _queryProvider.query,
        page: nextPage,
        perPage: perPage,
        color: _color,
        contentFilter: _contentFilter,
        orderBy: _orderBy,
        orientation: _orientation,
      );
      final canLoadMore = photos.length == perPage;

      _photos.addAll(photos);
      _isLoading = false;
      _canLoadMore = canLoadMore;
      notifyListeners();
    } catch (_) {}
  }
}
