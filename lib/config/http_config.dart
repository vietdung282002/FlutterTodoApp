import 'dart:convert';
import 'package:flutter_todo_app/config/values.dart';
import 'package:http/http.dart' as http;

class HttpConfig {
  static const String baseUrl = Values.baseUrls;
  static Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'apikey': Values.apiKey,
  };

  static Future<http.Response> post(
    Uri apiUrls, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    final uri = apiUrls;
    final mergedHeaders = {...defaultHeaders, if (headers != null) ...headers};
    return await http.post(uri, headers: mergedHeaders, body: jsonEncode(body));
  }

  static Future<http.Response> get(
    Uri apiUrls, {
    Map<String, String>? headers,
  }) async {
    final uri = apiUrls;
    final mergedHeaders = {...defaultHeaders, if (headers != null) ...headers};

    return await http.get(uri, headers: mergedHeaders);
  }

  static Future<http.Response> patch(
    Uri apiUrls, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    final uri = apiUrls;
    final mergedHeaders = {...defaultHeaders, if (headers != null) ...headers};
    return await http.patch(uri,
        headers: mergedHeaders, body: jsonEncode(body));
  }

  static Future<http.Response> delete(
    Uri apiUrls, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    final uri = apiUrls;
    final mergedHeaders = {...defaultHeaders, if (headers != null) ...headers};
    return await http.delete(uri, headers: mergedHeaders);
  }
}
