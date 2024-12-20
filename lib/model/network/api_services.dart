import 'dart:convert';
import 'package:flutter_todo_app/config/http_config.dart';
import 'package:flutter_todo_app/config/shared_preferences_helper.dart';
import 'package:flutter_todo_app/config/values.dart';
import 'package:flutter_todo_app/model/model_objects/authentication_body.dart';
import 'package:flutter_todo_app/model/model_objects/authentication_response.dart';
import 'package:flutter_todo_app/model/network/api_urls.dart';
import 'package:flutter_todo_app/model/model_objects/todo_item.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  final prefs = SharedPreferencesHelper();

  Future<AuthenticationResponse> signUp(AuthenticationBody authRequest) async {
    final response =
        await HttpConfig.post(ApiUrls().signUp(), body: authRequest.toJson());
    if (response.statusCode != 200) {
      throw Exception('Failed to Sign up.');
    } else {
      dynamic jsonData = json.decode(response.body);
      return AuthenticationResponse.fromJson(jsonData);
    }
  }

  Future<AuthenticationResponse> login(AuthenticationBody authBody) async {
    final response = await HttpConfig.post(
      ApiUrls().login(),
      body: authBody.toJson(),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to Login.');
    } else {
      dynamic jsonData = json.decode(response.body);
      return AuthenticationResponse.fromJson(jsonData);
    }
  }

  Future<List<TodoItem>> getTodosList(String deviceUDID) async {
    final String? userToken = await prefs.getString(Values.accessToken);
    final headers = <String, String>{
      'Prefer': 'return=minimal',
      'Authorization': 'Bearer $userToken',
    };
    final response = await HttpConfig.get(
      ApiUrls().getTodoList(udid: deviceUDID),
      headers: headers,
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((data) => TodoItem.fromJson(data)).toList();
    } else {
      throw Exception('Failed to fetch Todo');
    }
  }

  Future<TodoItem> getTodoItem(int todoId) async {
    final String? userToken = await prefs.getString(Values.accessToken);
    final headers = <String, String>{
      'Prefer': 'return=minimal',
      'Authorization': 'Bearer $userToken',
    };
    final response = await HttpConfig.get(
      ApiUrls().getTodoDetail(todoId: todoId),
      headers: headers,
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
    final String? userToken = await prefs.getString(Values.accessToken);
    final headers = <String, String>{
      'Prefer': 'return=minimal',
      'Authorization': 'Bearer $userToken',
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
    final String? userToken = await prefs.getString(Values.accessToken);
    final headers = <String, String>{
      'Prefer': 'return=minimal',
      'Authorization': 'Bearer $userToken',
    };
    final body = <String, dynamic>{
      'is_complete': isComplete,
    };
    final response = await HttpConfig.patch(
        ApiUrls().updateTodoStatus(todoId: todoId),
        headers: headers,
        body: body);

    if (response.statusCode != 204) {
      throw Exception('Failed to update Todo.');
    } else {
      return response;
    }
  }

  Future<http.Response> updateTodo(TodoItem todo) async {
    final String? userToken = await prefs.getString(Values.accessToken);
    final headers = <String, String>{
      'Prefer': 'return=minimal',
      'Authorization': 'Bearer $userToken',
    };
    final response = await HttpConfig.patch(
      ApiUrls().updateTodo(todoId: todo.todoId!),
      headers: headers,
      body: todo.toJson(),
    );
    if (response.statusCode != 204) {
      throw Exception('Failed to update Todo.');
    } else {
      return response;
    }
  }

  Future<http.Response> deleteTodo(
    int todoId,
  ) async {
    final String? userToken = await prefs.getString(Values.accessToken);
    final headers = <String, String>{
      'Authorization': 'Bearer $userToken',
    };
    final response = await HttpConfig.delete(
      headers: headers,
      ApiUrls().deleteTodo(todoId: todoId),
    );
    if (response.statusCode != 204) {
      throw Exception('Failed to delete Todo.');
    } else {
      return response;
    }
  }
}
