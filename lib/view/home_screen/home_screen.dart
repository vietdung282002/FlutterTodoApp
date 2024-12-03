import 'package:flutter/material.dart';
import 'package:flutter_todo_app/view/widget/button_widget.dart';
import 'package:flutter_todo_app/view/colors.dart';
import 'package:flutter_todo_app/view/widget/text_widget.dart';
import 'package:flutter_todo_app/view/home_screen/todo_list.dart';
import 'package:flutter_todo_app/model/todo_response.dart';
import 'package:flutter_todo_app/view_model/todo_list_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<TodoItem> todoList = [
    TodoItem(
      todoId: 1,
      createAt: "2024-12-01T10:00:00.000Z",
      taskTitle: "Buy groceries",
      taskNote: "Remember to buy milk and eggs",
      categoryId: 1,
      time: "2024-12-02T06:17:44.783485+00:00",
      isComplete: false,
      userId: "user1",
    ),
    TodoItem(
      todoId: 2,
      createAt: "2024-12-01T11:00:00.000Z",
      taskTitle: "Morning workout",
      taskNote: null,
      categoryId: 2,
      time: "2024-12-02T07:30:00.000Z",
      isComplete: true,
      userId: "user2",
    ),
    TodoItem(
      todoId: 3,
      createAt: "2024-12-01T12:00:00.000Z",
      taskTitle: "Project meeting",
      taskNote: "Prepare slides for the presentation",
      categoryId: 3,
      time: "2024-12-03T09:00:00.000Z",
      isComplete: false,
      userId: "user3",
    ),
    TodoItem(
      todoId: 4,
      createAt: "2024-12-01T13:00:00.000Z",
      taskTitle: "Call with client",
      taskNote: null,
      categoryId: 3,
      time: "2024-12-02T15:00:00.000Z",
      isComplete: false,
      userId: "user4",
    ),
  ];
  final TodoListViewModel vm = TodoListViewModel();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: backgroundColor,
            height: screenHeight * 222 / 844,
          ),
          SafeArea(
              child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Column(
              children: [
                const Center(
                    child: TextWidget(
                        text: "October 20, 2022",
                        textColor: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600)),
                const Padding(
                  padding: EdgeInsets.only(top: 24),
                  child: Center(
                    child: TextWidget(
                      text: "My Todo List",
                      textColor: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 16),
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                        child: TodoList(todoList: todoList)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: ButtonWidget(
                    onTap: () {
                      Navigator.pushNamed(context, '/detail', arguments: -1);
                    },
                    screenWidth: screenWidth,
                    text: "Add New Task",
                  ),
                )
              ],
            ),
          ))
        ],
      ),
    );
  }
}
