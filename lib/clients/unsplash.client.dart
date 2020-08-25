import 'package:http/http.dart' as http;

class UnsplashClient extends http.BaseClient {
  final http.Client _client = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll({
      'Authorization': 'Client-ID TG0haQaShuppk7ujA7pOxZqe5jaoalCJ1ELrAGx82f4',
    });
    return _client.send(request);
  }

  String buildUrl(String path, Map<String, String> queryParameter) {
    return Uri.https('api.unsplash.com', path, queryParameter).toString();
  }
}
