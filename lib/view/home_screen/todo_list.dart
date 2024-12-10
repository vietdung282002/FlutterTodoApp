import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_todo_app/model/enum/loading_state.dart';
import 'package:flutter_todo_app/view/widget/text_widget.dart';
import 'package:flutter_todo_app/view/widget/todo_item_widget.dart';
import 'package:flutter_todo_app/view_model/todo_list_view_model.dart';
import 'package:provider/provider.dart';

class TodoList extends StatelessWidget {
  const TodoList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async {
              await Provider.of<TodoListViewModel>(context, listen: false)
                  .fetchTodoList(refresh: true);
            },
            child: CustomScrollView(
              slivers: [
                Selector<TodoListViewModel, List?>(
                    selector: (context, viewModel) => viewModel.pendingTodos,
                    builder: (context, pendingTodos, child) {
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final todo = pendingTodos?[index];
                            return TodoItemWidget(todoItem: todo);
                          },
                          childCount: pendingTodos?.length,
                        ),
                      );
                    }),
                const SliverToBoxAdapter(
                    child: SectionTitle(title: "Completed")),
                Selector<TodoListViewModel, List?>(
                    selector: (context, viewModel) => viewModel.completedTodos,
                    builder: (context, completedTodos, child) {
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final todo = completedTodos?[index];
                            return TodoItemWidget(todoItem: todo);
                          },
                          childCount: completedTodos?.length,
                        ),
                      );
                    }),
              ],
            ),
          ),
          Consumer<TodoListViewModel>(builder: (context, viewModel, child) {
            if (viewModel.loading == LoadingState.loading) {
              return SafeArea(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
                  child: Container(
                    color: Colors.black.withOpacity(0),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          })
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextWidget(
          text: title,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ));
  }
}
