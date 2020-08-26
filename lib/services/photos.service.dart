import 'package:flutter/foundation.dart';
import 'package:re_splash/clients/unsplash.client.dart';
import 'package:re_splash/models/photo.model.dart';
import 'package:re_splash/services/utils/parser.dart';

enum PhotosOrderBy {
  latest,
  oldest,
  popular,
}

class PhotosService {
  final UnsplashClient _client = new UnsplashClient();

  Future<List<Photo>> listPhotos({
    @required int page,
    @required int perPage,
    @required PhotosOrderBy orderBy,
  }) async {
    String orderByString;
    switch (orderBy) {
      case PhotosOrderBy.oldest:
        orderByString = 'oldest';
        break;
      case PhotosOrderBy.popular:
        orderByString = 'popular';
        break;
      case PhotosOrderBy.latest:
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
      return compute(Parser.parsePhotos, response.body);
    } else {
      throw Exception('Failed to load photos');
    }
  }

  Future<List<Photo>> searchPhotos({
    @required String query,
    @required int page,
    @required int perPage,
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
      return compute(Parser.parseSearchPhotos, response.body);
    } else {
      throw Exception('Failed to search photos');
    }
  }
}
