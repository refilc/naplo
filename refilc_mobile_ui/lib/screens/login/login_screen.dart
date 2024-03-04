// import 'dart:async';

import 'package:refilc/api/client.dart';
import 'package:refilc/api/login.dart';
import 'package:refilc/theme/colors/colors.dart';
import 'package:refilc_mobile_ui/common/custom_snack_bar.dart';
import 'package:refilc_mobile_ui/common/system_chrome.dart';
import 'package:refilc_mobile_ui/screens/login/login_button.dart';
import 'package:refilc_mobile_ui/screens/login/login_input.dart';
import 'package:refilc_mobile_ui/screens/login/school_input/school_input.dart';
import 'package:refilc_mobile_ui/screens/settings/privacy_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'login_screen.i18n.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, this.back = false});

  final bool back;

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final schoolController = SchoolInputController();
  final _scrollController = ScrollController();

  LoginState _loginState = LoginState.normal;
  bool showBack = false;

  // Scaffold Gradient background
  // final LinearGradient _backgroundGradient = const LinearGradient(
  //   colors: [
  //     Color.fromARGB(255, 61, 122, 244),
  //     Color.fromARGB(255, 23, 77, 185),
  //     Color.fromARGB(255, 7, 42, 112),
  //   ],
  //   begin: Alignment(-0.8, -1.0),
  //   end: Alignment(0.8, 1.0),
  //   stops: [-1.0, 0.0, 1.0],
  // );

  late String tempUsername = '';

  @override
  void initState() {
    super.initState();
    showBack = widget.back;

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    FilcAPI.getSchools().then((schools) {
      if (schools != null) {
        schoolController.update(() {
          schoolController.schools = schools;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(
          content: Text("schools_error".i18n,
              style: const TextStyle(color: Colors.white)),
          backgroundColor: AppColors.of(context).red,
          context: context,
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: AppColors.of(context).loginBackground),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          controller: _scrollController,
          child: Container(
            decoration:
                BoxDecoration(color: AppColors.of(context).loginBackground),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.only(left: 16.0, top: 12.0),
                    child: ClipOval(
                      child: Material(
                        type: MaterialType.transparency,
                        child: showBack
                            ? BackButton(
                                color: AppColors.of(context).loginPrimary)
                            : const SizedBox(height: 48.0),
                      ),
                    ),
                  ),
                  // const SizedBox(
                  //   height: 50.0,
                  // ),

                  // app icon
                  Padding(
                    padding: EdgeInsets.zero,
                    child: Image.asset(
                      'assets/icons/ic_rounded.png',
                      width: 50.0,
                    ),
                  ),

                  // texts
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 12.0,
                    ),
                    child: Text(
                      'reFilc',
                      style: TextStyle(
                        color: AppColors.of(context).loginPrimary,
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                    ),
                    child: Text(
                      'login_w_kreten'.i18n,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.of(context).loginPrimary,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                        height: 1.2,
                      ),
                    ),
                  ),

                  // inputs
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 22.0,
                      right: 22.0,
                      top: 150.0,
                    ),
                    child: AutofillGroup(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // username
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    "username".i18n,
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: AppColors.of(context).loginPrimary,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "usernameHint".i18n,
                                    maxLines: 1,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color:
                                          AppColors.of(context).loginSecondary,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: LoginInput(
                              style: LoginInputStyle.username,
                              controller: usernameController,
                            ),
                          ),

                          // password
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    "password".i18n,
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: AppColors.of(context).loginPrimary,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "passwordHint".i18n,
                                    maxLines: 1,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color:
                                          AppColors.of(context).loginSecondary,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: LoginInput(
                              style: LoginInputStyle.password,
                              controller: passwordController,
                            ),
                          ),

                          // school
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6.0),
                            child: Text(
                              "school".i18n,
                              maxLines: 1,
                              style: TextStyle(
                                color: AppColors.of(context).loginPrimary,
                                fontWeight: FontWeight.w500,
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                          SchoolInput(
                            scroll: _scrollController,
                            controller: schoolController,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // login button
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 35.0,
                      left: 22.0,
                      right: 22.0,
                    ),
                    child: Visibility(
                      visible: _loginState != LoginState.inProgress,
                      replacement: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 6.0),
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                      child: LoginButton(
                        child: Text("login".i18n,
                            maxLines: 1,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            )),
                        onPressed: () => _loginAPI(context: context),
                      ),
                    ),
                  ),

                  // error messages
                  if (_loginState == LoginState.missingFields ||
                      _loginState == LoginState.invalidGrant ||
                      _loginState == LoginState.failed)
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, left: 12.0, right: 12.0),
                      child: Text(
                        [
                          "missing_fields",
                          "invalid_grant",
                          "error"
                        ][_loginState.index]
                            .i18n,
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  const SizedBox(height: 22.0),

                  // privacy policy
                  GestureDetector(
                    onTap: () => PrivacyView.show(context),
                    child: Text(
                      'privacy'.i18n,
                      style: TextStyle(
                        color: AppColors.of(context).loginSecondary,
                        fontWeight: FontWeight.w500,
                        fontSize: 14.0,
                      ),
                    ),
                  ),

                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _loginAPI({required BuildContext context}) {
    String username = usernameController.text;
    String password = passwordController.text;

    tempUsername = username;

    if (username == "" ||
        password == "" ||
        schoolController.selectedSchool == null) {
      return setState(() => _loginState = LoginState.missingFields);
    }

    // ignore: no_leading_underscores_for_local_identifiers
    void _callAPI() {
      loginAPI(
          username: username,
          password: password,
          instituteCode: schoolController.selectedSchool!.instituteCode,
          context: context,
          onLogin: (user) {
            ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(
              context: context,
              brightness: Brightness.light,
              content: Text("welcome".i18n.fill([user.name]),
                  overflow: TextOverflow.ellipsis),
            ));
          },
          onSuccess: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            setSystemChrome(context);
            Navigator.of(context).pushReplacementNamed("login_to_navigation");
          }).then(
        (res) => setState(() {
          // if (res == LoginState.invalidGrant &&
          //     tempUsername.replaceAll(username, '').length <= 3) {
          //   tempUsername = username + ' ';
          //   Timer(
          //     const Duration(milliseconds: 500),
          //     () => _loginAPI(context: context),
          //   );
          //   // _loginAPI(context: context);
          // } else {
          _loginState = res;
          // }
        }),
      );
    }

    setState(() => _loginState = LoginState.inProgress);
    _callAPI();
  }
}
