import 'package:flutter/material.dart';
import 'package:flutter_todo_app/view/widget/button_widget.dart';
import 'package:flutter_todo_app/view/colors.dart';
import 'package:flutter_todo_app/view/widget/text_widget.dart';
import 'package:flutter_todo_app/view/home_screen/todo_list.dart';
import 'package:flutter_todo_app/todo_response.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<TodoItem> todoList = [
    TodoItem(
      category: 1,
      title: "Finish project report",
      time: "2024-12-02T06:17:44.783485+00:00",
      isComplete: false,
    ),
    TodoItem(
      category: 1,
      title: "Buy groceries",
      time: "2024-12-02T06:17:44.783485+00:00",
      isComplete: true,
    ),
    TodoItem(
      category: 2,
      title: "Complete Flutter tutorial",
      time: "2024-12-02T06:17:44.783485+00:00",
      isComplete: false,
    ),
    TodoItem(
      category: 3,
      title: "Go for a run",
      time: "2024-12-02T06:17:44.783485+00:00",
      isComplete: false,
    ),
    TodoItem(
      category: 1,
      title: "Finish project report",
      time: "2024-12-02T06:17:44.783485+00:00",
      isComplete: false,
    ),
    TodoItem(
      category: 2,
      title: "Buy groceries",
      time: "2024-12-02T06:17:44.783485+00:00",
      isComplete: true,
    ),
    TodoItem(
      category: 3,
      title: "Complete Flutter tutorial",
      time: "2024-12-02T06:17:44.783485+00:00",
      isComplete: false,
    ),
    TodoItem(
      category: 3,
      title: "Go for a run",
      time: "2024-12-17T06:17:44.783485+00:00",
      isComplete: false,
    ),
  ];

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
                      Navigator.pushNamed(context, '/detail');
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
