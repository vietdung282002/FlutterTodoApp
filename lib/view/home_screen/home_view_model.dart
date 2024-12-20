import 'package:flutter/material.dart';
import 'package:flutter_todo_app/config/shared_preferences_helper.dart';
import 'package:flutter_todo_app/config/values.dart';
import 'package:flutter_todo_app/model/enum/loading_state.dart';
import 'package:flutter_todo_app/model/enum/logged_in_status.dart';
import 'package:flutter_todo_app/model/network/api_services.dart';
import 'package:flutter_todo_app/model/model_objects/todo_item.dart';

class HomeViewModel extends ChangeNotifier {
  final ApiServices _apiServices = ApiServices();

  LoggedInStatus _isLoggedIn = LoggedInStatus.loggedIn;
  LoggedInStatus get isLoggedIn => _isLoggedIn;

  LoadingState _loading = LoadingState.idle;
  LoadingState get loading => _loading;

  List<TodoItem> _listTodo = [];
  List<TodoItem> get listTodo => _listTodo;

  List<TodoItem> get pendingTodos =>
      _listTodo.where((todo) => !todo.isComplete).toList();

  List<TodoItem> get completedTodos =>
      _listTodo.where((todo) => todo.isComplete).toList();

  Future<void> fetchTodoList({bool refresh = false}) async {
    if (_loading == LoadingState.loading) return;

    final prefs = SharedPreferencesHelper();
    final String? deviceUdid = await prefs.getString(Values.udid);

    if (refresh) {
      _listTodo = [];
    }
    _loading = LoadingState.loading;
    notifyListeners();
    try {
      final todoListResponse = await _apiServices.getTodosList(deviceUdid!);
      _listTodo.addAll(todoListResponse);

      _loading = LoadingState.success;
    } catch (e) {
      _loading = LoadingState.failure;
    } finally {
      notifyListeners();
    }
  }

  Future<void> updateTodo() async {
    if (_loading == LoadingState.loading) return;

    final prefs = SharedPreferencesHelper();
    final String? deviceUdid = await prefs.getString(Values.udid);

    _loading = LoadingState.loading;

    try {
      final todoListResponse = await _apiServices.getTodosList(deviceUdid!);
      _listTodo = todoListResponse;
      _loading = LoadingState.success;
    } catch (e) {
      _loading = LoadingState.failure;
    } finally {
      notifyListeners();
    }
  }

  Future<void> updateTodoStatus(int todoId, bool status) async {
    if (_loading == LoadingState.loading) return;

    final index = _listTodo.indexWhere((todo) => todo.todoId == todoId);
    if (index == -1) return;

    _loading == LoadingState.loading;
    notifyListeners();

    try {
      await _apiServices.updateTodoStatus(todoId, status);
      final todoListResponse = await _apiServices.getTodoItem(todoId);
      _listTodo[index] = todoListResponse;
      _loading = LoadingState.success;
    } catch (e) {
      _loading = LoadingState.failure;
    } finally {
      notifyListeners();
    }
  }

  Future<void> deleteTodo(int todoId) async {
    if (_loading == LoadingState.loading) return;

    final index = _listTodo.indexWhere((todo) => todo.todoId == todoId);
    _loading == LoadingState.loading;
    notifyListeners();

    try {
      await _apiServices.deleteTodo(todoId);
      _listTodo.removeAt(index);
      _loading = LoadingState.success;
    } catch (e) {
      _loading = LoadingState.failure;
    } finally {
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    if (_loading == LoadingState.loading) return;

    _loading == LoadingState.loading;
    notifyListeners();
    final prefs = SharedPreferencesHelper();
    await prefs.remove(Values.userID);
    _isLoggedIn = LoggedInStatus.loggedOut;
    _loading == LoadingState.success;

    _listTodo = [];
    notifyListeners();
  }
}
