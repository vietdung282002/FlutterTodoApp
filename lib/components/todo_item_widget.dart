import 'package:flutter/material.dart';
import 'package:flutter_todo_app/model/enum/category.dart';
import 'package:flutter_todo_app/components/check_box_widget.dart';
import 'package:flutter_todo_app/common/colors.dart';
import 'package:flutter_todo_app/components/text_widget.dart';
import 'package:flutter_todo_app/model/entity/todo.dart';
import 'package:flutter_todo_app/view/home_screen/home_vm.dart';
import 'package:get/get.dart';

import 'category_widget.dart';

class TodoItemWidget extends StatelessWidget {
  const TodoItemWidget({super.key, required this.todoItem});

  final Todo todoItem;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildImageBasedOnStatus(todoItem.category!, todoItem.isComplete),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextWidget(
                  text: todoItem.taskTitle,
                  textStyle: TextStyle(
                    color: todoItem.isComplete
                        ? textColor.withOpacity(0.5)
                        : textColor.withOpacity(1),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    decoration: todoItem.isComplete
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                TextWidget(
                  text: todoItem.formatDateTime(),
                  textStyle: TextStyle(
                    color: textColor.withOpacity(0.7),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    decoration: todoItem.isComplete
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GetBuilder(
            init: Get.find<HomeVM>(),
            builder: (viewmodel) {
              return CheckBoxWidget(
                todoItem: todoItem,
                onTap: () {
                  viewmodel.updateTodoStatus(
                      todoItem.todoId!, !todoItem.isComplete);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildImageBasedOnStatus(ItemCategory category, bool isComplete) {
    if (isComplete) {
      return Opacity(
        opacity: 0.5,
        child: CategoryWidget(
          image: Image.asset(category.icon),
          onTap: () {},
          backgroundColor: category.backgroundColor,
          borderColor: Colors.transparent,
          borderWidth: 0,
        ),
      );
    } else {
      return CategoryWidget(
        image: Image.asset(category.icon),
        onTap: () {},
        backgroundColor: category.backgroundColor,
        borderColor: Colors.transparent,
        borderWidth: 0,
      );
    }
  }
}
