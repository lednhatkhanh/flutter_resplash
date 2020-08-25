import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:re_splash/clients/unsplash.client.dart';
import 'package:re_splash/models/photo.model.dart';

List<Photo> _parsePhotos(dynamic jsonData) {
  return (json.decode(jsonData) as List<dynamic>)
      .map((e) => Photo.fromJson(e))
      .toList();
}

List<Photo> _parseSearchPhotos(dynamic jsonData) {
  return (json.decode(jsonData)['results'] as List<dynamic>)
      .map((e) => Photo.fromJson(e))
      .toList();
}

enum GetPhotosOrderBy {
  latest,
  oldest,
  popular,
}

class PhotosService {
  final UnsplashClient _client = new UnsplashClient();

  Future<List<Photo>> getPhotos({
    int page,
    int perPage,
    GetPhotosOrderBy orderBy,
  }) async {
    String orderByString;
    switch (orderBy) {
      case GetPhotosOrderBy.oldest:
        orderByString = 'oldest';
        break;
      case GetPhotosOrderBy.popular:
        orderByString = 'popular';
        break;
      case GetPhotosOrderBy.latest:
      default:
        orderByString = 'latest';
    }

    final String url = _client.buildUrl(
      '/photos',
      {
        "page": page.toString(),
        "per_page": perPage.toString(),
        'order_by': orderByString,
      },
    );
    final response = await _client.get(url);

    if (response.statusCode == 200) {
      return compute(_parsePhotos, response.body);
    } else {
      throw Exception('Failed to load photos');
    }
  }

  Future<List<Photo>> searchPhotos({
    String query,
    int page,
    int perPage,
  }) async {
    final String url = _client.buildUrl(
      '/search/photos',
      {
        "page": page.toString(),
        "per_page": perPage.toString(),
        "query": query,
      },
    );

    final response = await _client.get(url);

    if (response.statusCode == 200) {
      return compute(_parseSearchPhotos, response.body);
    } else {
      throw Exception('Failed to search photos');
    }
  }
}
