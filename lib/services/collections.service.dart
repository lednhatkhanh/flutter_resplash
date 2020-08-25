import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:re_splash/clients/unsplash.client.dart';
import 'package:re_splash/models/collection.model.dart';

List<Collection> _parseCollection(dynamic jsonData) {
  return (json.decode(jsonData) as List<dynamic>)
      .map((e) => Collection.fromJson(e))
      .toList();
}

class CollectionsService {
  final UnsplashClient _client = new UnsplashClient();

  Future<List<Collection>> listCollections({
    @required int page,
    @required int perPage,
  }) async {
    final String url = _client.buildUrl(
      '/collections',
      {
        "page": page.toString(),
        "per_page": perPage.toString(),
      },
    );

    final response = await _client.get(url);

    if (response.statusCode == 200) {
      return compute(_parseCollection, response.body);
    } else {
      throw Exception('Failed to load photos');
    }
  }
}
