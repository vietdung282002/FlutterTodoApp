import 'package:flutter_todo_app/model/enum/category.dart';
import 'package:intl/intl.dart';

class TodoItem {
  int? todoId;
  String taskTitle;
  String? taskNote;
  ItemCategory? category;
  String time;
  bool isComplete;
  String? deviceUDID;

  // Constructor
  TodoItem({
    required this.category,
    required this.time,
    required this.isComplete,
    this.todoId,
    required this.taskTitle,
    required this.taskNote,
    this.deviceUDID,
  });

  factory TodoItem.fromJson(Map<String, dynamic> json) {
    return TodoItem(
      category: CategoryExtension.setCategory(json['category_id'] as int),
      taskTitle: json['task_title'] as String,
      time: json['time'] as String,
      isComplete: json['is_complete'] as bool,
      todoId: json['todo_id'] as int,
      taskNote: json['task_note'] as String,
      deviceUDID: json['udid'] as String,
    );
  }

  factory TodoItem.empty() {
    return TodoItem(
      todoId: null,
      taskTitle: '',
      taskNote: "",
      category: null,
      time: '',
      isComplete: false,
      deviceUDID: null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "task_title": taskTitle,
      "is_complete": isComplete,
      "task_note": taskNote ?? "",
      "category_id": category?.toInt,
      "time": time,
      "udid": deviceUDID,
    };
  }

  String formatDateTime() {
    final DateTime parsedDateTime = DateTime.parse(time).toLocal();
    final DateTime now = DateTime.now();

    if (parsedDateTime.year == now.year &&
        parsedDateTime.month == now.month &&
        parsedDateTime.day == now.day) {
      return DateFormat('hh:mm a').format(parsedDateTime);
    } else {
      return DateFormat('dd-MM-yyyy hh:mm a').format(parsedDateTime);
    }
  }

  String formatDate() {
    final DateTime parsedDateTime = DateTime.parse(time).toLocal();

    return DateFormat('dd-MM-yyyy').format(parsedDateTime);
  }

  String formatTime() {
    final DateTime parsedDateTime = DateTime.parse(time).toLocal();

    return DateFormat('hh:mm a').format(parsedDateTime);
  }

  TodoItem copyWith({
    int? todoId,
    String? taskTitle,
    String? taskNote,
    required ItemCategory category,
    String? time,
    bool? isComplete,
    String? deviceUDID,
  }) {
    return TodoItem(
      todoId: todoId ?? this.todoId,
      taskTitle: taskTitle ?? this.taskTitle,
      taskNote: taskNote ?? this.taskNote,
      category: category,
      time: time ?? this.time,
      isComplete: isComplete ?? this.isComplete,
      deviceUDID: deviceUDID ?? this.deviceUDID,
    );
  }

  @override
  String toString() {
    return 'TodoItem(todoId: $todoId, taskTitle: $taskTitle, categoryId: $category, '
        'time: ${formatDateTime()}, isComplete: $isComplete, '
        'taskNote: ${taskNote ?? "No Note"}, udid: $deviceUDID)';
  }
}
