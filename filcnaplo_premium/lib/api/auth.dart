import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:filcnaplo/api/client.dart';
import 'package:filcnaplo/models/settings.dart';
import 'package:filcnaplo_premium/models/premium_result.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uni_links/uni_links.dart';
import 'package:http/http.dart' as http;
import 'package:home_widget/home_widget.dart';

class PremiumAuth {
  final SettingsProvider _settings;
  StreamSubscription? _sub;

  PremiumAuth({required SettingsProvider settings}) : _settings = settings;

  initAuth() {
    try {
      _sub ??= uriLinkStream.listen(
        (Uri? uri) {
          if (uri != null && uri.path == '/v2/premium/callback') {
            final accessToken = uri.queryParameters['access_token'];
            if (accessToken != null) {
              finishAuth(accessToken);
            }
          }
        },
        onError: (err) {
          log("ERROR: initAuth: $err");
        },
      );

      launchUrl(
        Uri.parse(FilcAPI.premiumLoginApi),
        mode: LaunchMode.externalApplication,
      );
    } catch (err, sta) {
      log("ERROR: initAuth: $err\n$sta");
    }
  }

  Future<bool> finishAuth(String accessToken) async {
    try {
      final res = await http.get(Uri.parse(
          "${FilcAPI.premiumScopesApi}?access_token=${Uri.encodeComponent(accessToken)}"));
      final scopes =
          ((jsonDecode(res.body) as Map)["scopes"] as List).cast<String>();
      log("[INFO] Premium auth finish: ${scopes.join(',')}");
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
    if (!removePremium) {
      if (_settings.premiumAccessToken == "") {
        await _settings.update(premiumScopes: [], premiumLogin: "");
        return false;
      }

      // Skip premium check when disconnected
      try {
        final status = await InternetAddress.lookup('api.refilc.hu');
        if (status.isEmpty) return false;
      } on SocketException catch (_) {
        return false;
      }

      for (int tries = 0; tries < 3; tries++) {
        try {
          final res =
              await http.post(Uri.parse(FilcAPI.premiumActivateApi), body: {
            "access_token": _settings.premiumAccessToken,
          });

          if (res.body == "") throw "empty body";

          final premium = PremiumResult.fromJson(jsonDecode(res.body) as Map);
          // Activation succeeded
          log("[INFO] Premium activated: ${premium.scopes.join(',')}");
          await _settings.update(
            premiumAccessToken: premium.accessToken,
            premiumScopes: premium.scopes,
            premiumLogin: premium.login,
          );
          return true;
        } catch (err, sta) {
          log("[ERROR] Premium activation failed: $err\n$sta");
        }

        await Future.delayed(const Duration(seconds: 1));
      }
    }

    // Activation failed
    await _settings.update(
        premiumAccessToken: "", premiumScopes: [], premiumLogin: "");
    return false;
  }
}
