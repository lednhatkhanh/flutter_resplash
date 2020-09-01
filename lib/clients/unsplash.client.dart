import 'package:http/http.dart' as http;
import 'package:re_splash/configs/env.dart';

class UnsplashClient extends http.BaseClient {
  final http.Client _client = http.Client();
  final EnvLoader _envLoader = EnvLoader();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    request.headers.addAll({
      'Authorization':
          'Client-ID ${(await _envLoader.load()).unsplashAccessKey}',
    });
    return _client.send(request);
  }

  String buildUrl(String path, Map<String, String> queryParameter) {
    return Uri.https('api.unsplash.com', path, queryParameter).toString();
  }
}
