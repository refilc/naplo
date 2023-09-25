// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:filcnaplo/utils/jwt.dart';
import 'package:filcnaplo_kreta_api/models/school.dart';
import 'package:filcnaplo_kreta_api/providers/absence_provider.dart';
import 'package:filcnaplo_kreta_api/providers/event_provider.dart';
import 'package:filcnaplo_kreta_api/providers/exam_provider.dart';
import 'package:filcnaplo_kreta_api/providers/grade_provider.dart';
import 'package:filcnaplo_kreta_api/providers/homework_provider.dart';
import 'package:filcnaplo_kreta_api/providers/message_provider.dart';
import 'package:filcnaplo_kreta_api/providers/note_provider.dart';
import 'package:filcnaplo_kreta_api/providers/timetable_provider.dart';
import 'package:filcnaplo/api/providers/user_provider.dart';
import 'package:filcnaplo/api/providers/database_provider.dart';
import 'package:filcnaplo/models/settings.dart';
import 'package:filcnaplo/models/user.dart';
import 'package:filcnaplo_kreta_api/client/api.dart';
import 'package:filcnaplo_kreta_api/client/client.dart';
import 'package:filcnaplo_kreta_api/models/student.dart';
import 'package:filcnaplo_kreta_api/models/week.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:filcnaplo/api/nonce.dart';
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
      ),
      role: Role.parent,
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
  if (instituteCode == 'refilc-test-sweden') {
    School school = School(
      city: "Stockholm",
      instituteCode: "refilc-test-sweden",
      name: "reFilc Test SE - Leo Ekström High School",
    );

    await testLogin(school);
  } else if (instituteCode == 'refilc-test-spain') {
    School school = School(
      city: "Madrid",
      instituteCode: "refilc-test-spain",
      name: "reFilc Test ES - Emilio Obrero University",
    );

    await testLogin(school);
  } else {
    // normal login from here
    Provider.of<KretaClient>(context, listen: false).userAgent =
        Provider.of<SettingsProvider>(context, listen: false).config.userAgent;

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
  }

  return LoginState.failed;
}
