// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class QwIDLoginWidget extends StatefulWidget {
  const QwIDLoginWidget({super.key, required this.onLogin});

  // final String selectedSchool;
  final void Function(String code) onLogin;

  @override
  State<QwIDLoginWidget> createState() => _QwIDLoginWidgetState();
}

class _QwIDLoginWidgetState extends State<QwIDLoginWidget>
    with TickerProviderStateMixin {
  late final WebViewController controller;
  late AnimationController _animationController;
  var loadingPercentage = 0;
  var currentUrl = '';
  bool _hasFadedIn = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this, // Use the TickerProviderStateMixin
      duration: const Duration(milliseconds: 350),
    );

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onNavigationRequest: (n) async {
          if (n.url.startsWith('refilc://oauth2-callback/qwid')) {
            setState(() {
              loadingPercentage = 0;
              currentUrl = n.url;
            });

            // final String instituteCode = widget.selectedSchool;
            // if (!n.url.startsWith(
            //     'https://mobil.e-kreta.hu/ellenorzo-student/prod/oauthredirect?code=')) {
            //   return;
            // }

            String longLivedToken = n.url
                .replaceAll('refilc://oauth2-callback/qwid?access_token=', '');

            widget.onLogin(longLivedToken);
            // Future.delayed(const Duration(milliseconds: 500), () {
            //   Navigator.of(context).pop();
            // });
            // Navigator.of(context).pop();

            return NavigationDecision.prevent;
          } else {
            return NavigationDecision.navigate;
          }
        },
        onPageStarted: (url) async {
          // setState(() {
          //   loadingPercentage = 0;
          //   currentUrl = url;
          // });

          // // final String instituteCode = widget.selectedSchool;
          // if (!url.startsWith(
          //     'https://mobil.e-kreta.hu/ellenorzo-student/prod/oauthredirect?code=')) {
          //   return;
          // }

          // List<String> requiredThings = url
          //     .replaceAll(
          //         'https://mobil.e-kreta.hu/ellenorzo-student/prod/oauthredirect?code=',
          //         '')
          //     .replaceAll(
          //         '&scope=openid%20email%20offline_access%20kreta-ellenorzo-webapi.public%20kreta-eugyintezes-webapi.public%20kreta-fileservice-webapi.public%20kreta-mobile-global-webapi.public%20kreta-dkt-webapi.public%20kreta-ier-webapi.public&state=refilc_student_mobile&session_state=',
          //         ':')
          //     .split(':');

          // String code = requiredThings[0];
          // // String sessionState = requiredThings[1];

          // widget.onLogin(code);
          // // Future.delayed(const Duration(milliseconds: 500), () {
          // //   Navigator.of(context).pop();
          // // });
          // // Navigator.of(context).pop();
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
            'https://qwid.qwit.dev/oauth2/authorize?client_id=c3b871fb-d922-4e23-b94d-b31f294c9253&scope=*&redirect_uri=https://api.refilc.hu/v4/oauth2/callback/app/qwid&response_type=code'), // &institute_code=${widget.selectedSchool}
      );
  }

  // Future<void> loadLoginUrl() async {
  //   String nonceStr = await Provider.of<KretaClient>(context, listen: false)
  //         .getAPI(KretaAPI.nonce, json: false);

  //     Nonce nonce = getNonce(nonceStr, );
  // }

  @override
  void dispose() {
    // Step 3: Dispose of the animation controller
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Trigger the fade-in animation only once when loading reaches 100%
    if (loadingPercentage == 100 && !_hasFadedIn) {
      _animationController.forward(); // Play the animation
      _hasFadedIn =
          true; // Set the flag to true, so the animation is not replayed
    }

    return Stack(
      children: [
        // Webview that will be displayed only when the loading is 100%
        if (loadingPercentage == 100)
          FadeTransition(
            opacity: Tween<double>(begin: 0, end: 1).animate(
              CurvedAnimation(
                parent: _animationController,
                curve: Curves.easeIn,
              ),
            ),
            child: WebViewWidget(
              controller: controller,
            ),
          ),

        // Show the CircularProgressIndicator while loading is not 100%
        if (loadingPercentage < 100)
          Center(
            child: TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: loadingPercentage / 100.0),
              duration: const Duration(milliseconds: 300),
              builder: (context, double value, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: value, // Smoothly animates the progress
                    ),
                  ],
                );
              },
            ),
          ),
      ],
    );
  }
}
