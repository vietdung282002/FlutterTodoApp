import 'package:flutter/material.dart';
import 'package:flutter_todo_app/config/shared_preferences_helper.dart';
import 'package:flutter_todo_app/config/values.dart';
import 'package:flutter_todo_app/model/enum/loading_state.dart';
import 'package:flutter_todo_app/model/enum/logged_in_status.dart';
import 'package:flutter_todo_app/model/model_objects/authentication_body.dart';
import 'package:flutter_todo_app/model/network/api_services.dart';

class SignUpViewModel extends ChangeNotifier {
  final ApiServices _apiServices = ApiServices();

  LoggedInStatus _isLoggedIn = LoggedInStatus.loggedOut;

  LoggedInStatus get isLoggedIn => _isLoggedIn;

  LoadingState _loading = LoadingState.idle;
  LoadingState get loading => _loading;

  String _gmail = "";
  String get gmail => _gmail;

  String _password = "";
  String get password => _password;

  Future<void> signUp() async {
    if (_loading == LoadingState.loading) return;

    _loading = LoadingState.loading;
    notifyListeners();

    final prefsHelper = SharedPreferencesHelper();

    final authenticationRequest = AuthenticationBody(
      email: gmail,
      password: password,
    );
    try {
      final authenticationResponse =
          await _apiServices.signUp(authenticationRequest);
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
