import 'package:flutter/material.dart';
import 'package:flutter_todo_app/model/enum/loading_state.dart';
import 'package:flutter_todo_app/view/widget/todo_item_widget.dart';
import 'package:flutter_todo_app/model/todo_response.dart';
import 'package:flutter_todo_app/view_model/todo_list_view_model.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';

class TodoList extends StatelessWidget {
  const TodoList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoListViewModel>(builder: (context, viewModel, child) {
      if (viewModel.loading == LoadingState.failure) {
        viewModel.fetchTodoList(refresh: true);
      }
      return RefreshIndicator(
        onRefresh: () async {
          await viewModel.fetchTodoList(refresh: true);
        },
        child: GroupedListView<TodoItem, String>(
          physics: const AlwaysScrollableScrollPhysics(),
          elements: viewModel.listTodo,
          groupBy: (todo) => !todo.isComplete ? 'Pending' : 'Completed',
          groupSeparatorBuilder: (String group) {
            if (group == 'Pending') {
              return const SizedBox.shrink();
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                group,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          },
          itemBuilder: (context, TodoItem todo) {
            return Padding(
              padding: const EdgeInsets.only(top: 12, left: 16.0, right: 12.0),
              child: TodoItemWidget(todoItem: todo),
            );
          },
          // groupComparator: (group1, group2) => group1 == 'Pending' ? -1 : 1,
          order: GroupedListOrder.DESC,
        ),
      );
    });
  }
}
