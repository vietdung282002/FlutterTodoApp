import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_todo_app/model/enum/loading_state.dart';
import 'package:flutter_todo_app/view/detail_screen/todo_detail.dart';
import 'package:flutter_todo_app/view/widget/text_widget.dart';
import 'package:flutter_todo_app/view/widget/todo_item_widget.dart';
import 'package:flutter_todo_app/view_model/todo_list_view_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TodoList extends StatefulWidget {
  const TodoList({
    super.key,
  });

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
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
                    return todoSection(pendingTodos);
                  },
                ),
                SliverToBoxAdapter(
                  child: Consumer<TodoListViewModel>(
                      builder: (context, viewModel, child) {
                    if (viewModel.loading == LoadingState.loading) {
                      return const SizedBox.shrink();
                    }

                    return sectionTitle(title: "Completed");
                  }),
                ),
                Selector<TodoListViewModel, List?>(
                    selector: (context, viewModel) => viewModel.completedTodos,
                    builder: (context, completedTodos, child) {
                      return todoSection(completedTodos);
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

  Widget todoSection(List<dynamic>? todos) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final todo = todos?[index];

          if (todo == null) return const SizedBox.shrink();
          bool isFirst = index == 0;
          bool isLast = index == (todos?.length ?? 1) - 1;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 1),
            child: Dismissible(
              key: Key(todo.todoId.toString()), // Ensure the key is unique
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                // Trigger the deletion in the ViewModel
                Provider.of<TodoListViewModel>(context, listen: false)
                    .deleteTodo(todo.todoId!);
              },
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20.0),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TodoDetail(
                        todoId: todo.todoId,
                      ),
                    ),
                  );
                },
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft:
                            isFirst ? const Radius.circular(16.0) : Radius.zero,
                        topRight:
                            isFirst ? const Radius.circular(16.0) : Radius.zero,
                        bottomLeft:
                            isLast ? const Radius.circular(16.0) : Radius.zero,
                        bottomRight:
                            isLast ? const Radius.circular(16.0) : Radius.zero,
                      ),
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: 90,
                    child: TodoItemWidget(todoItem: todo)),
              ),
            ),
          );
        },
        childCount: todos?.length ?? 0,
      ),
    );
  }

  Widget sectionTitle({required String title}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextWidget(
        text: title,
        textStyle: GoogleFonts.inter(
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
