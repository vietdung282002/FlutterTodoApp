import 'package:flutter/material.dart';
import 'package:flutter_todo_app/config/utils.dart';
import 'package:flutter_todo_app/model/enum/loading_state.dart';
import 'package:flutter_todo_app/view/colors.dart';
import 'package:flutter_todo_app/view/widget/alert_dialog_widget.dart';
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
      child: TodoDetailScreen(
        todoId: todoId,
      ),
    );
  }
}

class TodoDetailScreen extends StatefulWidget {
  const TodoDetailScreen({super.key, required this.todoId});

  final int todoId;

  @override
  State<TodoDetailScreen> createState() => _TodoDetailScreenState();
}

class _TodoDetailScreenState extends State<TodoDetailScreen> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  final TextEditingController _taskTitleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  bool _taskTitleValidate = false;
  bool _dateValidate = false;
  bool _timeValidate = false;

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
        _dateController.text = formattedDate;
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
        final String formattedTime = AppUtils().formatTimeTo12Hour(picked);
        _timeController.text = formattedTime;
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
    _taskTitleController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _noteController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBarWidget(
        title: widget.todoId == -1 ? "Add Todo" : "Edit Todo",
        titleColor: Colors.white,
        backgroundColor: backgroundColor,
        leadingWidget: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Image.asset("assets/BackButton.png"),
        ),
      ),
      body: Consumer<TodoDetailViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.todoItem == null &&
              viewModel.loading == LoadingState.loading) {
            return const SafeArea(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (viewModel.todoItem != null) {
            _taskTitleController.text = viewModel.taskTitle!;
            _dateController.text = viewModel.date!;
            _timeController.text = viewModel.time!;
            _noteController.text = viewModel.taskNote ?? "";
          }
          if (viewModel.loading == LoadingState.failure) {
            return const AlertDialogWidget(content: "Fail to load todo");
          }
          return Column(
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
                            textEditingController: _taskTitleController,
                            error: _taskTitleValidate
                                ? "Value Can't Be Empty"
                                : null,
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
                                          readOnly: true,
                                          textEditingController:
                                              _dateController,
                                          placeholder: "Date",
                                          error: _dateValidate
                                              ? "Value Can't Be Empty"
                                              : null,
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
                                          error: _timeValidate
                                              ? "Value Can't Be Empty"
                                              : null,
                                          readOnly: true,
                                          textEditingController:
                                              _timeController,
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
                                textEditingController: _noteController,
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
                              setState(() {
                                _dateValidate = _dateController.text.isEmpty;
                                _taskTitleValidate =
                                    _taskTitleController.text.isEmpty;
                                _timeValidate = _timeController.text.isEmpty;
                              });
                              if (viewModel.categotyId == null) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const AlertDialogWidget(
                                      content: "Please select a category",
                                    );
                                  },
                                );
                              }
                              if (_taskTitleValidate == false &&
                                  _timeValidate == false &&
                                  _dateValidate == false &&
                                  viewModel.categotyId != null) {
                                if (widget.todoId == -1) {
                                  viewModel.addTodo(
                                      _taskTitleController.text,
                                      _noteController.text,
                                      AppUtils().formatDateTimeString(
                                          _dateController.text,
                                          _timeController.text));
                                } else {
                                  viewModel.editTodo(
                                      _taskTitleController.text,
                                      _noteController.text,
                                      AppUtils().formatDateTimeString(
                                          _dateController.text,
                                          _timeController.text));
                                }
                                Navigator.pop(context);
                                Provider.of<TodoListViewModel>(context,
                                        listen: false)
                                    .updateTodo();
                              }
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
          );
        },
      ),
    );
  }
}
