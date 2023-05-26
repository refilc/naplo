import 'dart:ui';

import 'package:filcnaplo/api/client.dart';
import 'package:filcnaplo/api/login.dart';
import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:filcnaplo_mobile_ui/common/custom_snack_bar.dart';
import 'package:filcnaplo_mobile_ui/common/system_chrome.dart';
import 'package:filcnaplo_mobile_ui/screens/login/login_button.dart';
import 'package:filcnaplo_mobile_ui/screens/login/login_input.dart';
import 'package:filcnaplo_mobile_ui/screens/login/school_input/school_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'login_screen.i18n.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key, this.back = false}) : super(key: key);

  final bool back;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final schoolController = SchoolInputController();
  final _scrollController = ScrollController();

  LoginState _loginState = LoginState.normal;
  bool showBack = false;

  // Scaffold Gradient background
  final LinearGradient _backgroundGradient = const LinearGradient(
    colors: [
      Color(0xff20AC9B),
      Color(0xff20AC9B),
      Color(0xff123323),
    ],
    begin: Alignment(-0.8, -1.0),
    end: Alignment(0.8, 1.0),
    stops: [-1.0, 0.0, 1.0],
  );

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
          content: Text("schools_error".i18n, style: const TextStyle(color: Colors.white)),
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
        decoration: BoxDecoration(gradient: _backgroundGradient),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          controller: _scrollController,
          child: Container(
            decoration: BoxDecoration(gradient: _backgroundGradient),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (showBack)
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.only(left: 16.0, top: 12.0),
                      child: const ClipOval(
                        child: Material(
                          type: MaterialType.transparency,
                          child: BackButton(color: Colors.white),
                        ),
                      ),
                    ),

                  const Spacer(),

                  // App logo
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: ClipRect(
                      child: Container(
                        // Png shadow *hack*
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Opacity(child: Image.asset("assets/icons/ic_splash.png", color: Colors.black), opacity: 0.3),
                            ),
                            BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
                              child: Image.asset("assets/icons/ic_splash.png"),
                            )
                          ],
                        ),
                        width: MediaQuery.of(context).size.width / 4,
                        margin: const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 12.0),
                      ),
                    ),
                  ),

                  // Inputs
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: AutofillGroup(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Username
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    "username".i18n,
                                    maxLines: 1,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "usernameHint".i18n,
                                    maxLines: 1,
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                      color: Colors.white54,
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

                          // Password
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    "password".i18n,
                                    maxLines: 1,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "passwordHint".i18n,
                                    maxLines: 1,
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                      color: Colors.white54,
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

                          // School
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6.0),
                            child: Text(
                              "school".i18n,
                              maxLines: 1,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14.0,
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

                  // Log in button
                  Padding(
                    padding: const EdgeInsets.only(top: 42.0),
                    child: Visibility(
                      child: LoginButton(
                        child: Text("login".i18n,
                            maxLines: 1,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15.0,
                            )),
                        onPressed: () => _loginApi(context: context),
                      ),
                      visible: _loginState != LoginState.inProgress,
                      replacement: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 6.0),
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    ),
                  ),
                  if (_loginState == LoginState.missingFields || _loginState == LoginState.invalidGrant || _loginState == LoginState.failed)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        ["missing_fields", "invalid_grant", "error"][_loginState.index].i18n,
                        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
                      ),
                    ),
                  const Spacer()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _loginApi({required BuildContext context}) {
    String username = usernameController.text;
    String password = passwordController.text;

    if (username == "" || password == "" || schoolController.selectedSchool == null) {
      return setState(() => _loginState = LoginState.missingFields);
    }

    setState(() => _loginState = LoginState.inProgress);

    loginApi(
        username: username,
        password: password,
        instituteCode: schoolController.selectedSchool!.instituteCode,
        context: context,
        onLogin: (user) {
          ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(
            context: context,
            brightness: Brightness.light,
            content: Text("welcome".i18n.fill([user.name]), overflow: TextOverflow.ellipsis),
          ));
        },
        onSuccess: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          setSystemChrome(context);
          Navigator.of(context).pushReplacementNamed("login_to_navigation");
        }).then((res) => setState(() => _loginState = res));
  }
}
