import 'package:flutter/material.dart';
import 'package:flutter_todo_app/model/enum/loading_state.dart';
import 'package:flutter_todo_app/model/network/api_services.dart';
import 'package:flutter_todo_app/model/todo_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoDetailViewModel extends ChangeNotifier {
  final ApiServices _apiServices = ApiServices();

  TodoItem? _todoItem;
  TodoItem? get todoItem => _todoItem;

  LoadingState _loading = LoadingState.idle;
  LoadingState get loading => _loading;

  String? _taskTitle;
  String? get taskTitle => _taskTitle;

  int? _categoryId;
  int? get categotyId => _categoryId;

  String? _date;
  String? get date => _date;

  String? _time;
  String? get time => _time;

  String? _taskNote;
  String? get taskNote => _taskNote;

  Future<void> fetchTodoDetail(int todoId) async {
    if (_loading == LoadingState.loading) return;

    if (todoId == -1) return;

    _loading = LoadingState.loading;

    try {
      final todoResponse = await _apiServices.getTodoItem(todoId);
      _todoItem = todoResponse;
      _taskTitle = _todoItem?.taskTitle;
      _date = _todoItem?.formatDate();
      _time = _todoItem?.formatTime();
      _categoryId = todoItem?.categoryId;
      _taskNote = _todoItem?.taskNote;

      _loading = LoadingState.success;
    } catch (e) {
      _loading = LoadingState.failure;
    } finally {
      notifyListeners();
    }
  }

  Future<void> addTodo(String taskTitle, String taskNote, String createAt,
      String deadline) async {
    if (_loading == LoadingState.loading) return;

    _loading = LoadingState.loading;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? deviceUdid = prefs.getString('device_udid');
    try {
      await _apiServices.createTodo(
          createAt, taskTitle, taskNote, _categoryId!, deadline, deviceUdid!);
      _loading = LoadingState.success;
    } catch (e) {
      _loading = LoadingState.failure;
    } finally {}
  }

  Future<void> editTodo(
      String taskTitle, String taskNote, String deadline) async {
    if (_loading == LoadingState.loading) return;

    _loading = LoadingState.loading;

    try {
      await _apiServices.updateTodo(
          todoItem!.todoId, taskTitle, taskNote, _categoryId!, deadline);
      _loading = LoadingState.success;
    } catch (e) {
      _loading = LoadingState.failure;
    } finally {}
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
    _categoryId = categoryId;
    notifyListeners();
  }
}