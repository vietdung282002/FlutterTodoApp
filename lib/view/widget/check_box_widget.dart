import 'package:flutter/material.dart';
import 'package:flutter_todo_app/model/todo_response.dart';

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
            ? Image.asset("assets/CheckBoxTrue.png")
            : Image.asset("assets/CheckBoxFalse.png"));
  }
}
