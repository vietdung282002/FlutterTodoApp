import 'package:flutter/material.dart';
import 'package:flutter_todo_app/model/enum/loading_state.dart';
import 'package:flutter_todo_app/model/network/api_services.dart';
import 'package:flutter_todo_app/model/model_objects/todo_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoDetailViewModel extends ChangeNotifier {
  final ApiServices _apiServices = ApiServices();

  TodoItem _todoItem = TodoItem.empty();
  TodoItem get todoItem => _todoItem;

  LoadingState _loading = LoadingState.idle;
  LoadingState get loading => _loading;

  bool _isEditted = false;
  bool get isEditted => _isEditted;

  int? _categoryId;
  int? get categoryId => _categoryId;

  String? _date = "";
  String? get date => _date;

  String? _time = "";
  String? get time => _time;

  Future<void> fetchTodoDetail(int todoId) async {
    if (_loading == LoadingState.loading) return;

    if (todoId == -1) return;

    _loading = LoadingState.loading;

    try {
      final todoResponse = await _apiServices.getTodoItem(todoId);

      _todoItem = todoResponse;
      _date = _todoItem.formatDate();
      _time = _todoItem.formatTime();

      _loading = LoadingState.success;
    } catch (e) {
      _loading = LoadingState.failure;
    } finally {
      notifyListeners();
    }
  }

  Future<void> addTodo(
      String taskTitle, String taskNote, String deadline) async {
    if (_loading == LoadingState.loading) return;

    _loading = LoadingState.loading;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? deviceUdid = prefs.getString('device_udid');

    final newTodo = TodoItem(
        categoryId: _todoItem.categoryId!,
        time: deadline,
        isComplete: false,
        taskTitle: _todoItem.taskTitle,
        taskNote: _todoItem.taskNote,
        deviceUDID: deviceUdid!);
    try {
      await _apiServices.createTodo(newTodo);
      _isEditted = true;
      _loading = LoadingState.success;
      notifyListeners();
    } catch (e) {
      _loading = LoadingState.failure;
    } finally {}
  }

  Future<void> editTodo(
      String taskTitle, String taskNote, String deadline) async {
    if (_loading == LoadingState.loading) return;

    _loading = LoadingState.loading;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? deviceUdid = prefs.getString('device_udid');

    final newTodo = TodoItem(
        todoId: _todoItem.todoId!,
        categoryId: _todoItem.categoryId!,
        time: deadline,
        isComplete: false,
        taskTitle: _todoItem.taskTitle,
        taskNote: _todoItem.taskNote,
        deviceUDID: deviceUdid!);

    try {
      await _apiServices.updateTodo(newTodo);
      _isEditted = true;
      _loading = LoadingState.success;
      notifyListeners();
    } catch (e) {
      _loading = LoadingState.failure;
    } finally {}
  }

  void setTaskTitle(String taskTitle) {
    _todoItem.taskTitle = taskTitle;
    notifyListeners();
  }

  void setTaskNote(String taskNote) {
    _todoItem.taskNote = taskNote;
    notifyListeners();
  }

  void setDate(String date) {
    _date = date;
    notifyListeners();
  }

  void setTime(String time) {
    _time = time;
    notifyListeners();
  }

  void setCategory(int categoryId) {
    _todoItem.categoryId = categoryId;
    notifyListeners();
  }
}
