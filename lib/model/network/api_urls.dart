import 'package:flutter_todo_app/config/values.dart';

class ApiUrls {
  Uri getTodoList() {
    return Uri.parse(Values.baseUrls);
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
}
