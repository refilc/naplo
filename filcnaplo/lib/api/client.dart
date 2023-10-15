import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:filcnaplo/models/ad.dart';
import 'package:filcnaplo/models/config.dart';
import 'package:filcnaplo/models/news.dart';
import 'package:filcnaplo/models/release.dart';
import 'package:filcnaplo/models/settings.dart';
import 'package:filcnaplo/models/shared_theme.dart';
import 'package:filcnaplo/models/supporter.dart';
import 'package:filcnaplo_kreta_api/models/school.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

class FilcAPI {
  // API base
  static const baseUrl = "https://api.refilc.hu";

  // Public API
  static const schoolList = "$baseUrl/v1/public/school-list";
  static const news = "$baseUrl/v1/public/news";
  static const supporters = "$baseUrl/v1/public/supporters";

  // Private API
  static const ads = "$baseUrl/v1/private/ads";
  static const config = "$baseUrl/v1/private/config";
  static const reportApi = "$baseUrl/v1/private/crash-report";
  static const premiumApi = "https://api.filcnaplo.hu/premium/activate";
  // static const premiumScopesApi = "https://api.filcnaplo.hu/premium/scopes";

  // Updates
  static const repo = "refilc/naplo";
  static const releases = "https://api.github.com/repos/$repo/releases";

  // Share API
  static const themeShare = "$baseUrl/v2/shared/theme/add";
  static const themeGet = "$baseUrl/v2/shared/theme/get";
  static const allThemes = "$themeGet/all";
  static const themeByID = "$themeGet/";

  static const gradeColorsShare = "$baseUrl/v2/shared/grade-colors/add";
  static const gradeColorsGet = "$baseUrl/v2/shared/grade-colors/get";
  static const allGradeColors = "$gradeColorsGet/all";
  static const gradeColorsByID = "$gradeColorsGet/";

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
          city: "Stockholm",
          instituteCode: "refilc-test-sweden",
          name: "reFilc Test SE - Leo Ekström High School",
        ));
        schools.add(School(
          city: "Madrid",
          instituteCode: "refilc-test-spain",
          name: "reFilc Test ES - Emilio Obrero University",
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
      Map body = {
        "os": report.os,
        "version": report.version,
        "error": report.error,
        "stack_trace": report.stack,
      };

      var client = http.Client();

      http.Response res = await client.post(
        Uri.parse(reportApi),
        body: body,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );

      if (res.statusCode != 200) {
        throw "HTTP ${res.statusCode}: ${res.body}";
      }
    } on Exception catch (error, stacktrace) {
      log("ERROR: FilcAPI.sendReport: $error $stacktrace");
    }
  }

  // sharing
  static Future<void> addSharedTheme(SharedTheme theme) async {
    try {
      theme.json.remove('json');
      theme.json['is_public'] = theme.isPublic.toString();
      theme.json['background_color'] = theme.backgroundColor.value.toString();
      theme.json['panels_color'] = theme.panelsColor.value.toString();
      theme.json['accent_color'] = theme.accentColor.value.toString();
      theme.json['icon_color'] = theme.iconColor.value.toString();
      theme.json['shadow_effect'] = theme.shadowEffect.toString();

      // set linked grade colors
      theme.json['grade_colors_id'] = theme.gradeColors.id;

      http.Response res = await http.post(
        Uri.parse(themeShare),
        body: theme.json,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      );

      if (res.statusCode != 201) {
        throw "HTTP ${res.statusCode}: ${res.body}";
      }

      log('Shared theme successfully with ID: ${theme.id}');
    } on Exception catch (error, stacktrace) {
      log("ERROR: FilcAPI.addSharedTheme: $error $stacktrace");
    }
  }

  static Future<Map?> getSharedTheme(String id) async {
    try {
      http.Response res = await http.get(Uri.parse(themeByID + id));

      if (res.statusCode == 200) {
        return (jsonDecode(res.body) as Map);
      } else {
        throw "HTTP ${res.statusCode}: ${res.body}";
      }
    } on Exception catch (error, stacktrace) {
      log("ERROR: FilcAPI.getSharedTheme: $error $stacktrace");
    }
    return null;
  }

  static Future<void> addSharedGradeColors(
      SharedGradeColors gradeColors) async {
    try {
      gradeColors.json.remove('json');
      gradeColors.json['is_public'] = gradeColors.isPublic.toString();
      gradeColors.json['five_color'] = gradeColors.fiveColor.value.toString();
      gradeColors.json['four_color'] = gradeColors.fourColor.value.toString();
      gradeColors.json['three_color'] = gradeColors.threeColor.value.toString();
      gradeColors.json['two_color'] = gradeColors.twoColor.value.toString();
      gradeColors.json['one_color'] = gradeColors.oneColor.value.toString();

      http.Response res = await http.post(
        Uri.parse(gradeColorsShare),
        body: gradeColors.json,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      );

      if (res.statusCode != 201) {
        throw "HTTP ${res.statusCode}: ${res.body}";
      }

      log('Shared grade colors successfully with ID: ${gradeColors.id}');
    } on Exception catch (error, stacktrace) {
      log("ERROR: FilcAPI.addSharedGradeColors: $error $stacktrace");
    }
  }

  static Future<Map?> getSharedGradeColors(String id) async {
    try {
      http.Response res = await http.get(Uri.parse(gradeColorsByID + id));

      if (res.statusCode == 200) {
        return (jsonDecode(res.body) as Map);
      } else {
        throw "HTTP ${res.statusCode}: ${res.body}";
      }
    } on Exception catch (error, stacktrace) {
      log("ERROR: FilcAPI.getSharedGradeColors: $error $stacktrace");
    }
    return null;
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
