import 'dart:ui';
import 'package:flutter_todo_app/config/colors.dart';

enum ItemCategory {
  task,
  event,
  goal,
}

extension CategoryExtension on ItemCategory {
  static ItemCategory setCategory(int value) {
    switch (value) {
      case 1:
        return ItemCategory.task;
      case 2:
        return ItemCategory.event;
      case 3:
        return ItemCategory.goal;
      default:
        throw ArgumentError('Invalid value for Category: $value');
    }
  }

  String get icon {
    switch (this) {
      case ItemCategory.task:
        return "assets/category_task.png"; // Task icon
      case ItemCategory.event:
        return "assets/category_event.png"; // Event icon
      case ItemCategory.goal:
        return "assets/category_goal.png"; // Goal icon
    }
  }

  Color get backgroundColor {
    switch (this) {
      case ItemCategory.task:
        return taskBackground; // Task icon
      case ItemCategory.event:
        return eventBackground; // Event icon
      case ItemCategory.goal:
        return goalBackground; // Goal icon
    }
  }

  int get toInt {
    switch (this) {
      case ItemCategory.task:
        return 1;
      case ItemCategory.event:
        return 2;
      case ItemCategory.goal:
        return 3;
    }
  }
}
