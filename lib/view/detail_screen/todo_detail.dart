import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/config/app_text_style.dart';
import 'package:flutter_todo_app/config/utils.dart';
import 'package:flutter_todo_app/model/enum/category.dart';
import 'package:flutter_todo_app/model/enum/loading_state.dart';
import 'package:flutter_todo_app/config/colors.dart';
import 'package:flutter_todo_app/view/widget/alert_dialog_widget.dart';
import 'package:flutter_todo_app/view/widget/app_bar_widget.dart';
import 'package:flutter_todo_app/view/widget/button_widget.dart';
import 'package:flutter_todo_app/view/widget/category_widget.dart';
import 'package:flutter_todo_app/view/widget/text_field_widget.dart';
import 'package:flutter_todo_app/view/widget/text_widget.dart';
import 'package:flutter_todo_app/view/detail_screen/todo_detail_view_model.dart';
import 'package:flutter_todo_app/view/home_screen/home_view_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TodoDetail extends StatelessWidget {
  const TodoDetail({super.key, required this.todoId});
  final int todoId;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TodoDetailViewModel>(
      create: (context) => TodoDetailViewModel(),
      child: TodoDetailScreen(
        todoId: todoId,
      ),
    );
  }
}

class TodoDetailScreen extends StatefulWidget {
  final int todoId;

  const TodoDetailScreen({
    super.key,
    required this.todoId,
  });

  @override
  State<TodoDetailScreen> createState() => _TodoDetailScreenState();
}

class _TodoDetailScreenState extends State<TodoDetailScreen> {
  final TextEditingController _taskTitleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

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
    if (picked != null) {
      setState(
        () {
          selectedDate = picked;
          String formattedDate = DateFormat('dd-MM-yyyy').format(picked);
          _dateController.text = formattedDate;
          Provider.of<TodoDetailViewModel>(context, listen: false)
              .setDate(formattedDate);
        },
      );
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
    if (picked != null) {
      setState(
        () {
          selectedTime = picked;
          final String formattedTime = AppUtils().formatTimeTo12Hour(picked);
          _timeController.text = formattedTime;
          Provider.of<TodoDetailViewModel>(context, listen: false)
              .setTime(formattedTime);
        },
      );
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
      backgroundColor: backgroundColor2,
      appBar: AppBarWidget(
        title: widget.todoId == -1 ? "Add Todo" : "Edit Todo",
        textStyle: AppTextStyle.title1,
        backgroundColor: backgroundColor,
        leadingWidget: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Image.asset("assets/back_button.png"),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTaskTitleField(),
                          _buildCategoryField(),
                          Padding(
                              padding: const EdgeInsets.only(top: 24.0),
                              child: Row(
                                children: [
                                  _buildDateField(),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  _buildTimeField()
                                ],
                              )),
                          _buildNoteField(),
                          _buildSaveButton(screenWidth)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          _buildLoadingState()
        ],
      ),
    );
  }

  Widget _buildTaskTitleField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextTitle(text: "Task Title"),
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Selector<TodoDetailViewModel, String?>(
            selector: (context, viewModel) => viewModel.todoItem.taskTitle,
            builder: (context, taskTitle, child) {
              if (taskTitle != null) {
                _taskTitleController.text = taskTitle;
              }
              return TextFieldWidget(
                onChange: (text) {
                  Provider.of<TodoDetailViewModel>(context, listen: false)
                      .setTaskTitle(text);
                },
                placeholder: "Task Title",
                textEditingController: _taskTitleController,
                error: _taskTitleValidate ? "Value Can't Be Empty" : null,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryField() {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildTextTitle(text: "Category"),
          const SizedBox(
            width: 30,
          ),
          _buildCategoryPicker(
            category: ItemCategory.task,
          ),
          const SizedBox(
            width: 20,
          ),
          _buildCategoryPicker(
            category: ItemCategory.event,
          ),
          const SizedBox(
            width: 20,
          ),
          _buildCategoryPicker(
            category: ItemCategory.goal,
          ),
        ],
      ),
    );
  }

  Widget _buildDateField() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextTitle(text: "Date"),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Consumer<TodoDetailViewModel>(
              builder: (context, viewModel, child) {
                _dateController.text = viewModel.date!;
                return TextFieldWidget(
                  readOnly: true,
                  textEditingController: _dateController,
                  placeholder: "Date",
                  error: _dateValidate ? "Value Can't Be Empty" : null,
                  endIcon: IconButton(
                      onPressed: () => _selectDate(context),
                      icon: Image.asset("assets/input_calendar.png")),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTimeField() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextTitle(text: "Time"),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Consumer<TodoDetailViewModel>(
                builder: (context, viewModel, child) {
              _timeController.text = viewModel.time!;
              return TextFieldWidget(
                error: _timeValidate ? "Value Can't Be Empty" : null,
                readOnly: true,
                textEditingController: _timeController,
                placeholder: "Time",
                endIcon: IconButton(
                    onPressed: () => _selectTime(context),
                    icon: Image.asset("assets/input_clock.png")),
              );
            }),
          )
        ],
      ),
    );
  }

  Widget _buildNoteField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: _buildTextTitle(text: "Note"),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 24),
          child: SizedBox(
            height: 250,
            child: Consumer<TodoDetailViewModel>(
              builder: (context, viewModel, child) {
                _noteController.text = viewModel.todoItem.taskNote!;
                return TextFieldWidget(
                  onChange: (text) {
                    Provider.of<TodoDetailViewModel>(context, listen: false)
                        .setTaskNote(text);
                  },
                  textEditingController: _noteController,
                  placeholder: "Note",
                  maxLines: null,
                  expands: true,
                  keyboardType: TextInputType.multiline,
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton(double screenWidth) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0, top: 24),
      child: Consumer<TodoDetailViewModel>(
        builder: (context, viewModel, child) {
          return ButtonWidget(
            onTap: () {
              viewModel.setTaskTitle(_taskTitleController.text);
              viewModel.setTaskNote(_noteController.text);
              setState(
                () {
                  _dateValidate = _dateController.text.isEmpty;
                  _taskTitleValidate = _taskTitleController.text.isEmpty;
                  _timeValidate = _timeController.text.isEmpty;
                },
              );
              if (viewModel.todoItem.category == null) {
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
                  viewModel.todoItem.category != null) {
                if (widget.todoId == -1) {
                  viewModel.addTodo(
                      _taskTitleController.text,
                      _noteController.text,
                      AppUtils().formatDateTimeString(
                          _dateController.text, _timeController.text));
                } else {
                  viewModel.editTodo(
                      _taskTitleController.text,
                      _noteController.text,
                      AppUtils().formatDateTimeString(
                          _dateController.text, _timeController.text));
                }
              }
            },
            width: screenWidth,
            text: "Save",
            textStyle: AppTextStyle.buttonStyle,
          );
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Consumer<TodoDetailViewModel>(builder: (context, viewModel, child) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          if (viewModel.isEditted == true &&
              viewModel.loading == LoadingState.success) {
            Provider.of<HomeViewModel>(context, listen: false).updateTodo();
            Navigator.of(context).maybePop();
          }
        },
      );

      if (viewModel.loading == LoadingState.loading) {
        return SafeArea(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
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
    });
  }

  Widget _buildTextTitle({required String text}) {
    return TextWidget(
      text: text,
      textStyle: const TextStyle(
        color: textColor,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildCategoryPicker({
    required ItemCategory category,
  }) {
    return Consumer<TodoDetailViewModel>(
      builder: (context, viewModel, child) {
        return CategoryWidget(
          image: Image.asset(category.icon),
          onTap: () {
            viewModel.setCategory(category);
          },
          backgroundColor: category.backgroundColor,
          borderColor: viewModel.todoItem.category == null
              ? Colors.white
              : (viewModel.todoItem.category == category
                  ? Colors.cyan
                  : Colors.white),
          borderWidth: 2.0,
        );
      },
    );
  }
}
