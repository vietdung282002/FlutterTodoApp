import 'dart:convert';

import 'package:flutter_todo_app/config/values.dart';
import 'package:flutter_todo_app/model/network/api_urls.dart';
import 'package:flutter_todo_app/model/todo_response.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  Future<List<TodoItem>> getTodosList() async {
    final response = await http.get(
      ApiUrls().getTodoList(),
      headers: <String, String>{
        'apikey': Values.apiKey,
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((data) => TodoItem.fromJson(data)).toList();
    } else {
      throw Exception('Failed to fetch Todo');
    }
  }

  Future<TodoItem> getTodoItem(int todoId) async {
    final response = await http.get(
      ApiUrls().getTodoDetail(todoId: todoId),
      headers: <String, String>{
        'apikey': Values.apiKey,
      },
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

  Future<http.Response> createTodo(String createAt, String taskTitle,
      String taskNote, int categoryId, String time, String userId) async {
    final response = await http.post(
      ApiUrls().createTodo(),
      headers: <String, String>{
        'apikey': Values.apiKey,
        'Content-Type': 'application/json',
        'Prefer': 'return=minimal'
      },
      body: jsonEncode(<String, dynamic>{
        'created_at': createAt,
        'task_title': taskTitle,
        'is_complete': false,
        'task_note': taskNote,
        'category_id': categoryId,
        'time': time,
        'user_id': userId
      }),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create Todo.');
    } else {
      return response;
    }
  }

  Future<http.Response> updateTodoStatus(int todoId, bool isComplete) async {
    final response = await http.patch(
      ApiUrls().updateTodoStatus(todoId: todoId),
      headers: <String, String>{
        'apikey': Values.apiKey,
        'Content-Type': 'application/json',
        'Prefer': 'return=minimal'
      },
      body: jsonEncode(<String, dynamic>{
        'is_complete': isComplete,
      }),
    );
    if (response.statusCode != 204) {
      throw Exception('Failed to update Todo.');
    } else {
      return response;
    }
  }

  Future<http.Response> updateTodo(int todoId, String taskTitle,
      String taskNote, int categoryId, String time) async {
    final response = await http.patch(
      ApiUrls().updateTodo(todoId: todoId),
      headers: <String, String>{
        'apikey': Values.apiKey,
        'Content-Type': 'application/json',
        'Prefer': 'return=minimal'
      },
      body: jsonEncode(<String, dynamic>{
        'task_title': taskTitle,
        'is_complete': false,
        'task_note': taskNote,
        'category_id': categoryId,
        'time': time,
      }),
    );
    if (response.statusCode != 204) {
      throw Exception('Failed to update Todo.');
    } else {
      return response;
    }
  }
}
