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
import 'package:filcnaplo/utils/jwt.dart';
import 'package:filcnaplo_kreta_api/client/api.dart';
import 'package:filcnaplo_kreta_api/client/client.dart';
import 'package:filcnaplo_kreta_api/models/message.dart';
import 'package:filcnaplo_kreta_api/models/student.dart';
import 'package:filcnaplo_kreta_api/models/week.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:filcnaplo/api/nonce.dart';

enum LoginState { normal, inProgress, missingFields, invalidGrant, success, failed }

Nonce getNonce(BuildContext context, String nonce, String username, String instituteCode) {
  Nonce nonceEncoder = Nonce(key: [53, 75, 109, 112, 109, 103, 100, 53, 102, 74], nonce: nonce);
  nonceEncoder.encode(username.toLowerCase() + instituteCode.toLowerCase() + nonce);

  return nonceEncoder;
}

Future loginApi({
  required String username,
  required String password,
  required String instituteCode,
  required BuildContext context,
  void Function(User)? onLogin,
  void Function()? onSuccess,
}) async {
  Provider.of<KretaClient>(context, listen: false).userAgent = Provider.of<SettingsProvider>(context, listen: false).config.userAgent;

  Map<String, String> headers = {
    "content-type": "application/x-www-form-urlencoded",
  };

  String nonceStr = await Provider.of<KretaClient>(context, listen: false).getAPI(KretaAPI.nonce, json: false);

  Nonce nonce = getNonce(context, nonceStr, username, instituteCode);
  headers.addAll(nonce.header());

  Map? res = await Provider.of<KretaClient>(context, listen: false).postAPI(KretaAPI.login,
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
          Provider.of<KretaClient>(context, listen: false).accessToken = res["access_token"];
          Map? studentJson = await Provider.of<KretaClient>(context, listen: false).getAPI(KretaAPI.student(instituteCode));
          var user = User(
            username: username,
            password: password,
            instituteCode: instituteCode,
            name: JwtUtils.getNameFromJWT(res["access_token"]) ?? "?",
            student: Student.fromJson(studentJson!),
          );

          if (onLogin != null) onLogin(user);

          // Store User in the database
          await Provider.of<DatabaseProvider>(context, listen: false).store.storeUser(user);
          Provider.of<UserProvider>(context, listen: false).addUser(user);
          Provider.of<UserProvider>(context, listen: false).setUser(user.id);

          // Get user data
          try {
            await Provider.of<GradeProvider>(context, listen: false).fetch();
            await Provider.of<TimetableProvider>(context, listen: false).fetch(week: Week.current());
            await Provider.of<ExamProvider>(context, listen: false).fetch();
            await Provider.of<HomeworkProvider>(context, listen: false).fetch();
            await Provider.of<MessageProvider>(context, listen: false).fetch(type: MessageType.inbox);
            await Provider.of<NoteProvider>(context, listen: false).fetch();
            await Provider.of<EventProvider>(context, listen: false).fetch();
            await Provider.of<AbsenceProvider>(context, listen: false).fetch();
          } catch (error) {
            print("WARNING: failed to fetch user data: $error");
          }

          if (onSuccess != null) onSuccess();

          return LoginState.success;
        } catch (error) {
          print("ERROR: loginApi: $error");
          // maybe check debug mode
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("ERROR: $error")));
          return LoginState.failed;
        }
      }
    }
  }
  return LoginState.failed;
}
