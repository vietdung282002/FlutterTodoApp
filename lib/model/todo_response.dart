import 'package:intl/intl.dart';

class TodoItem {
  final int todoId;
  final String createAt;
  final String taskTitle;
  final String? taskNote;
  final int categoryId;
  final String time;
  final bool isComplete;
  final String userId;

  // Constructor
  TodoItem(
      {required this.categoryId,
      required this.time,
      required this.isComplete,
      required this.todoId,
      required this.createAt,
      required this.taskTitle,
      required this.taskNote,
      required this.userId});

  factory TodoItem.fromJson(Map<String, dynamic> json) {
    return TodoItem(
      categoryId: json['category_id'] as int,
      taskTitle: json['task_title'] as String,
      time: json['time'] as String,
      isComplete: json['is_complete'] as bool,
      todoId: json['todo_id'] as int,
      createAt: json['created_at'] as String,
      taskNote: json['task_note'] as String,
      userId: json['user_id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "todo_id": todoId,
      "created_at": createAt,
      "task_title": taskTitle,
      "is_complete": isComplete,
      "task_note": taskNote ?? "",
      "category_id": categoryId,
      "time": time,
      "user_id": userId
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

  @override
  String toString() {
    return 'TodoItem(todoId: $todoId, taskTitle: $taskTitle, categoryId: $categoryId, '
        'time: ${formatDateTime()}, isComplete: $isComplete, '
        'taskNote: ${taskNote ?? "No Note"}, userId: $userId)';
  }
}
