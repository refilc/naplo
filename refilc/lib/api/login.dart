// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:refilc/utils/jwt.dart';
import 'package:refilc_kreta_api/models/school.dart';
import 'package:refilc_kreta_api/providers/absence_provider.dart';
import 'package:refilc_kreta_api/providers/event_provider.dart';
import 'package:refilc_kreta_api/providers/exam_provider.dart';
import 'package:refilc_kreta_api/providers/grade_provider.dart';
import 'package:refilc_kreta_api/providers/homework_provider.dart';
import 'package:refilc_kreta_api/providers/message_provider.dart';
import 'package:refilc_kreta_api/providers/note_provider.dart';
import 'package:refilc_kreta_api/providers/timetable_provider.dart';
import 'package:refilc/api/providers/user_provider.dart';
import 'package:refilc/api/providers/database_provider.dart';
import 'package:refilc/models/settings.dart';
import 'package:refilc/models/user.dart';
import 'package:refilc_kreta_api/client/api.dart';
import 'package:refilc_kreta_api/client/client.dart';
import 'package:refilc_kreta_api/models/student.dart';
import 'package:refilc_kreta_api/models/week.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refilc/api/nonce.dart';
import 'package:uuid/uuid.dart';

enum LoginState {
  missingFields,
  invalidGrant,
  failed,
  normal,
  inProgress,
  success,
}

Nonce getNonce(String nonce, String username, String instituteCode) {
  Nonce nonceEncoder = Nonce(
      key: [98, 97, 83, 115, 120, 79, 119, 108, 85, 49, 106, 77], nonce: nonce);
  nonceEncoder
      .encode(instituteCode.toUpperCase() + nonce + username.toUpperCase());

  return nonceEncoder;
}

Future loginAPI({
  required String username,
  required String password,
  required String instituteCode,
  required BuildContext context,
  void Function(User)? onLogin,
  void Function()? onSuccess,
}) async {
  Future testLogin(School school) async {
    var user = User(
      username: username,
      password: password,
      instituteCode: instituteCode,
      name: 'Teszt Lajos',
      student: Student(
        birth: DateTime.now(),
        id: const Uuid().v4(),
        name: 'Teszt Lajos',
        school: school,
        yearId: '1',
        parents: ['Teszt András', 'Teszt Linda'],
        json: {"a": "b"},
        address: '1117 Budapest, Gábor Dénes utca 4.',
        gradeDelay: 0,
      ),
      role: Role.parent,
      accessToken: '',
      accessTokenExpire: DateTime.now(),
      refreshToken: '',
    );

    if (onLogin != null) onLogin(user);

    // store test user in db
    await Provider.of<DatabaseProvider>(context, listen: false)
        .store
        .storeUser(user);
    Provider.of<UserProvider>(context, listen: false).addUser(user);
    Provider.of<UserProvider>(context, listen: false).setUser(user.id);

    if (onSuccess != null) onSuccess();

    return LoginState.success;
  }

  // if institute matches one of test things do test login
  switch (instituteCode) {
    // by using a switch statement we are saving a whopping 0.0000001 seconds
    // (actually it just makes it easier to add more test schools later on)
    case 'refilc-test-sweden':
      School school = School(
        city: "Stockholm",
        instituteCode: "refilc-test-sweden",
        name: "reFilc Test SE - Leo Ekström High School",
      );

      await testLogin(school);
      break;
    case 'refilc-test-spain':
      School school = School(
        city: "Madrid",
        instituteCode: "refilc-test-spain",
        name: "reFilc Test ES - Emilio Obrero University",
      );

      await testLogin(school);
      break;
    default:
      // normal login from here
      Provider.of<KretaClient>(context, listen: false).userAgent =
          Provider.of<SettingsProvider>(context, listen: false)
              .config
              .userAgent;

      Map<String, String> headers = {
        "content-type": "application/x-www-form-urlencoded",
      };

      String nonceStr = await Provider.of<KretaClient>(context, listen: false)
          .getAPI(KretaAPI.nonce, json: false);

      Nonce nonce = getNonce(nonceStr, username, instituteCode);
      headers.addAll(nonce.header());

      Map? res = await Provider.of<KretaClient>(context, listen: false)
          .postAPI(KretaAPI.login,
              headers: headers,
              body: User.loginBody(
                username: username,
                password: password,
                instituteCode: instituteCode,
              ));

      if (res != null) {
        if (res.containsKey("error")) {
          if (res["error"] == "invalid_grant") {
            return LoginState.invalidGrant;
          }
        } else {
          if (res.containsKey("access_token")) {
            try {
              Provider.of<KretaClient>(context, listen: false).accessToken =
                  res["access_token"];
              Map? studentJson =
                  await Provider.of<KretaClient>(context, listen: false)
                      .getAPI(KretaAPI.student(instituteCode));
              Student student = Student.fromJson(studentJson!);
              var user = User(
                username: username,
                password: password,
                instituteCode: instituteCode,
                name: student.name,
                student: student,
                role: JwtUtils.getRoleFromJWT(res["access_token"])!,
                accessToken: res["access_token"],
                accessTokenExpire: DateTime.now(),
                refreshToken: '',
              );

              if (onLogin != null) onLogin(user);

              // Store User in the database
              await Provider.of<DatabaseProvider>(context, listen: false)
                  .store
                  .storeUser(user);
              Provider.of<UserProvider>(context, listen: false).addUser(user);
              Provider.of<UserProvider>(context, listen: false)
                  .setUser(user.id);

              // Get user data
              try {
                await Future.wait([
                  Provider.of<GradeProvider>(context, listen: false).fetch(),
                  Provider.of<TimetableProvider>(context, listen: false)
                      .fetch(week: Week.current()),
                  Provider.of<ExamProvider>(context, listen: false).fetch(),
                  Provider.of<HomeworkProvider>(context, listen: false).fetch(),
                  Provider.of<MessageProvider>(context, listen: false)
                      .fetchAll(),
                  Provider.of<MessageProvider>(context, listen: false)
                      .fetchAllRecipients(),
                  Provider.of<NoteProvider>(context, listen: false).fetch(),
                  Provider.of<EventProvider>(context, listen: false).fetch(),
                  Provider.of<AbsenceProvider>(context, listen: false).fetch(),
                ]);
              } catch (error) {
                print("WARNING: failed to fetch user data: $error");
              }

              if (onSuccess != null) onSuccess();

              return LoginState.success;
            } catch (error) {
              print("ERROR: loginAPI: $error");
              // maybe check debug mode
              // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("ERROR: $error")));
              return LoginState.failed;
            }
          }
        }
      }
      break;
  }

  return LoginState.failed;
}

// new login api
Future newLoginAPI({
  required String code,
  required BuildContext context,
  void Function(User)? onLogin,
  void Function()? onSuccess,
}) async {
  // actual login (token grant) logic
  Provider.of<KretaClient>(context, listen: false).userAgent =
      Provider.of<SettingsProvider>(context, listen: false).config.userAgent;

  Map<String, String> headers = {
    "content-type": "application/x-www-form-urlencoded; charset=UTF-8",
    "accept": "*/*",
    "user-agent": "eKretaStudent/264745 CFNetwork/1494.0.7 Darwin/23.4.0",
  };

  Map? res = await Provider.of<KretaClient>(context, listen: false)
      .postAPI(KretaAPI.login, headers: headers, body: {
    "code": code,
    "code_verifier": "DSpuqj_HhDX4wzQIbtn8lr8NLE5wEi1iVLMtMK0jY6c",
    "redirect_uri":
        "https://mobil.e-kreta.hu/ellenorzo-student/prod/oauthredirect",
    "client_id": KretaAPI.clientId,
    "grant_type": "authorization_code",
  });

  if (res != null) {
    if (kDebugMode) {
      print(res);

      // const splitSize = 1000;
      // RegExp exp = RegExp(r"\w{" "$splitSize" "}");
      // // String str = "0102031522";
      // Iterable<Match> matches = exp.allMatches(res.toString());
      // var list = matches.map((m) => m.group(0));
      // list.forEach((e) {
      //   print(e);
      // });
    }

    if (res.containsKey("error")) {
      if (res["error"] == "invalid_grant") {
        print("ERROR: invalid_grant");
        return;
      }
    } else {
      if (res.containsKey("access_token")) {
        try {
          Provider.of<KretaClient>(context, listen: false).accessToken =
              res["access_token"];
          Provider.of<KretaClient>(context, listen: false).refreshToken =
              res["refresh_token"];

          String instituteCode =
              JwtUtils.getInstituteFromJWT(res["access_token"])!;
          String username = JwtUtils.getUsernameFromJWT(res["access_token"])!;
          Role role = JwtUtils.getRoleFromJWT(res["access_token"])!;

          Map? studentJson =
              await Provider.of<KretaClient>(context, listen: false)
                  .getAPI(KretaAPI.student(instituteCode));
          Student student = Student.fromJson(studentJson!);

          var user = User(
            username: username,
            password: '',
            instituteCode: instituteCode,
            name: student.name,
            student: student,
            role: role,
            accessToken: res["access_token"],
            accessTokenExpire:
                DateTime.now().add(Duration(seconds: (res["expires_in"] - 30))),
            refreshToken: res["refresh_token"],
          );

          if (onLogin != null) onLogin(user);

          // Store User in the database
          await Provider.of<DatabaseProvider>(context, listen: false)
              .store
              .storeUser(user);
          Provider.of<UserProvider>(context, listen: false).addUser(user);
          Provider.of<UserProvider>(context, listen: false).setUser(user.id);

          // Get user data
          try {
            await Future.wait([
              Provider.of<GradeProvider>(context, listen: false).fetch(),
              Provider.of<TimetableProvider>(context, listen: false)
                  .fetch(week: Week.current()),
              Provider.of<ExamProvider>(context, listen: false).fetch(),
              Provider.of<HomeworkProvider>(context, listen: false).fetch(),
              Provider.of<MessageProvider>(context, listen: false).fetchAll(),
              Provider.of<MessageProvider>(context, listen: false)
                  .fetchAllRecipients(),
              Provider.of<NoteProvider>(context, listen: false).fetch(),
              Provider.of<EventProvider>(context, listen: false).fetch(),
              Provider.of<AbsenceProvider>(context, listen: false).fetch(),
            ]);
          } catch (error) {
            print("WARNING: failed to fetch user data: $error");
          }

          if (onSuccess != null) onSuccess();

          return LoginState.success;
        } catch (error) {
          print("ERROR: loginAPI: $error");
          // maybe check debug mode
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("ERROR: $error")));
          return LoginState.failed;
        }
      }
    }
  }

  return LoginState.failed;
}
