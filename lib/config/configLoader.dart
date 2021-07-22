import 'dart:async' show Future;
import 'dart:convert' show json;
import 'package:flutter/services.dart' show rootBundle;
import 'package:shop_app/config/config.dart';
class ConfigLoader {
  final String secretPath;
  
  ConfigLoader({this.secretPath});
  Future<Config> load() {
    return rootBundle.loadStructuredData<Config>(this.secretPath,
        (jsonStr) async {
      final secret = Config.fromJson(json.decode(jsonStr));
      return secret;
    });
  }
}