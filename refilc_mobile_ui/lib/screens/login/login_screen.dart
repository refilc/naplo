// import 'dart:async';

import 'package:refilc/api/client.dart';
import 'package:refilc/api/login.dart';
import 'package:refilc/theme/colors/colors.dart';
import 'package:refilc_mobile_ui/common/custom_snack_bar.dart';
import 'package:refilc_mobile_ui/common/system_chrome.dart';
import 'package:refilc_mobile_ui/screens/login/school_input/school_input.dart';
import 'package:refilc_mobile_ui/screens/settings/privacy_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'login_screen.i18n.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:refilc_mobile_ui/screens/login/kreten_login.dart'; //new library for new web login

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
  // new controllers
  final codeController = TextEditingController();
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
    precacheImage(const AssetImage('assets/images/showcase1.png'), context);
    precacheImage(const AssetImage('assets/images/showcase2.png'), context);
    precacheImage(const AssetImage('assets/images/showcase3.png'), context);
    precacheImage(const AssetImage('assets/images/showcase4.png'), context);
    // bool selected = false;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: Color(0xFFDAE4F7)),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          controller: _scrollController,
          child: Container(
            decoration: const BoxDecoration(color: Color(0xFFDAE4F7)),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SafeArea(
              child: Column(
                children: [
                  // app icon
                  Padding(
                      padding: const EdgeInsets.only(left: 24, top: 20),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/icons/ic_rounded.png',
                            width: 30.0,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'reFilc',
                            style: TextStyle(
                                color: Color(0xFF050B15),
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat'),
                          ),
                          Material(
                            type: MaterialType.transparency,
                            child: showBack
                                ? BackButton(color: AppColors.of(context).text)
                                : const SizedBox(height: 48.0),
                          ),
                        ],
                      )),
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Column(
                        //login buttons and ui starts here
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const SizedBox(height: 21),
                          CarouselSlider(
                            options: CarouselOptions(
                                height: MediaQuery.of(context).size.height,
                                viewportFraction: 1,
                                autoPlay: true,
                                autoPlayInterval: const Duration(seconds: 6),
                                pauseAutoPlayOnTouch: true),
                            items: [1, 2, 3, 4].map((i) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                          padding:
                                              const EdgeInsets.only(left: 24),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                "welcome_title_$i".i18n,
                                                style: const TextStyle(
                                                    color: Color(0xFF050B15),
                                                    fontSize: 19,
                                                    fontFamily: 'Montserrat',
                                                    fontWeight: FontWeight.w700,
                                                    height: 1.3),
                                              ),
                                              const SizedBox(
                                                  height: 14.375), //meth
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 20),
                                                child: Text(
                                                  "welcome_text_$i".i18n,
                                                  style: const TextStyle(
                                                      color: Color(0xFF050B15),
                                                      fontFamily: 'FigTree',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 17,
                                                      height: 1.3),
                                                ),
                                              ),
                                            ],
                                          )),
                                      const SizedBox(height: 15.625),
                                      Padding(
                                          padding: const EdgeInsets.only(
                                              left: 16, right: 16),
                                          child: Image.asset(
                                              'assets/images/showcase$i.png'))
                                    ],
                                  );
                                },
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      Container(
                        height: 300,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0x00DAE4F7), Color(0xFFDAE4F7)],
                            stops: [0, 0.12],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 50,
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 48,
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: FilledButton(
                                      style: ButtonStyle(
                                          shape: WidgetStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12)),
                                      ))),
                                      onPressed: () {
                                        final NavigatorState navigator =
                                            Navigator.of(context);
                                        navigator
                                            .push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                KretenLoginScreen(
                                              onLogin: (String code) {
                                                codeController.text = code;
                                                navigator.pop();
                                              },
                                            ),
                                          ),
                                        )
                                            .then((value) {
                                          if (codeController.text != "") {
                                            _NewLoginAPI(context: context);
                                          }
                                        });
                                      },
                                      child: Text(
                                        "login".i18n,
                                        style: const TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700),
                                      )),
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

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

  // new login api
  void _NewLoginAPI({required BuildContext context}) {
    String code = codeController.text;

    if (code == "") {
      return setState(() => _loginState = LoginState.failed);
    }

    // ignore: no_leading_underscores_for_local_identifiers
    void _callAPI() {
      newLoginAPI(
          code: code,
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
