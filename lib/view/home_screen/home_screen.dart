import 'package:flutter/material.dart';
import 'package:flutter_todo_app/config/utils.dart';
import 'package:flutter_todo_app/view/detail_screen/todo_detail.dart';
import 'package:flutter_todo_app/view/widget/button_widget.dart';
import 'package:flutter_todo_app/view/colors.dart';
import 'package:flutter_todo_app/view/widget/text_widget.dart';
import 'package:flutter_todo_app/view/home_screen/todo_list.dart';
import 'package:flutter_todo_app/view_model/todo_list_view_model.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<TodoListViewModel>(context, listen: false).fetchTodoList();
  }

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
          Positioned(
              right: screenWidth * 0.7,
              top: screenWidth * 0.2,
              child: Image.asset('assets/ellipse_1.png')),
          Positioned(
              left: screenWidth * 0.85,
              top: 0,
              child: Image.asset('assets/ellipse_2.png')),
          SafeArea(
              child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Column(
              children: [
                Center(
                    child: TextWidget(
                        text: AppUtils().formatCurrentDate(),
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
                        child: const TodoList()),
                  ),
                ),
                Padding(
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
