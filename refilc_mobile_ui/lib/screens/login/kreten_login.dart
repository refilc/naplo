import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refilc_kreta_api/client/api.dart';
import 'package:refilc_kreta_api/client/client.dart';
import 'package:webview_flutter/webview_flutter.dart';

class KretenLoginScreen extends StatefulWidget {
  const KretenLoginScreen({super.key});

  @override
  State<KretenLoginScreen> createState() => _KretenLoginScreenState();
}

class _KretenLoginScreenState extends State<KretenLoginScreen> {
  late final WebViewController controller;
  var loadingPercentage = 0;
  var currentUrl = '';

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) async {
          setState(() {
            loadingPercentage = 0;
            currentUrl = url;
          });

          List<String> requiredThings = url
              .replaceAll(
                  'https://mobil.e-kreta.hu/ellenorzo-student/prod/oauthredirect?code=',
                  '')
              .replaceAll(
                  '&scope=openid email offline_access kreta-ellenorzo-webapi.public kreta-eugyintezes-webapi.public kreta-fileservice-webapi.public kreta-mobile-global-webapi.public kreta-dkt-webapi.public kreta-ier-webapi.public&state=refilc_student_mobile&session_state=',
                  ':')
              .split(':');

          String code = requiredThings[0];
          // String sessionState = requiredThings[1];

          debugPrint('url: $url');

          // actual login (token grant) logic
          Map<String, String> headers = {
            "content-type": "application/x-www-form-urlencoded",
            "accept": "*/*",
            "user-agent":
                "eKretaStudent/264745 CFNetwork/1494.0.7 Darwin/23.4.0",
            "code_verifier": "THDUSddKOOndwCkqBtVHvRjh2LK0V2kMyLP2QirqVWQ",
          };

          Map? res = await Provider.of<KretaClient>(context, listen: false)
              .postAPI(KretaAPI.login, headers: headers, body: {
            "code": code,
            "redirect_uri":
                "https://mobil.e-kreta.hu/ellenorzo-student/prod/oauthredirect",
            "client_id": "kreta-ellenorzo-student-mobile-ios",
            "grant_type": "authorization_code",
          });
          if (res != null) {
            if (kDebugMode) {
              print(res);
            }

            // if (res.containsKey("error")) {
            //   if (res["error"] == "invalid_grant") {
            //     print("ERROR: invalid_grant");
            //     return;
            //   }
            // } else {
            //   if (res.containsKey("access_token")) {
            //     try {
            //       Provider.of<KretaClient>(context, listen: false).accessToken =
            //           res["access_token"];
            //       Map? studentJson =
            //           await Provider.of<KretaClient>(context, listen: false)
            //               .getAPI(KretaAPI.student(instituteCode));
            //       Student student = Student.fromJson(studentJson!);
            //       var user = User(
            //         username: username,
            //         password: password,
            //         instituteCode: instituteCode,
            //         name: student.name,
            //         student: student,
            //         role: JwtUtils.getRoleFromJWT(res["access_token"])!,
            //       );

            //       if (onLogin != null) onLogin(user);

            //       // Store User in the database
            //       await Provider.of<DatabaseProvider>(context, listen: false)
            //           .store
            //           .storeUser(user);
            //       Provider.of<UserProvider>(context, listen: false)
            //           .addUser(user);
            //       Provider.of<UserProvider>(context, listen: false)
            //           .setUser(user.id);

            //       // Get user data
            //       try {
            //         await Future.wait([
            //           Provider.of<GradeProvider>(context, listen: false)
            //               .fetch(),
            //           Provider.of<TimetableProvider>(context, listen: false)
            //               .fetch(week: Week.current()),
            //           Provider.of<ExamProvider>(context, listen: false).fetch(),
            //           Provider.of<HomeworkProvider>(context, listen: false)
            //               .fetch(),
            //           Provider.of<MessageProvider>(context, listen: false)
            //               .fetchAll(),
            //           Provider.of<MessageProvider>(context, listen: false)
            //               .fetchAllRecipients(),
            //           Provider.of<NoteProvider>(context, listen: false).fetch(),
            //           Provider.of<EventProvider>(context, listen: false)
            //               .fetch(),
            //           Provider.of<AbsenceProvider>(context, listen: false)
            //               .fetch(),
            //         ]);
            //       } catch (error) {
            //         print("WARNING: failed to fetch user data: $error");
            //       }

            //       if (onSuccess != null) onSuccess();

            //       return LoginState.success;
            //     } catch (error) {
            //       print("ERROR: loginAPI: $error");
            //       // maybe check debug mode
            //       // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("ERROR: $error")));
            //       return LoginState.failed;
            //     }
            //   }
            // }
          }
        },
        onProgress: (progress) {
          setState(() {
            loadingPercentage = progress;
          });
        },
        onPageFinished: (url) {
          setState(() {
            loadingPercentage = 100;
          });
        },
      ))
      ..loadRequest(
        Uri.parse(
            'https://idp.e-kreta.hu/connect/authorize?prompt=login&nonce=refilc&response_type=code&code_challenge_method=S256&scope=openid%20email%20offline_access%20kreta-ellenorzo-webapi.public%20kreta-eugyintezes-webapi.public%20kreta-fileservice-webapi.public%20kreta-mobile-global-webapi.public%20kreta-dkt-webapi.public%20kreta-ier-webapi.public&code_challenge=Oj_aVMRJHYsv00mrtGJY72NJa7HY54lVnU2Cb4CWbWw&redirect_uri=https://mobil.e-kreta.hu/ellenorzo-student/prod/oauthredirect&client_id=kreta-ellenorzo-student-mobile-ios&state=refilc_student_mobile'),
      );
  }

  // Future<void> loadLoginUrl() async {
  //   String nonceStr = await Provider.of<KretaClient>(context, listen: false)
  //         .getAPI(KretaAPI.nonce, json: false);

  //     Nonce nonce = getNonce(nonceStr, );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('e-KRÉTA Bejelentkezés'),
      ),
      body: Stack(
        children: [
          WebViewWidget(
            controller: controller,
          ),
          if (loadingPercentage < 100)
            LinearProgressIndicator(
              value: loadingPercentage / 100.0,
            ),
        ],
      ),
    );
  }
}
