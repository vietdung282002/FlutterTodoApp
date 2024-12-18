import 'package:flutter/material.dart';
import 'package:flutter_todo_app/config/shared_preferences_helper.dart';
import 'package:flutter_todo_app/config/values.dart';
import 'package:flutter_todo_app/model/enum/loading_state.dart';
import 'package:flutter_todo_app/model/enum/logged_in_status.dart';
import 'package:flutter_todo_app/model/model_objects/authentication_request.dart';
import 'package:flutter_todo_app/model/network/api_services.dart';

class LogInViewModel extends ChangeNotifier {
  final ApiServices _apiServices = ApiServices();

  LoggedInStatus _isLoggedIn = LoggedInStatus.unknown;

  LoggedInStatus get isLoggedIn => _isLoggedIn;

  LoadingState _loading = LoadingState.idle;
  LoadingState get loading => _loading;

  String _gmail = "vietdung282002@gmail.com";
  String get gmail => _gmail;

  String _password = "viet1";
  String get password => _password;

  Future<void> checkUserLogin() async {
    final prefsHelper = SharedPreferencesHelper();

    String? userId = await prefsHelper.getString('userId');

    if (userId != null) {
      _isLoggedIn = LoggedInStatus.loggedIn;
    } else {
      _isLoggedIn = LoggedInStatus.loggedOut;
    }
    notifyListeners();
  }

  Future<void> logIn() async {
    if (_loading == LoadingState.loading) return;

    _loading = LoadingState.loading;
    notifyListeners();

    final prefsHelper = SharedPreferencesHelper();

    final authenticationRequest = AuthenticationRequest(
      email: gmail,
      password: password,
    );
    try {
      final authenticationResponse =
          await _apiServices.login(authenticationRequest);
      prefsHelper.saveString(Values.userID, authenticationResponse.user.id);
      prefsHelper.saveString(
          Values.accessToken, authenticationResponse.accessToken);
      _loading = LoadingState.success;
      _isLoggedIn = LoggedInStatus.loggedIn;
      notifyListeners();
    } catch (e) {
      _loading = LoadingState.failure;
      notifyListeners();
    } finally {}
  }

  void setGmail(String gmail) {
    _gmail = gmail;
    notifyListeners();
  }

  void setPassword(String password) {
    _password = password;
    notifyListeners();
  }
}
