import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:refilc/models/settings.dart';
import 'package:refilc_premium/models/premium_scopes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:home_widget/home_widget.dart';

class PremiumAuth {
  final SettingsProvider _settings;

  PremiumAuth({required SettingsProvider settings}) : _settings = settings;

  initAuth() {
    finishAuth("igen");
    // try {
    //   _sub ??= uriLinkStream.listen(
    //     (Uri? uri) {
    //       if (uri != null) {
    //         final accessToken = uri.queryParameters['access_token'];
    //         if (accessToken != null) {
    //           finishAuth(accessToken);
    //         }
    //       }
    //     },
    //     onError: (err) {
    //       log("ERROR: initAuth: $err");
    //     },
    //   );

    //   launchUrl(
    //     Uri.parse("https://api.refilc.hu/oauth"),
    //     mode: LaunchMode.externalApplication,
    //   );
    // } catch (err, sta) {
    //   log("ERROR: initAuth: $err\n$sta");
    // }
  }

  Future<bool> finishAuth(String accessToken) async {
    try {
      // final res = await http.get(Uri.parse("${FilcAPI.premiumScopesApi}?access_token=${Uri.encodeComponent(accessToken)}"));
      // final scopes = ((jsonDecode(res.body) as Map)["scopes"] as List).cast<String>();
      // log("[INFO] Premium auth finish: ${scopes.join(',')}");
      await _settings.update(premiumAccessToken: accessToken);
      final result = await refreshAuth();
      if (Platform.isAndroid) updateWidget();
      return result;
    } catch (err, sta) {
      log("[ERROR] Premium auth failed: $err\n$sta");
    }

    await _settings.update(premiumAccessToken: "", premiumScopes: []);
    if (Platform.isAndroid) updateWidget();
    return false;
  }

  Future<bool?> updateWidget() async {
    try {
      return HomeWidget.updateWidget(name: 'widget_timetable.WidgetTimetable');
    } on PlatformException catch (exception) {
      if (kDebugMode) {
        print('Error Updating Widget After Auth. $exception');
      }
    }
    return false;
  }

  Future<bool> refreshAuth({bool removePremium = false}) async {
    await _settings.update(
      premiumAccessToken: "igen",
      premiumScopes: [PremiumScopes.all],
      premiumLogin: "igen",
    );
    return true;
    //if (!removePremium) {
    //if (_settings.premiumAccessToken == "") {
    //  await _settings.update(premiumScopes: [], premiumLogin: "");
    //  return false;
    //}

    // Skip premium check when disconnected
    //try {
    //  final status = await InternetAddress.lookup('github.com');
    //  if (status.isEmpty) return false;
    //} on SocketException catch (_) {
    //  return false;
    //}

    //for (int tries = 0; tries < 3; tries++) {
    //  try {
    //    final res = await http.post(Uri.parse(FilcAPI.premiumApi), body: {
    //      "access_token": _settings.premiumAccessToken,
    //    });
//
    //    if (res.body == "") throw "empty body";

    //    final premium = PremiumResult.fromJson(jsonDecode(res.body) as Map);
    // Activation succeeded
    //    log("[INFO] Premium activated: ${premium.scopes.join(',')}");
    //    await _settings.update(
    //      premiumAccessToken: premium.accessToken,
    //      premiumScopes: premium.scopes,
    //      premiumLogin: premium.login,
    //    );
    //    return true;
    //  } catch (err, sta) {
    //    log("[ERROR] Premium activation failed: $err\n$sta");
    //  }

    //  await Future.delayed(const Duration(seconds: 1));
    //
    //}

    // Activation failed
    //await _settings.update(
    //    premiumAccessToken: "igen",
    //    premiumScopes: [PremiumScopes.all],
    //    premiumLogin: "igen");
    //return false;
  }
}
