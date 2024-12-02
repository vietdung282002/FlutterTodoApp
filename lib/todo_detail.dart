import 'package:flutter/material.dart';
import 'package:flutter_todo_app/colors.dart';
import 'package:flutter_todo_app/text_widget.dart';

class TodoDetail extends StatefulWidget {
  const TodoDetail({super.key});

  @override
  State<TodoDetail> createState() => _TodoDetailState();
}

class _TodoDetailState extends State<TodoDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextWidget(
              text: "Task Title",
              textColor: textColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            TextField(
              decoration: InputDecoration(
                hintText: "Task Title",
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(6.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: backgroundColor, width: 1),
                  borderRadius: BorderRadius.circular(6.0),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
