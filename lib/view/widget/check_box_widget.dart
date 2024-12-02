import 'package:flutter/material.dart';
import 'package:flutter_todo_app/todo_response.dart';

class CheckBoxWidget extends StatelessWidget {
  const CheckBoxWidget({
    super.key,
    required this.todoItem,
  });

  final TodoItem todoItem;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {},
        icon: todoItem.isComplete
            ? Image.asset("assets/CheckBoxTrue.png")
            : Image.asset("assets/CheckBoxFalse.png"));
  }
}
