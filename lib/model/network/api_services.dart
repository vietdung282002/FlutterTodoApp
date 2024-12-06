import 'dart:convert';

import 'package:flutter_todo_app/config/http_config.dart';
import 'package:flutter_todo_app/config/values.dart';
import 'package:flutter_todo_app/model/network/api_urls.dart';
import 'package:flutter_todo_app/model/model_objects/todo_response.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  Future<List<TodoItem>> getTodosList(String deviceUDID) async {
    final response =
        await HttpConfig.get(ApiUrls().getTodoList(userId: deviceUDID));
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((data) => TodoItem.fromJson(data)).toList();
    } else {
      throw Exception('Failed to fetch Todo');
    }
  }

  Future<TodoItem> getTodoItem(int todoId) async {
    final response = await HttpConfig.get(
      ApiUrls().getTodoDetail(todoId: todoId),
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      List<TodoItem> todos =
          jsonData.map((data) => TodoItem.fromJson(data)).toList();
      if (todos.isNotEmpty) {
        return todos.first;
      } else {
        throw Exception('No todos available');
      }
    } else {
      throw Exception('Failed to fetch Todo');
    }
  }

  Future<http.Response> createTodo(TodoItem todo) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Prefer': 'return=minimal'
    };
    final response = await HttpConfig.post(ApiUrls().createTodo(),
        headers: headers, body: todo.toJson());
    if (response.statusCode != 201) {
      throw Exception('Failed to create Todo.');
    } else {
      return response;
    }
  }

  Future<http.Response> updateTodoStatus(int todoId, bool isComplete) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Prefer': 'return=minimal'
    };
    final body = <String, dynamic>{
      'is_complete': isComplete,
    };
    final url = ApiUrls().updateTodoStatus(todoId: todoId);
    final response = await HttpConfig.patch(url, headers: headers, body: body);
    if (response.statusCode != 204) {
      throw Exception('Failed to update Todo.');
    } else {
      return response;
    }
  }

  Future<http.Response> updateTodo(TodoItem todo) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Prefer': 'return=minimal'
    };
    final response = await HttpConfig.patch(
        ApiUrls().updateTodo(todoId: todo.todoId!),
        headers: headers,
        body: todo.toJson());
    if (response.statusCode != 204) {
      throw Exception('Failed to update Todo.');
    } else {
      return response;
    }
  }

  void printCurl({
    required String method,
    required Uri url,
    Map<String, String>? headers,
    String? body,
  }) {
    final curlCommand = StringBuffer('curl -X $method \'$url\'');

    if (headers != null) {
      headers.forEach((key, value) {
        curlCommand.write(' -H \'$key: $value\'');
      });
    }

    if (body != null && body.isNotEmpty) {
      curlCommand.write(' -d \'$body\'');
    }

    print(curlCommand.toString());
  }
}
