import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_todo_app/config/app_text_style.dart';
import 'package:flutter_todo_app/config/utils.dart';
import 'package:flutter_todo_app/model/enum/loading_state.dart';
import 'package:flutter_todo_app/model/enum/logged_in_status.dart';
import 'package:flutter_todo_app/view/detail_screen/todo_detail.dart';
import 'package:flutter_todo_app/view/home_screen/home_view_model.dart';
import 'package:flutter_todo_app/view/log_in_screen/log_in_screen.dart';
import 'package:flutter_todo_app/view/widget/button_widget.dart';
import 'package:flutter_todo_app/config/colors.dart';
import 'package:flutter_todo_app/view/widget/text_widget.dart';
import 'package:flutter_todo_app/view/widget/todo_item_widget.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeViewModel(),
      child: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<HomeViewModel>(context, listen: false).fetchTodoList();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: backgroundColor2,
      body: Stack(
        children: [
          _buildBackground(screenHeight, screenWidth),
          _buildLogoutButton(screenWidth, context),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Column(
                children: [
                  _buildDateTitle(),
                  _buildCaption(),
                  _buildTodoList(context),
                  _buildAddNewTaskButton(context, screenWidth)
                ],
              ),
            ),
          ),
          _buildLogInState()
        ],
      ),
    );
  }

  Widget _buildCaption() {
    return const Padding(
      padding: EdgeInsets.only(top: 24),
      child: Center(
        child: TextWidget(
          text: "My Todo List",
          textStyle: AppTextStyle.caption,
        ),
      ),
    );
  }

  Widget _buildDateTitle() {
    return Center(
      child: TextWidget(
        text: AppUtils().formatCurrentDate(),
        textStyle: AppTextStyle.title1,
      ),
    );
  }

  Widget _buildLogoutButton(double screenWidth, BuildContext context) {
    return Positioned(
      left: screenWidth * 0.85,
      top: 16,
      child: IconButton(
        icon: const Icon(Icons.logout),
        color: Colors.white,
        iconSize: 30,
        onPressed: () {
          Provider.of<HomeViewModel>(context, listen: false).signOut();
        },
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
    );
  }

  Widget _buildBackground(double screenHeight, double screenWidth) {
    return Stack(
      children: [
        Container(
          color: backgroundColor,
          height: screenHeight * 222 / 844,
        ),
        Positioned(
            right: screenWidth * 0.7,
            top: screenWidth * 0.2,
            child: Image.asset('assets/ellipse_1.png')),
        Positioned(
            left: screenWidth * 0.85,
            top: 0,
            child: Image.asset('assets/ellipse_2.png')),
      ],
    );
  }

  Widget _buildTodoList(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 16),
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Stack(
            children: [
              RefreshIndicator(
                onRefresh: () async {
                  await Provider.of<HomeViewModel>(context, listen: false)
                      .fetchTodoList(refresh: true);
                },
                child: CustomScrollView(
                  slivers: [
                    Selector<HomeViewModel, List?>(
                      selector: (context, viewModel) => viewModel.pendingTodos,
                      builder: (context, pendingTodos, child) {
                        return _buildTodoSection(pendingTodos);
                      },
                    ),
                    SliverToBoxAdapter(
                      child: Consumer<HomeViewModel>(
                        builder: (context, viewModel, child) {
                          if (viewModel.loading != LoadingState.loading &&
                              viewModel.listTodo.isNotEmpty) {
                            return _buildSectionTitle(title: "Completed");
                          }
                          if (viewModel.loading == LoadingState.loading) {
                            return const SizedBox.shrink();
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    Selector<HomeViewModel, List?>(
                      selector: (context, viewModel) =>
                          viewModel.completedTodos,
                      builder: (context, completedTodos, child) {
                        return _buildTodoSection(completedTodos);
                      },
                    ),
                  ],
                ),
              ),
              _buildLoadingState()
            ],
          ),
        ),
      ),
    );
  }

  Padding _buildAddNewTaskButton(BuildContext context, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: ButtonWidget(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TodoDetail(todoId: -1),
            ),
          );
        },
        width: screenWidth,
        text: "Add New Task",
        textStyle: AppTextStyle.buttonStyle,
      ),
    );
  }

  Widget _buildLogInState() {
    return Consumer<HomeViewModel>(
      builder: (context, viewModel, child) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) {
            if (viewModel.isLoggedIn == LoggedInStatus.loggedOut) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LogIn()),
              );
            }
          },
        );
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildLoadingState() {
    return Consumer<HomeViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.loading == LoadingState.loading) {
          return SafeArea(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
              child: Container(
                color: Colors.transparent,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildTodoSection(List<dynamic>? todos) {
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
                Provider.of<HomeViewModel>(context, listen: false)
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

  Widget _buildSectionTitle({required String title}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextWidget(
        text: title,
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
