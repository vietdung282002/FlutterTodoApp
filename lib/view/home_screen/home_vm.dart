import 'package:flutter_todo_app/network/api_services.dart';
import 'package:get/get.dart';

import '../../common/values.dart';
import '../../config/shared_preferences_helper.dart';
import '../../model/entity/todo.dart';
import '../../model/enum/loading_state.dart';
import '../../model/enum/logged_in_status.dart';

class HomeVM extends GetxController {
  final ApiServices _apiServices = Get.find();

  LoggedInStatus _isLoggedIn = LoggedInStatus.loggedIn;
  LoggedInStatus get isLoggedIn => _isLoggedIn;

  LoadingState _loading = LoadingState.idle;
  LoadingState get loading => _loading;

  List<Todo> _listTodo = [];
  List<Todo> get listTodo => _listTodo;

  List<Todo> get pendingTodos =>
      _listTodo.where((todo) => !todo.isComplete).toList();

  List<Todo> get completedTodos =>
      _listTodo.where((todo) => todo.isComplete).toList();

  Future<void> fetchTodoList({bool refresh = false}) async {
    if (_loading == LoadingState.loading) return;

    final prefs = SharedPreferencesHelper();
    final String? deviceUdid = await prefs.getString(Values.udid);

    if (refresh) {
      _listTodo = [];
    }
    _loading = LoadingState.loading;
    update();
    try {
      final todoListResponse = await _apiServices.getTodosList(deviceUdid!);
      _listTodo.addAll(todoListResponse);

      _loading = LoadingState.success;
    } catch (e) {
      _loading = LoadingState.failure;
    } finally {
      update();
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
      update();
    }
  }

  Future<void> updateTodoStatus(int todoId, bool status) async {
    if (_loading == LoadingState.loading) return;

    final index = _listTodo.indexWhere((todo) => todo.todoId == todoId);
    if (index == -1) return;

    _loading == LoadingState.loading;
    update();

    try {
      await _apiServices.updateTodoStatus(todoId, status);
      final todoListResponse = await _apiServices.getTodoItem(todoId);
      _listTodo[index] = todoListResponse;
      _loading = LoadingState.success;
    } catch (e) {
      _loading = LoadingState.failure;
    } finally {
      update();
    }
  }

  Future<void> deleteTodo(int todoId) async {
    if (_loading == LoadingState.loading) return;

    final index = _listTodo.indexWhere((todo) => todo.todoId == todoId);
    _loading == LoadingState.loading;
    update();

    try {
      await _apiServices.deleteTodo(todoId);
      _listTodo.removeAt(index);
      _loading = LoadingState.success;
    } catch (e) {
      _loading = LoadingState.failure;
    } finally {
      update();
    }
  }

  Future<void> signOut() async {
    if (_loading == LoadingState.loading) return;

    _loading == LoadingState.loading;
    update();
    final prefs = SharedPreferencesHelper();
    await prefs.remove(Values.userID);
    _isLoggedIn = LoggedInStatus.loggedOut;
    _loading == LoadingState.success;

    _listTodo = [];
    update();
  }
}
