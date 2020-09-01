import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class _Env {
  final String unsplashAccessKey;

  _Env({this.unsplashAccessKey});

  factory _Env.fromJson(Map<String, dynamic> json) {
    return _Env(unsplashAccessKey: json['unsplashAccessKey']);
  }
}

class EnvLoader {
  final String _envPath;

  EnvLoader({String envPath = '.env.json'}) : _envPath = envPath;

  Future<_Env> load() async {
    return rootBundle.loadStructuredData<_Env>(_envPath, (jsonStr) async {
      final secret = _Env.fromJson(json.decode(jsonStr));
      return secret;
    });
  }
}
