import 'dart:io';
import 'dart:ui';

import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:refilc/api/client.dart';
import 'package:refilc/api/login.dart';
import 'package:refilc_mobile_ui/screens/login/login_button.dart';
import 'package:refilc_mobile_ui/screens/login/login_input.dart';
import 'package:refilc_desktop_ui/screens/login/school_input/school_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'login_screen.i18n.dart';

const LinearGradient _backgroundGradient = LinearGradient(
  colors: [
    Color.fromARGB(255, 61, 122, 244),
    Color.fromARGB(255, 23, 77, 185),
    Color.fromARGB(255, 7, 42, 112),
  ],
  begin: Alignment(-0.8, -2.0),
  end: Alignment(0.8, 1.0),
  stops: [-1.0, 0.0, 1.0],
);

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
  double topInset = 12.0;

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
        ElegantNotification.error(
          background: Colors.white,
          description: Text(
            "schools_error".i18n,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.red),
          ),
          onActionPressed: () {},
          onCloseButtonPressed: () {},
          onDismiss: () {},
          onProgressFinished: () {},
          displayCloseButton: false,
          showProgressIndicator: false,
          autoDismiss: true,
          animation: AnimationType.fromTop,
        ).show(context);
      }
    });

    if (Platform.isMacOS) {
      Window.getTitlebarHeight()
          .then((value) => setState(() => topInset = value));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: _backgroundGradient,
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // App logo
                        Padding(
                          padding: const EdgeInsets.only(bottom: 24.0),
                          child: ClipRect(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 12.0, right: 12.0, bottom: 32.0),
                              child: SizedBox(
                                width: 100.0,
                                height: 100.0,
                                // Png shadow *hack*
                                child: Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Opacity(
                                          opacity: 0.3,
                                          child: Image.asset(
                                              "assets/icons/ic_splash.png",
                                              color: Colors.black)),
                                    ),
                                    BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 6.0, sigmaY: 6.0),
                                      child: Image.asset(
                                          "assets/icons/ic_splash.png"),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Inputs
                        SizedBox(
                          width: 400.0,
                          child: AutofillGroup(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Username
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 6.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                        SizedBox(
                          width: 400.0,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 42.0),
                            child: Visibility(
                              visible: _loginState != LoginState.inProgress,
                              replacement: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 6.0),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                ),
                              ),
                              child: LoginButton(
                                child: Text("login".i18n,
                                    maxLines: 1,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15.0,
                                    )),
                                onPressed: () => _loginAPI(context: context),
                              ),
                            ),
                          ),
                        ),
                        if (_loginState == LoginState.missingFields ||
                            _loginState == LoginState.invalidGrant ||
                            _loginState == LoginState.failed)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              [
                                "missing_fields",
                                "invalid_grant",
                                "error"
                              ][_loginState.index]
                                  .i18n,
                              style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              if (showBack)
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(left: 16.0, top: topInset),
                  child: const ClipOval(
                    child: Material(
                      type: MaterialType.transparency,
                      child: BackButton(color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _loginAPI({required BuildContext context}) {
    String username = usernameController.text;
    String password = passwordController.text;

    if (username == "" ||
        password == "" ||
        schoolController.selectedSchool == null) {
      return setState(() => _loginState = LoginState.missingFields);
    }

    setState(() => _loginState = LoginState.inProgress);

    loginAPI(
        username: username,
        password: password,
        instituteCode: schoolController.selectedSchool!.instituteCode,
        context: context,
        onLogin: (user) {
          ElegantNotification.success(
            background: Colors.white,
            description: Text(
              "welcome".i18n.fill([user.name]),
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.black),
            ),
            onActionPressed: () {},
            onCloseButtonPressed: () {},
            onDismiss: () {},
            onProgressFinished: () {},
            displayCloseButton: false,
            showProgressIndicator: false,
            autoDismiss: true,
            animation: AnimationType.fromTop,
          ).show(context);
        },
        onSuccess: () {
          Navigator.of(context)
              .pushNamedAndRemoveUntil("login_to_navigation", (_) => false);
        }).then((res) => setState(() => _loginState = res));
  }
}
