import 'package:flutter/foundation.dart';
import 'package:re_splash/clients/unsplash.client.dart';
import 'package:re_splash/models/collection.model.dart';
import 'package:re_splash/models/photo.model.dart';
import 'package:re_splash/services/utils/parser.dart';

enum CollectionsType {
  all,
  featured,
}

class CollectionsService {
  final UnsplashClient _client = UnsplashClient();

  Future<List<Collection>> listCollections({
    @required int page,
    @required int perPage,
  }) async {
    final url = _client.buildUrl(
      '/collections',
      {
        'page': page.toString(),
        'per_page': perPage.toString(),
      },
    );

    final response = await _client.get(url);

    if (response.statusCode == 200) {
      return compute(Parser.parseCollection, response.body);
    } else {
      throw Exception('Failed to load collections');
    }
  }

  Future<List<Collection>> listFeaturedCollections({
    @required int page,
    @required int perPage,
  }) async {
    final url = _client.buildUrl(
      '/collections/featured',
      {
        'page': page.toString(),
        'per_page': perPage.toString(),
      },
    );

    final response = await _client.get(url);

    if (response.statusCode == 200) {
      return compute(Parser.parseCollection, response.body);
    } else {
      throw Exception('Failed to load collections');
    }
  }

  Future<List<Photo>> getCollectionPhotos({
    @required int id,
    @required int page,
    @required int perPage,
  }) async {
    final url = _client.buildUrl(
      '/collections/$id/photos',
      {
        'page': page.toString(),
        'per_page': perPage.toString(),
      },
    );

    final response = await _client.get(url);

    if (response.statusCode == 200) {
      return compute(Parser.parsePhotos, response.body);
    } else {
      throw Exception('Failed to load collections');
    }
  }
}
