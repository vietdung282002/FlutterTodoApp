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
}
