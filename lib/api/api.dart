export 'response_models/entry_response.dart';
export 'response_models/author_response.dart';
export 'response_models/embed_response.dart';
export 'response_models/serializers.dart';

import 'package:http/http.dart';
import 'dart:async';
import 'package:built_value/serializer.dart';
import 'package:built_value/built_value.dart';
import 'package:built_collection/built_collection.dart';
import 'package:owmflutter/api/api.dart';
import 'dart:convert';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart' as crypto;

class BaseWykopHttpClient extends BaseClient {
  final String baseUrl = 'https://a2.wykop.pl';
  final Client _inner = new Client();
  ApiSecrets _secrets;

  BaseWykopHttpClient();

  @override
  Future<StreamedResponse> send(BaseRequest request) {
    return _inner.send(request);
  }

  String generateMd5(String data) {
    var content = new Utf8Encoder().convert(data);
    var md5 = crypto.md5;
    var digest = md5.convert(content);
    return hex.encode(digest.bytes);
  }

  String signRequest(String url) {
    return generateMd5(_secrets.secret + url);
  }

  Future<dynamic> _wykopGet(String url) async {
    if (_secrets == null) {
      _secrets = await loadSecrets();
    }
    var appkey = _secrets.appkey;
    var httpResponse = await _inner.get("$url/appkey/$appkey",
        headers: {'apisign': signRequest("$url/appkey/$appkey")});
    var decoded = json.decode(httpResponse.body) as Map;
    if (decoded.containsKey("error")) {
      throw ("TODO");
    } else {
      return decoded["data"];
    }
  }

  Future<List<T>> wykopGetList<T>(Serializer<T> serializer, String url) async {
    var list = await _wykopGet(url) as List<dynamic>;
    return list.map((el) {
      return serializers.deserializeWith(serializer, el);
    }).toList();
  }

  Future<T> wykopGet<T>(Serializer<T> serializer, String url) async {
    var map = await _wykopGet(url) as Map;
    return serializers.deserializeWith(serializer, map);
  }
}

class BaseWykopClient {
  final BaseWykopHttpClient _httpClient = new BaseWykopHttpClient();

  BaseWykopClient();

  Future<BuiltList<EntryResponse>> getHot(int page) async {
    print("http://a2.wykop.pl/entries/hot/period/12/page/${page.toString()}");
    var items = await _httpClient.wykopGetList(EntryResponse.serializer,
        "http://a2.wykop.pl/entries/hot/period/12/page/${page.toString()}");
    return BuiltList.from(items);
  }
}

class WykopApi {}

class ApiSecrets {
  final String secret;
  final String appkey;
  ApiSecrets({this.secret, this.appkey});
}

Future<ApiSecrets> loadSecrets() async {
  var rawJson = await rootBundle.loadString('assets/secrets.json');
  var decoded = json.decode(rawJson);
  return ApiSecrets(
      appkey: decoded["wykop_key"], secret: decoded["wykop_secret"]);
}
