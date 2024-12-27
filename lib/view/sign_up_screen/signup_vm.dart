
import 'package:get/get.dart';

import '../../common/values.dart';
import '../../config/shared_preferences_helper.dart';
import '../../model/body/authentication_body.dart';
import '../../model/enum/loading_state.dart';
import '../../model/enum/logged_in_status.dart';
import '../../network/api_services.dart';

class SignUpVM extends GetxController {
  final ApiServices _apiServices = Get.find();

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
   update();

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
