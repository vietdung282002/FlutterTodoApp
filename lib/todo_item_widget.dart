import 'package:flutter/material.dart';
import 'package:flutter_todo_app/check_box_widget.dart';
import 'package:flutter_todo_app/colors.dart';
import 'package:flutter_todo_app/text_widget.dart';
import 'package:flutter_todo_app/todo_response.dart';

class TodoItemWidget extends StatelessWidget {
  const TodoItemWidget({super.key, required this.todoItem});

  final TodoItem todoItem;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(todoItem.title);
      },
      child: SizedBox(
        width: 700,
        height: 70,
        child: Row(
          children: [
            _buildImageBasedOnStatus(todoItem.category, todoItem.isComplete),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextWidget(
                    text: todoItem.title,
                    textColor: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    isComplete: todoItem.isComplete ? true : false,
                  ),
                  TextWidget(
                    text: todoItem.time.toString(),
                    textColor: textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    isComplete: todoItem.isComplete ? true : false,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            CheckBoxWidget(todoItem: todoItem),
            // Image.asset("assets/CheckBoxFalse.png"),
          ],
        ),
      ),
    );
  }

  Widget _buildImageBasedOnStatus(int category, bool isComplete) {
    if (isComplete) {
      switch (category) {
        case 1:
          return Opacity(
              opacity: 0.5, child: Image.asset("assets/CategoryTask.png"));
        case 2:
          return Opacity(
              opacity: 0.5, child: Image.asset("assets/CategoryEvent.png"));
        case 3:
          return Opacity(
              opacity: 0.5, child: Image.asset("assets/CategoryGoal.png"));
        default:
          return const SizedBox.shrink();
      }
    } else {
      switch (category) {
        case 1:
          return Image.asset("assets/CategoryTask.png");
        case 2:
          return Image.asset("assets/CategoryEvent.png");
        case 3:
          return Image.asset("assets/CategoryGoal.png");
        default:
          return const SizedBox.shrink();
      }
    }
  }
}
