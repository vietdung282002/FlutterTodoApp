import 'dart:convert';
import 'package:flutter_todo_app/common/http_config.dart';
import 'package:flutter_todo_app/config/shared_preferences_helper.dart';
import 'package:flutter_todo_app/common/values.dart';
import 'package:flutter_todo_app/model/body/authentication_body.dart';
import 'package:flutter_todo_app/model/response/authentication_response.dart';
import 'package:flutter_todo_app/network/api_urls.dart';
import 'package:flutter_todo_app/model/entity/todo.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ApiServices extends GetxService {
  Future<ApiServices> init() async{
    return this;
  }

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

  Future<List<Todo>> getTodosList(String deviceUDID) async {
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
      return jsonData.map((data) => Todo.fromJson(data)).toList();
    } else {
      throw Exception('Failed to fetch Todo');
    }
  }

  Future<Todo> getTodoItem(int todoId) async {
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
      List<Todo> todos =
          jsonData.map((data) => Todo.fromJson(data)).toList();
      if (todos.isNotEmpty) {
        return todos.first;
      } else {
        throw Exception('No todos available');
      }
    } else {
      throw Exception('Failed to fetch Todo');
    }
  }

  Future<http.Response> createTodo(Todo todo) async {
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

  Future<http.Response> updateTodo(Todo todo) async {
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
