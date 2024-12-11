import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_todo_app/model/enum/loading_state.dart';
import 'package:flutter_todo_app/view/widget/text_widget.dart';
import 'package:flutter_todo_app/view/widget/todo_item_widget.dart';
import 'package:flutter_todo_app/view_model/todo_list_view_model.dart';
import 'package:provider/provider.dart';

class TodoList extends StatefulWidget {
  const TodoList({
    super.key,
  });

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final GlobalKey<SliverAnimatedListState> pendingListKey = GlobalKey();
  final GlobalKey<SliverAnimatedListState> completedListKey = GlobalKey();
  @override
  void initState() {
    super.initState();
  }

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

                          if (todo == null) return const SizedBox.shrink();

                          return Dismissible(
                            key: Key(todo.todoId
                                .toString()), // Ensure the key is unique
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) {
                              // Trigger the deletion in the ViewModel
                              Provider.of<TodoListViewModel>(context,
                                      listen: false)
                                  .deleteTodo(todo.todoId!);
                            },
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20.0),
                              child:
                                  const Icon(Icons.delete, color: Colors.white),
                            ),
                            child: TodoItemWidget(todoItem: todo),
                          );
                        },
                        childCount: pendingTodos?.length ?? 0,
                      ),
                    );
                  },
                ),
                const SliverToBoxAdapter(
                    child: SectionTitle(title: "Completed")),
                Selector<TodoListViewModel, List?>(
                    selector: (context, viewModel) => viewModel.completedTodos,
                    builder: (context, completedTodos, child) {
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final todo = completedTodos?[index];

                            if (todo == null) return const SizedBox.shrink();

                            return Dismissible(
                              key: Key(todo.todoId
                                  .toString()), // Ensure the key is unique
                              direction: DismissDirection.endToStart,
                              onDismissed: (direction) {
                                // Trigger the deletion in the ViewModel
                                Provider.of<TodoListViewModel>(context,
                                        listen: false)
                                    .deleteTodo(todo.todoId!);
                              },
                              background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20.0),
                                child: const Icon(Icons.delete,
                                    color: Colors.white),
                              ),
                              child: TodoItemWidget(todoItem: todo),
                            );
                          },
                          childCount: completedTodos?.length ?? 0,
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
