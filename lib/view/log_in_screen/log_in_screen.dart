import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_todo_app/config/app_text_style.dart';
import 'package:flutter_todo_app/common/colors.dart';
import 'package:flutter_todo_app/model/enum/loading_state.dart';
import 'package:flutter_todo_app/model/enum/logged_in_status.dart';
import 'package:flutter_todo_app/view/home_screen/home_screen.dart';
import 'package:flutter_todo_app/view/sign_up_screen/sign_up_screen.dart';
import 'package:flutter_todo_app/components/text_widget.dart';
import 'package:get/get.dart';

import '../../components/alert_dialog_widget.dart';
import '../../components/button_widget.dart';
import '../../components/text_button_widget.dart';
import '../../components/text_field_widget.dart';
import 'login_vm.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  LoginVM loginVM = Get.put(LoginVM());

  final TextEditingController _gmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _gmailValidate = false;
  bool _passwordValidate = false;

  @override
  void initState() {
    super.initState();
    loginVM.checkUserLogin();
  }

  @override
  void dispose() {
    _gmailController.dispose();
    _passwordController.dispose();
    loginVM.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          _buildBackground(screenHeight, screenWidth, context),
          _buildLoginStateWidget()
        ],
      ),
    );
  }

  Widget _buildBackground(
      double screenHeight, double screenWidth, BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: screenHeight * 0.8,
        width: screenWidth,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32.0),
            topRight: Radius.circular(32.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 32.0,
            right: 32,
            top: 48,
          ),
          child: SingleChildScrollView(
            child: _buildForm(screenWidth, context),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(double screenWidth, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCaption(),
        const SizedBox(
          height: 40,
        ),
        _buildGmailField(),
        const SizedBox(
          height: 20,
        ),
        _buildPasswordField(),
        const SizedBox(
          height: 30,
        ),
        _buildSignInButton(screenWidth),
        const SizedBox(
          height: 30,
        ),
        _buildSignUpRow(context)
      ],
    );
  }

  Widget _buildCaption() {
    return const Center(
      child: TextWidget(
        text: "Log In",
        textStyle: AppTextStyle.blackCaption,
      ),
    );
  }

  Widget _buildGmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextWidget(
          text: "Email",
          textStyle: AppTextStyle.blackTitle,
        ),
        Padding(
            padding: const EdgeInsets.only(
              top: 12.0,
            ),
            child: GetBuilder(
              init: loginVM,
              builder: (controller) {
                var gmail = controller.gmail;
                _gmailController.text = gmail;
                return TextFieldWidget(
                  maxLines: 1,
                  onChange: (text) {
                    controller.setGmail(text);
                  },
                  placeholder: "abc@gmail.com",
                  textEditingController: _gmailController,
                  error: _gmailValidate ? "Gmail Can't Be Empty" : null,
                );
              },
            )),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextWidget(
          text: "Password",
          textStyle: AppTextStyle.blackTitle,
        ),
        Padding(
            padding: const EdgeInsets.only(
              top: 12.0,
            ),
            child: GetBuilder(
                init: loginVM,
                builder: (controller) {
                  var password = controller.password;
                  _passwordController.text = password;
                  return TextFieldWidget(
                    obscureText: true,
                    maxLines: 1,
                    onChange: (text) {
                      controller.setPassword(text);
                    },
                    placeholder: "Password",
                    textEditingController: _passwordController,
                    error: _passwordValidate ? "Password Can't Be Empty" : null,
                  );
                })),
      ],
    );
  }

  Widget _buildSignInButton(double screenWidth) {
    return Center(
      child: GetBuilder(
        init: loginVM,
        builder: (controller) {
          return ButtonWidget(
            width: screenWidth * 0.7,
            text: "Sign in",
            onTap: () {
              setState(
                () {
                  _gmailValidate = _gmailController.text.isEmpty;
                  _passwordValidate = _passwordController.text.isEmpty;
                },
              );

              if (_gmailValidate != false || _passwordValidate != false) {
              } else {
                controller.logIn();
              }
            },
            textStyle: AppTextStyle.buttonStyle,
          );
        },
      ),
    );
  }

  Widget _buildSignUpRow(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const TextWidget(
            text: "Don't have an account?",
            textStyle: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w200,
              color: textColor,
            ),
          ),
          TextButtonWidget(
            text: " Sign up",
            onTap: () {
              Get.to(() => const SignUpScreen());
            },
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.blue,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLoginStateWidget() {
    return GetBuilder(
      init: loginVM,
      builder: (controller) {
        if (controller.loading == LoadingState.failure &&
            controller.isLoggedIn == LoggedInStatus.loggedOut) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const AlertDialogWidget(
                    content: "Failed to login",
                  );
                },
              );
            },
          );
        }
        if (controller.isLoggedIn == LoggedInStatus.loggedIn) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) {
              Get.offAll(() => const HomeScreen());
            },
          );
        }
        if (controller.loading == LoadingState.loading) {
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
      },
    );
  }
}
