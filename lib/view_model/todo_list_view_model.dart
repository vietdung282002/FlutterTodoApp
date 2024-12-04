import 'package:flutter/material.dart';
import 'package:flutter_todo_app/model/network/api_services.dart';
import 'package:flutter_todo_app/model/todo_response.dart';

class TodoListViewModel extends ChangeNotifier {
  final ApiServices _apiServices = ApiServices();
  bool _isLoading = false;

  List<TodoItem> _listTodo = [];
  List<TodoItem> get listTodo => _listTodo;

  Future<void> fetchTodoList({bool refresh = false}) async {
    if (_isLoading) return;

    if (refresh) {
      _listTodo = [];
    }
    _isLoading = true;
    try {
      final todoListResponse = await _apiServices.getTodosList();

      listTodo.addAll(todoListResponse);
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateTodoStatus(int todoId, bool status) async {
    if (_isLoading) return;

    _isLoading = true;

    try {
      await _apiServices.updateTodoStatus(todoId, status);
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      fetchTodoList(refresh: true);
      notifyListeners();
    }
  }
}
