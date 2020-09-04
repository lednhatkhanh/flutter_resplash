import 'dart:convert';

import 'package:re_splash/models/collection.model.dart';
import 'package:re_splash/models/photo.model.dart';
import 'package:re_splash/models/user.model.dart';

class Parser {
  static List<Photo> parsePhotos(dynamic jsonData) {
    return (json.decode(jsonData) as List<dynamic>)
        .map((e) => Photo.fromJson(e))
        .toList();
  }

  static List<Photo> parseSearchPhotos(dynamic jsonData) {
    return (json.decode(jsonData)['results'] as List<dynamic>)
        .map((e) => Photo.fromJson(e))
        .toList();
  }

  static Photo parsePhoto(dynamic jsonData) {
    return Photo.fromJson(json.decode(jsonData));
  }

  static List<Collection> parseCollection(dynamic jsonData) {
    return (json.decode(jsonData) as List<dynamic>)
        .map((e) => Collection.fromJson(e))
        .toList();
  }

  static List<Collection> parseSearchCollections(dynamic jsonData) {
    return (json.decode(jsonData)['results'] as List<dynamic>)
        .map((e) => Collection.fromJson(e))
        .toList();
  }

  static User parseUser(dynamic jsonData) {
    return User.fromJson(json.decode(jsonData));
  }
}
