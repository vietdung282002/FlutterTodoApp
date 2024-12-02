import 'package:flutter/material.dart';
import 'package:flutter_todo_app/view/colors.dart';
import 'package:flutter_todo_app/view/widget/app_bar_widget.dart';
import 'package:flutter_todo_app/view/widget/category_widget.dart';
import 'package:flutter_todo_app/view/widget/text_field_widget.dart';
import 'package:flutter_todo_app/view/widget/text_widget.dart';

class TodoDetail extends StatefulWidget {
  const TodoDetail({super.key});

  @override
  State<TodoDetail> createState() => _TodoDetailState();
}

class _TodoDetailState extends State<TodoDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: "Add New Task",
        titleColor: Colors.white,
        backgroundColor: backgroundColor,
        leadingWidget: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Image.asset("assets/BackButton.png")),
      ),
      backgroundColor: backgroundColor2,
      body: SingleChildScrollView(
        child: SafeArea(
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
              const Padding(
                padding: EdgeInsets.only(top: 12.0),
                child: TextFieldWidget(
                  placeholder: "Task Title",
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const TextWidget(
                      text: "Category",
                      textColor: textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    CategoryWidget(
                      image: Image.asset("assets/CategoryTask.png"),
                      onTap: () {},
                      backgroundColor: taskBackground,
                      borderColor: Colors.white,
                      borderWidth: 2.0,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    CategoryWidget(
                      image: Image.asset("assets/CategoryEvent.png"),
                      onTap: () {},
                      backgroundColor: eventBackground,
                      borderColor: Colors.white,
                      borderWidth: 2.0,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    CategoryWidget(
                      image: Image.asset("assets/CategoryGoal.png"),
                      onTap: () {},
                      backgroundColor: goalBackground,
                      borderColor: Colors.white,
                      borderWidth: 2.0,
                    ),
                  ],
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const TextWidget(
                              text: "Date",
                              textColor: textColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: TextFieldWidget(
                                placeholder: "Date",
                                endIcon: IconButton(
                                    onPressed: () {},
                                    icon: Image.asset(
                                        "assets/InputCalendar.png")),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const TextWidget(
                              text: "Date",
                              textColor: textColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: TextFieldWidget(
                                placeholder: "Date",
                                endIcon: IconButton(
                                    onPressed: () {},
                                    icon: Image.asset("assets/InputClock.png")),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  )),
              const Padding(
                padding: EdgeInsets.only(top: 24.0),
                child: TextWidget(
                  text: "Note",
                  textColor: textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Padding(
                  padding: EdgeInsets.only(top: 24),
                  child: SizedBox(
                    height: 250, //     <-- TextField expands to this height.
                    child: TextFieldWidget(
                      placeholder: "Note",
                      maxLines: null, // Set this
                      expands: true, // and this
                      keyboardType: TextInputType.multiline,
                    ),
                  ))
            ],
          ),
        )),
      ),
    );
  }
}
