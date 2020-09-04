import 'package:flutter/foundation.dart';

import 'package:re_splash/clients/unsplash.client.dart';
import 'package:re_splash/models/collection.model.dart';
import 'package:re_splash/models/photo.model.dart';
import 'package:re_splash/models/user.model.dart';

import 'utils/parser.dart';

class UsersData {
  final UnsplashClient _client = UnsplashClient();

  Future<User> getAUser({@required String username}) async {
    final url = _client.buildUrl(
      '/users/$username',
      null,
    );
    final response = await _client.get(url);

    if (response.statusCode == 200) {
      return compute(Parser.parseUser, response.body);
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<List<Photo>> listPhotos({
    @required String username,
    @required int page,
    @required int perPage,
  }) async {
    final url = _client.buildUrl(
      '/users/$username/photos',
      {
        'page': page.toString(),
        'per_page': perPage.toString(),
      },
    );
    final response = await _client.get(url);

    if (response.statusCode == 200) {
      return compute(Parser.parsePhotos, response.body);
    } else {
      throw Exception('Failed to load photos');
    }
  }

  Future<List<Collection>> listCollections({
    @required String username,
    @required int page,
    @required int perPage,
  }) async {
    final url = _client.buildUrl(
      '/users/$username/collections',
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
}
