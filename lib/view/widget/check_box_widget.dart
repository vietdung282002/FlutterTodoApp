import 'package:flutter/material.dart';
import 'package:flutter_todo_app/model/model_objects/todo_item.dart';

class CheckBoxWidget extends StatelessWidget {
  const CheckBoxWidget({
    super.key,
    required this.todoItem,
    this.onTap,
  });

  final TodoItem todoItem;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: todoItem.isComplete
          ? Image.asset("assets/check_box_true.png")
          : Image.asset("assets/check_box_false.png"),
    );
  }
}
