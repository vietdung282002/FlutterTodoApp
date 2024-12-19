import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_todo_app/config/colors.dart';
import 'package:flutter_todo_app/model/enum/loading_state.dart';
import 'package:flutter_todo_app/model/enum/logged_in_status.dart';
import 'package:flutter_todo_app/view/home_screen/home_screen.dart';
import 'package:flutter_todo_app/view/log_in_screen/log_in_view_model.dart';
import 'package:flutter_todo_app/view/sign_up_screen/sign_up_screen.dart';
import 'package:flutter_todo_app/view/widget/alert_dialog_widget.dart';
import 'package:flutter_todo_app/view/widget/button_widget.dart';
import 'package:flutter_todo_app/view/widget/text_button_widget.dart';
import 'package:flutter_todo_app/view/widget/text_field_widget.dart';
import 'package:flutter_todo_app/view/widget/text_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LogIn extends StatelessWidget {
  const LogIn({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LogInViewModel>(
      create: (_) => LogInViewModel(),
      child: const LogInScreen(),
    );
  }
}

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final TextEditingController _gmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  void initState() {
    Provider.of<LogInViewModel>(context, listen: false).checkUserLogin();
    super.initState();
  }

  bool _gmailValidate = false;
  bool _passwordValidate = false;

  @override
  void dispose() {
    _gmailController.dispose();
    _passwordController.dispose();
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
          Align(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: TextWidget(
                          text: "Log In",
                          textStyle: GoogleFonts.inter(
                            textStyle: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      TextWidget(
                        text: "Email",
                        textStyle: GoogleFonts.inter(
                          textStyle: const TextStyle(
                            color: textColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 12.0,
                        ),
                        child: Selector<LogInViewModel, String?>(
                          selector: (context, viewModel) => viewModel.gmail,
                          builder: (context, gmail, child) {
                            if (gmail != null) {
                              _gmailController.text = gmail;
                            }
                            return TextFieldWidget(
                              maxLines: 1,
                              onChange: (text) {
                                Provider.of<LogInViewModel>(context,
                                        listen: false)
                                    .setGmail(text);
                              },
                              placeholder: "abc@gmail.com",
                              textEditingController: _gmailController,
                              error: _gmailValidate
                                  ? "Gmail Can't Be Empty"
                                  : null,
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextWidget(
                        text: "Password",
                        textStyle: GoogleFonts.inter(
                          textStyle: const TextStyle(
                            color: textColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 12.0,
                        ),
                        child: Selector<LogInViewModel, String?>(
                          selector: (context, viewModel) => viewModel.password,
                          builder: (context, password, child) {
                            if (password != null) {
                              _passwordController.text = password;
                            }
                            return TextFieldWidget(
                              obscureText: true,
                              maxLines: 1,
                              onChange: (text) {
                                Provider.of<LogInViewModel>(context,
                                        listen: false)
                                    .setPassword(text);
                              },
                              placeholder: "Password",
                              textEditingController: _passwordController,
                              error: _passwordValidate
                                  ? "Password Can't Be Empty"
                                  : null,
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: Consumer<LogInViewModel>(
                          builder: (context, viewModel, child) {
                            return ButtonWidget(
                              width: screenWidth * 0.7,
                              text: "Sign in",
                              onTap: () {
                                setState(
                                  () {
                                    _gmailValidate =
                                        _gmailController.text.isEmpty;
                                    _passwordValidate =
                                        _passwordController.text.isEmpty;
                                  },
                                );

                                if (_gmailValidate != false ||
                                    _passwordValidate != false) {
                                } else {
                                  viewModel.logIn();
                                }
                              },
                              textStyle: GoogleFonts.inter(
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextWidget(
                              text: "Don't have an account?",
                              textStyle: GoogleFonts.inter(
                                textStyle: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w200,
                                  color: textColor,
                                ),
                              ),
                            ),
                            TextButtonWidget(
                              text: " Sign up",
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignUp(),
                                  ),
                                );
                              },
                              textStyle: GoogleFonts.inter(
                                textStyle: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.blue,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Consumer<LogInViewModel>(
            builder: (context, viewModel, child) {
              WidgetsBinding.instance.addPostFrameCallback(
                (_) {
                  if (viewModel.loading == LoadingState.failure &&
                      viewModel.isLoggedIn == LoggedInStatus.loggedOut) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const AlertDialogWidget(
                          content: "Failed to login",
                        );
                      },
                    );
                  }
                  if (viewModel.isLoggedIn == LoggedInStatus.loggedIn) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()),
                    );
                  }
                },
              );
              if (viewModel.loading == LoadingState.failure &&
                  viewModel.isLoggedIn == LoggedInStatus.loggedOut) {}
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
            },
          )
        ],
      ),
    );
  }
}
