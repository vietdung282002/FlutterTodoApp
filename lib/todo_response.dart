import 'package:intl/intl.dart';

class TodoItem {
  final int category;
  final String title;
  final String time;
  bool isComplete;

  // Constructor
  TodoItem({
    required this.category,
    required this.title,
    required this.time,
    this.isComplete = false,
  });

  factory TodoItem.fromJson(Map<String, dynamic> json) {
    return TodoItem(
      category: json['category'] as int,
      title: json['title'] as String,
      time: json['time'] as String,
      isComplete: json['is_complete'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'title': title,
      'time': time,
      'is_complete': isComplete,
    };
  }

  @override
  String toString() {
    return 'TodoItem(category: $category, title: $title, time: $time, isComplete: $isComplete)';
  }

  String formatDateTime() {
    final DateTime parsedDateTime = DateTime.parse(time).toLocal();
    final DateTime now = DateTime.now();

    if (parsedDateTime.year == now.year &&
        parsedDateTime.month == now.month &&
        parsedDateTime.day == now.day) {
      return DateFormat('hh:mm a').format(parsedDateTime);
    } else {
      return DateFormat('yyyy-MM-dd hh:mm a').format(parsedDateTime);
    }
  }
}
