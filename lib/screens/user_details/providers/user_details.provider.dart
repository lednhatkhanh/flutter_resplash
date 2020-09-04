import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:re_splash/data/users.data.dart';
import 'package:re_splash/models/collection.model.dart';
import 'package:re_splash/models/photo.model.dart';
import 'package:re_splash/models/user.model.dart';

const perPage = 15;

class UserDetailsProvider extends ChangeNotifier {
  final UsersData _usersData = UsersData();
  final User _user;

  List<Photo> _photos;
  List<Collection> _collections;
  bool _isLoading;
  bool _canLoadMorePhotos;
  bool _canLoadMoreCollections;

  UserDetailsProvider({@required User user})
      : _user = user,
        _isLoading = false,
        _photos = [],
        _collections = [],
        _canLoadMorePhotos = true,
        _canLoadMoreCollections = true {
    loadPhotos();
    loadCollections();
  }

  User get user {
    return _user;
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

  bool get canLoadMorePhotos {
    return _canLoadMorePhotos;
  }

  bool get canLoadMoreCollections {
    return _canLoadMoreCollections;
  }

  Future<void> loadPhotos() async {
    try {
      _isLoading = true;
      notifyListeners();

      final photos = await _usersData.listPhotos(
        username: _user.username,
        page: 1,
        perPage: perPage,
      );
      final canLoadMore = photos.length == perPage;

      _photos = photos;
      _isLoading = false;
      _canLoadMorePhotos = canLoadMore;
      notifyListeners();
    } catch (_) {}
  }

  Future<void> loadMorePhotos() async {
    try {
      final nextPage = (_photos.length / perPage).round() + 1;
      _isLoading = true;
      notifyListeners();

      final photos = await _usersData.listPhotos(
        page: nextPage,
        perPage: perPage,
        username: _user.username,
      );
      final canLoadMore = photos.length == perPage;

      _photos.addAll(photos);
      _isLoading = false;
      _canLoadMorePhotos = canLoadMore;
      notifyListeners();
    } catch (_) {}
  }

  Future<void> loadCollections() async {
    try {
      _isLoading = true;
      notifyListeners();

      final collections = await _usersData.listCollections(
        username: _user.username,
        page: 1,
        perPage: perPage,
      );
      final canLoadMore = collections.length == perPage;

      _collections = collections;
      _isLoading = false;
      _canLoadMoreCollections = canLoadMore;
      notifyListeners();
    } catch (_) {}
  }

  Future<void> loadMoreCollections() async {
    try {
      final nextPage = (_photos.length / perPage).round() + 1;
      _isLoading = true;
      notifyListeners();

      final collections = await _usersData.listCollections(
        page: nextPage,
        perPage: perPage,
        username: _user.username,
      );
      final canLoadMore = collections.length == perPage;

      _collections.addAll(collections);
      _isLoading = false;
      _canLoadMoreCollections = canLoadMore;
      notifyListeners();
    } catch (_) {}
  }
}
