import 'package:get/get.dart';

import '../../common/shared_preferences_helper.dart';
import '../../common/values.dart';
import '../../model/entity/todo.dart';
import '../../model/enum/category.dart';
import '../../model/enum/loading_state.dart';
import '../../network/api_services.dart';

class TodoDetailVM extends GetxController {
  final ApiServices _apiServices = Get.find();

  Todo _todoItem = Todo.empty();
  Todo get todoItem => _todoItem;

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
      update();
    }
  }

  Future<void> addTodo(
      String taskTitle, String taskNote, String deadline) async {
    if (_loading == LoadingState.loading) return;

    _loading = LoadingState.loading;
    update();

    final prefs = SharedPreferencesHelper();
    final String? deviceUdid = await prefs.getString(Values.udid);
    final String? userId = await prefs.getString(Values.userID);

    final newTodo = Todo(
      category: _todoItem.category!,
      time: deadline,
      isComplete: false,
      taskTitle: _todoItem.taskTitle,
      taskNote: _todoItem.taskNote,
      deviceUDID: deviceUdid!,
      userId: userId,
    );
    try {
      await _apiServices.createTodo(newTodo);
      _isEditted = true;
      _loading = LoadingState.success;
      update();
    } catch (e) {
      _loading = LoadingState.failure;
    } finally {}
  }

  Future<void> editTodo(
      String taskTitle, String taskNote, String deadline) async {
    if (_loading == LoadingState.loading) return;

    _loading = LoadingState.loading;
    update();

    final prefs = SharedPreferencesHelper();
    final String? deviceUdid = await prefs.getString(Values.udid);
    final String? userId = await prefs.getString(Values.userID);

    final newTodo = Todo(
      todoId: _todoItem.todoId!,
      category: _todoItem.category!,
      time: deadline,
      isComplete: false,
      taskTitle: _todoItem.taskTitle,
      taskNote: _todoItem.taskNote,
      deviceUDID: deviceUdid!,
      userId: userId,
    );

    try {
      await _apiServices.updateTodo(newTodo);
      _isEditted = true;
      _loading = LoadingState.success;
      update();
    } catch (e) {
      _loading = LoadingState.failure;
    } finally {}
  }

  void setTaskTitle(String taskTitle) {
    _todoItem.taskTitle = taskTitle;
    update();
  }

  void setTaskNote(String taskNote) {
    _todoItem.taskNote = taskNote;
    update();
  }

  void setDate(String date) {
    _date = date;
    update();
  }

  void setTime(String time) {
    _time = time;
    update();
  }

  void setCategory(ItemCategory categoryId) {
    _todoItem.category = categoryId;
    update();
  }
}
