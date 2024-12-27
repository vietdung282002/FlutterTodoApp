import 'package:get/get.dart';

import '../../common/shared_preferences_helper.dart';
import '../../common/values.dart';
import '../../model/body/authentication_body.dart';
import '../../model/enum/loading_state.dart';
import '../../model/enum/logged_in_status.dart';
import '../../network/api_services.dart';

class LoginVM extends GetxController {
  final ApiServices _apiServices = Get.find();

  LoggedInStatus _isLoggedIn = LoggedInStatus.unknown;

  LoggedInStatus get isLoggedIn => _isLoggedIn;

  LoadingState _loading = LoadingState.idle;
  LoadingState get loading => _loading;

  String _gmail = "vietdung282002@gmail.com";
  String get gmail => _gmail;

  String _password = "vietdung1";
  String get password => _password;

  Future<void> checkUserLogin() async {
    final prefsHelper = SharedPreferencesHelper();

    String? userId = await prefsHelper.getString(Values.userID);

    if (userId != null) {
      _isLoggedIn = LoggedInStatus.loggedIn;
    } else {
      _isLoggedIn = LoggedInStatus.loggedOut;
    }
    update();
  }

  Future<void> logIn() async {
    if (_loading == LoadingState.loading) return;

    _loading = LoadingState.loading;
    update();

    final prefsHelper = SharedPreferencesHelper();

    final authenticationBody = AuthenticationBody(
      email: gmail,
      password: password,
    );
    try {
      final authenticationResponse =
          await _apiServices.login(authenticationBody);
      prefsHelper.saveString(Values.userID, authenticationResponse.user.id);
      prefsHelper.saveString(
          Values.accessToken, authenticationResponse.accessToken);
      _loading = LoadingState.success;
      _isLoggedIn = LoggedInStatus.loggedIn;
      update();
    } catch (e) {
      _loading = LoadingState.failure;
      update();
    } finally {}
  }

  void setGmail(String gmail) {
    _gmail = gmail;
    update();
  }

  void setPassword(String password) {
    _password = password;
    update();
  }
}
