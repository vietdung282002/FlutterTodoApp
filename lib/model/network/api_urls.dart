import 'package:flutter_todo_app/config/values.dart';

class ApiUrls {
  Uri getTodoList({required String udid}) {
    Map<String, String> queryParams = {
      'udid': "eq.$udid",
      'select': "*",
      'order': 'time.asc'
    };
    return Uri.parse(Values.baseUrls).replace(queryParameters: queryParams);
  }

  Uri getTodoDetail({required int todoId}) {
    Map<String, String> queryParams = {'todo_id': "eq.$todoId", 'select': "*"};
    return Uri.parse(Values.baseUrls).replace(queryParameters: queryParams);
  }

  Uri createTodo() {
    return Uri.parse(Values.baseUrls);
  }

  Uri updateTodo({required int todoId}) {
    Map<String, String> queryParams = {'todo_id': "eq.$todoId"};
    return Uri.parse(Values.baseUrls).replace(queryParameters: queryParams);
  }

  Uri updateTodoStatus({required int todoId}) {
    Map<String, String> queryParams = {'todo_id': "eq.$todoId"};
    return Uri.parse(Values.baseUrls).replace(queryParameters: queryParams);
  }

  Uri deleteTodo({required int todoId}) {
    Map<String, String> queryParams = {'todo_id': "eq.$todoId"};
    return Uri.parse(Values.baseUrls).replace(queryParameters: queryParams);
  }
}
