import 'dart:convert';
import 'dart:developer';

import 'package:refilc/models/ad.dart';
import 'package:refilc/models/config.dart';
import 'package:refilc/models/news.dart';
import 'package:refilc/models/release.dart';
import 'package:refilc/models/settings.dart';
import 'package:refilc/models/supporter.dart';
import 'package:refilc_kreta_api/models/school.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

class FilcAPI {
  // Public API
  static const schoolList = "https://api.refilc.hu/v1/public/school-list";
  static const news = "https://api.refilc.hu/v1/public/news";
  static const supporters = "https://api.refilc.hu/v1/public/supporters";

  // Private API
  static const ads = "https://api.refilc.hu/v1/private/ads";
  static const config = "https://api.refilc.hu/v1/private/config";
  static const reportApi = "https://api.refilc.hu/v1/private/crash-report";
  static const premiumApi = "https://api.refilc.hu/premium/activate";
  // static const premiumScopesApi = "https://api.refilc.hu/premium/scopes";

  // Updates
  static const repo = "refilc/naplo";
  static const releases = "https://api.github.com/repos/$repo/releases";

  static Future<bool> checkConnectivity() async =>
      (await Connectivity().checkConnectivity()) != ConnectivityResult.none;

  static Future<List<School>?> getSchools() async {
    try {
      http.Response res = await http.get(Uri.parse(schoolList));

      if (res.statusCode == 200) {
        List<School> schools = (jsonDecode(res.body) as List)
            .cast<Map>()
            .map((json) => School.fromJson(json))
            .toList();
        schools.add(School(
          city: "Tiszabura",
          instituteCode: "supporttest-reni-tiszabura-teszt01",
          name: "FILC Éles Reni tiszabura-teszt",
        ));
        return schools;
      } else {
        throw "HTTP ${res.statusCode}: ${res.body}";
      }
    } on Exception catch (error, stacktrace) {
      log("ERROR: FilcAPI.getSchools: $error $stacktrace");
    }
    return null;
  }

  static Future<Config?> getConfig(SettingsProvider settings) async {
    final userAgent = SettingsProvider.defaultSettings().config.userAgent;

    Map<String, String> headers = {
      "x-filc-id": settings.xFilcId,
      "user-agent": userAgent,
    };

    log("[CONFIG] x-filc-id: \"${settings.xFilcId}\"");
    log("[CONFIG] user-agent: \"$userAgent\"");

    try {
      http.Response res = await http.get(Uri.parse(config), headers: headers);

      if (res.statusCode == 200) {
        if (kDebugMode) {
          print(jsonDecode(res.body));
        }
        return Config.fromJson(jsonDecode(res.body));
      } else if (res.statusCode == 429) {
        res = await http.get(Uri.parse(config));
        if (res.statusCode == 200) return Config.fromJson(jsonDecode(res.body));
      }
      throw "HTTP ${res.statusCode}: ${res.body}";
    } on Exception catch (error, stacktrace) {
      log("ERROR: FilcAPI.getConfig: $error $stacktrace");
    }
    return null;
  }

  static Future<List<News>?> getNews() async {
    try {
      http.Response res = await http.get(Uri.parse(news));

      if (res.statusCode == 200) {
        return (jsonDecode(res.body) as List)
            .cast<Map>()
            .map((e) => News.fromJson(e))
            .toList();
      } else {
        throw "HTTP ${res.statusCode}: ${res.body}";
      }
    } on Exception catch (error, stacktrace) {
      log("ERROR: FilcAPI.getNews: $error $stacktrace");
    }
    return null;
  }

  static Future<Supporters?> getSupporters() async {
    try {
      http.Response res = await http.get(Uri.parse(supporters));

      if (res.statusCode == 200) {
        return Supporters.fromJson(jsonDecode(res.body));
      } else {
        throw "HTTP ${res.statusCode}: ${res.body}";
      }
    } on Exception catch (error, stacktrace) {
      log("ERROR: FilcAPI.getSupporters: $error $stacktrace");
    }
    return null;
  }

  static Future<List<Ad>?> getAds() async {
    try {
      http.Response res = await http.get(Uri.parse(ads));

      if (res.statusCode == 200) {
        return (jsonDecode(res.body) as List)
            .cast<Map>()
            .map((e) => Ad.fromJson(e))
            .toList();
      } else {
        throw "HTTP ${res.statusCode}: ${res.body}";
      }
    } on Exception catch (error, stacktrace) {
      log("ERROR: FilcAPI.getAds: $error $stacktrace");
    }
    return null;
  }

  static Future<List<Release>?> getReleases() async {
    try {
      http.Response res = await http.get(Uri.parse(releases));

      if (res.statusCode == 200) {
        return (jsonDecode(res.body) as List)
            .cast<Map>()
            .map((e) => Release.fromJson(e))
            .toList();
      } else {
        throw "HTTP ${res.statusCode}: ${res.body}";
      }
    } on Exception catch (error, stacktrace) {
      log("ERROR: FilcAPI.getReleases: $error $stacktrace");
    }
    return null;
  }

  static Future<http.StreamedResponse?> downloadRelease(
      ReleaseDownload release) {
    try {
      var client = http.Client();
      var request = http.Request('GET', Uri.parse(release.url));
      return client.send(request);
    } on Exception catch (error, stacktrace) {
      log("ERROR: FilcAPI.downloadRelease: $error $stacktrace");
      return Future.value(null);
    }
  }

  static Future<void> sendReport(ErrorReport report) async {
    try {
      http.Response res = await http.post(Uri.parse(reportApi), body: {
        "os": report.os,
        "version": report.version,
        "error": report.error,
        "stack_trace": report.stack,
      });

      if (res.statusCode != 200) {
        throw "HTTP ${res.statusCode}: ${res.body}";
      }
    } on Exception catch (error, stacktrace) {
      log("ERROR: FilcAPI.sendReport: $error $stacktrace");
    }
  }
}

class ErrorReport {
  String stack;
  String os;
  String version;
  String error;

  ErrorReport({
    required this.stack,
    required this.os,
    required this.version,
    required this.error,
  });
}
