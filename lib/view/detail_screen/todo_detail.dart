import 'package:flutter/material.dart';
import 'package:flutter_todo_app/config/utils.dart';
import 'package:flutter_todo_app/model/enum/loading_state.dart';
import 'package:flutter_todo_app/view/colors.dart';
import 'package:flutter_todo_app/view/widget/app_bar_widget.dart';
import 'package:flutter_todo_app/view/widget/button_widget.dart';
import 'package:flutter_todo_app/view/widget/category_widget.dart';
import 'package:flutter_todo_app/view/widget/text_field_widget.dart';
import 'package:flutter_todo_app/view/widget/text_widget.dart';
import 'package:flutter_todo_app/view_model/todo_detail_view_model.dart';
import 'package:flutter_todo_app/view_model/todo_list_view_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TodoDetail extends StatelessWidget {
  const TodoDetail({super.key, required this.todoId});
  final int todoId;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TodoDetailViewModel>(
      create: (_) => TodoDetailViewModel(),
      child: TodoDetailChild(
        todoId: todoId,
      ),
    );
  }
}

class TodoDetailChild extends StatefulWidget {
  const TodoDetailChild({super.key, required this.todoId});

  final int todoId;

  @override
  State<TodoDetailChild> createState() => _TodoDetailChildState();
}

class _TodoDetailChildState extends State<TodoDetailChild> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  TextEditingController taskTitleController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        String formattedDate = DateFormat('dd-MM-yyyy').format(picked);
        dateController.text = formattedDate;
        Provider.of<TodoDetailViewModel>(context, listen: false)
            .setDate(formattedDate);
      });
    }
  }

  _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
        final String formattedTime = formatTimeTo12Hour(picked);
        timeController.text = formattedTime;
        Provider.of<TodoDetailViewModel>(context, listen: false)
            .setTime(formattedTime);
      });
    }
  }

  @override
  void initState() {
    Provider.of<TodoDetailViewModel>(context, listen: false)
        .fetchTodoDetail(widget.todoId);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    taskTitleController.dispose();
    dateController.dispose();
    timeController.dispose();
    noteController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Consumer<TodoDetailViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.todoItem == null &&
            viewModel.isLoading == LoadingState.loading) {
          return const SafeArea(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (viewModel.todoItem != null) {
          taskTitleController.text = viewModel.taskTitle!;
          dateController.text = viewModel.date!;
          timeController.text = viewModel.time!;
          noteController.text = viewModel.taskNote ?? "";
        }
        return Scaffold(
          appBar: AppBarWidget(
            title: viewModel.taskTitle == null ? "Add New Task" : "Edit Task",
            titleColor: Colors.white,
            backgroundColor: backgroundColor,
            leadingWidget: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Image.asset("assets/BackButton.png"),
            ),
          ),
          backgroundColor: backgroundColor2,
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
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
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: TextFieldWidget(
                            placeholder: "Task Title",
                            textEditingController: taskTitleController,
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
                                onTap: () {
                                  viewModel.setCategory(1);
                                },
                                backgroundColor: taskBackground,
                                borderColor: viewModel.categotyId == null
                                    ? Colors.white
                                    : (viewModel.categotyId == 1
                                        ? Colors.cyan
                                        : Colors.white),
                                borderWidth: 2.0,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              CategoryWidget(
                                image: Image.asset("assets/CategoryEvent.png"),
                                onTap: () {
                                  viewModel.setCategory(2);
                                },
                                backgroundColor: eventBackground,
                                borderColor: viewModel.categotyId == null
                                    ? Colors.white
                                    : (viewModel.categotyId == 2
                                        ? Colors.cyan
                                        : Colors.white),
                                borderWidth: 2.0,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              CategoryWidget(
                                image: Image.asset("assets/CategoryGoal.png"),
                                onTap: () {
                                  viewModel.setCategory(3);
                                },
                                backgroundColor: goalBackground,
                                borderColor: viewModel.categotyId == null
                                    ? Colors.white
                                    : (viewModel.categotyId == 3
                                        ? Colors.cyan
                                        : Colors.white),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const TextWidget(
                                        text: "Date",
                                        textColor: textColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: TextFieldWidget(
                                          textEditingController: dateController,
                                          placeholder: "Date",
                                          endIcon: IconButton(
                                              onPressed: () =>
                                                  _selectDate(context),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const TextWidget(
                                        text: "Time",
                                        textColor: textColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: TextFieldWidget(
                                          textEditingController: timeController,
                                          placeholder: "Time",
                                          endIcon: IconButton(
                                              onPressed: () =>
                                                  _selectTime(context),
                                              icon: Image.asset(
                                                  "assets/InputClock.png")),
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
                        Padding(
                            padding: const EdgeInsets.only(top: 24),
                            child: SizedBox(
                              height:
                                  250, //     <-- TextField expands to this height.
                              child: TextFieldWidget(
                                textEditingController: noteController,
                                placeholder: "Note",
                                maxLines: null, // Set this
                                expands: true, // and this
                                keyboardType: TextInputType.multiline,
                              ),
                            )),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 24.0, top: 24),
                          child: ButtonWidget(
                            onTap: () {
                              if (widget.todoId == -1) {
                                viewModel.addTodo(
                                    taskTitleController.text,
                                    noteController.text,
                                    getCurrentTime(),
                                    formatDateTimeString(dateController.text,
                                        timeController.text));
                              } else {
                                viewModel.editTodo(
                                    taskTitleController.text,
                                    noteController.text,
                                    formatDateTimeString(dateController.text,
                                        timeController.text));
                              }
                              Navigator.pop(context);

                              Provider.of<TodoListViewModel>(context,
                                      listen: false)
                                  .fetchTodoList(refresh: true);
                            },
                            screenWidth: screenWidth,
                            text: "Save",
                          ),
                        )
                      ],
                    ),
                  )),
                ),
              ),
            ],
          ),
        );
      },
      child: Placeholder(),
    );
  }
}
