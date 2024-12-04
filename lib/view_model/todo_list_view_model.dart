import 'package:flutter/material.dart';
import 'package:flutter_todo_app/config/utils.dart';
import 'package:flutter_todo_app/model/enum/loading_state.dart';
import 'package:flutter_todo_app/model/network/api_services.dart';
import 'package:flutter_todo_app/model/todo_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoListViewModel extends ChangeNotifier {
  final ApiServices _apiServices = ApiServices();

  LoadingState _isLoading = LoadingState.idle;
  LoadingState get isLoading => _isLoading;

  List<TodoItem> _listTodo = [];
  List<TodoItem> get listTodo => _listTodo;

  Future<void> fetchTodoList({bool refresh = false}) async {
    if (_isLoading == LoadingState.loading) return;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? deviceUdid = prefs.getString('device_udid');

    if (refresh) {
      _listTodo = [];
    }
    _isLoading = LoadingState.loading;
    try {
      final todoListResponse = await _apiServices.getTodosList(deviceUdid!);

      _listTodo.addAll(todoListResponse);
      _isLoading = LoadingState.success;
    } catch (e) {
      _isLoading = LoadingState.failure;
    } finally {
      notifyListeners();
    }
  }

  Future<void> updateTodoStatus(int todoId, bool status) async {
    if (_isLoading == LoadingState.loading) return;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? deviceUdid = prefs.getString('device_udid');

    _isLoading == LoadingState.loading;

    try {
      await _apiServices.updateTodoStatus(todoId, status);
    } catch (e) {
      _isLoading = LoadingState.success;
    } finally {
      final todoListResponse = await _apiServices.getTodosList(deviceUdid!);
      updateTodos(todoListResponse);
      notifyListeners();
    }
  }

  void updateTodos(List<TodoItem> newTodos) {
    updateList(_listTodo, newTodos, (updatedList) {
      _listTodo = updatedList;
      notifyListeners();
    });
  }
}
