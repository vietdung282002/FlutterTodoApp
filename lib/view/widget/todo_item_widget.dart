import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/view/detail_screen/todo_detail.dart';
import 'package:flutter_todo_app/view/widget/category_widget.dart';
import 'package:flutter_todo_app/view/widget/check_box_widget.dart';
import 'package:flutter_todo_app/view/colors.dart';
import 'package:flutter_todo_app/view/widget/text_widget.dart';
import 'package:flutter_todo_app/model/model_objects/todo_response.dart';
import 'package:flutter_todo_app/view_model/todo_list_view_model.dart';
import 'package:provider/provider.dart';

class TodoItemWidget extends StatelessWidget {
  const TodoItemWidget({super.key, required this.todoItem});

  final TodoItem todoItem;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        showCupertinoModalPopup<void>(
          context: context,
          builder: (BuildContext context) => CupertinoActionSheet(
            message: Text('Delete ${todoItem.taskTitle}'),
            actions: <CupertinoActionSheetAction>[
              CupertinoActionSheetAction(
                isDestructiveAction: true,
                onPressed: () {
                  Navigator.pop(context);
                  Provider.of<TodoListViewModel>(context, listen: false)
                      .deleteTodo(todoItem.todoId!);
                },
                child: const Text('Delete'),
              ),
            ],
          ),
        );
      },
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TodoDetail(
              todoId: todoItem.todoId!,
            ),
          ),
        );
      },
      child: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width * 0.8,
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildImageBasedOnStatus(todoItem.categoryId!, todoItem.isComplete),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextWidget(
                    text: todoItem.taskTitle,
                    textColor: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    textDecoration: todoItem.isComplete
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    opacity: todoItem.isComplete ? 0.5 : 1,
                  ),
                  TextWidget(
                    text: todoItem.formatDateTime(),
                    textColor: textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    textDecoration: todoItem.isComplete
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    opacity: 0.7,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Consumer<TodoListViewModel>(builder: (context, viewmodel, chil) {
              return CheckBoxWidget(
                todoItem: todoItem,
                onTap: () {
                  viewmodel.updateTodoStatus(
                      todoItem.todoId!, !todoItem.isComplete);
                },
              );
            }),
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
            opacity: 0.5,
            child: CategoryWidget(
              image: Image.asset("assets/category_task.png"),
              onTap: () {},
              backgroundColor: taskBackground,
              borderColor: Colors.transparent,
              borderWidth: 0,
            ),
          );
        // Opacity(
        //     opacity: 0.5, child: Image.asset("assets/category_task.png"));
        case 2:
          return Opacity(
            opacity: 0.5,
            child: CategoryWidget(
              image: Image.asset("assets/category_event.png"),
              onTap: () {},
              backgroundColor: eventBackground,
              borderColor: Colors.transparent,
              borderWidth: 0,
            ),
          );
        case 3:
          return Opacity(
            opacity: 0.5,
            child: CategoryWidget(
              image: Image.asset("assets/category_goal.png"),
              onTap: () {},
              backgroundColor: goalBackground,
              borderColor: Colors.transparent,
              borderWidth: 0,
            ),
          );
        default:
          return const SizedBox.shrink();
      }
    } else {
      switch (category) {
        case 1:
          return CategoryWidget(
            image: Image.asset("assets/category_task.png"),
            onTap: () {},
            backgroundColor: taskBackground,
            borderColor: Colors.transparent,
            borderWidth: 0,
          );
        case 2:
          return CategoryWidget(
            image: Image.asset("assets/category_event.png"),
            onTap: () {},
            backgroundColor: eventBackground,
            borderColor: Colors.transparent,
            borderWidth: 0,
          );
        case 3:
          return CategoryWidget(
            image: Image.asset("assets/category_goal.png"),
            onTap: () {},
            backgroundColor: goalBackground,
            borderColor: Colors.transparent,
            borderWidth: 0,
          );
        default:
          return const SizedBox.shrink();
      }
    }
  }
}
