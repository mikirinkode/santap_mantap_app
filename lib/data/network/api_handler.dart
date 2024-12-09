import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiHandler {
  static Future<T> get<T>({
    required String url,
    required T Function(Map<String, dynamic>) fromJson,
    required String errorMessage,
  }) async {
    debugPrint("[GET] url: $url");
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var body = json.decode(response.body);
        return fromJson(body);
      } else {
        print(
            "ApiHandler::Failed to get data. Status code: ${response.statusCode}");
        debugPrint("ApiHandler::Failed to get data. body: ${response.body}");
        return Future.error(errorMessage);
      }
    } catch (e) {
      debugPrint("ApiHandler::Failed to parse data. error: $e");
      return Future.error(e);
    }
  }
}
