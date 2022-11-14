// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:developer';

import 'package:filcnaplo/models/config.dart';
import 'package:filcnaplo/models/news.dart';
import 'package:filcnaplo/models/release.dart';
import 'package:filcnaplo/models/settings.dart';
import 'package:filcnaplo/models/supporter.dart';
import 'package:filcnaplo_kreta_api/models/school.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

class FilcAPI {
  // Public API
  static const schoolList = "https://filcnaplo.hu/v2/school_list.json";
  static const news = "https://filcnaplo.hu/v2/news.json";
  static const supporters = "https://filcnaplo.hu/v2/supporters.json";

  // Private API
  static const config = "https://api.filcnaplo.hu/config";
  static const reportApi = "https://api.filcnaplo.hu/report";

  // Updates
  static const repo = "filc/naplo";
  static const releases = "https://api.github.com/repos/$repo/releases";

  static Future<bool> checkConnectivity() async => (await Connectivity().checkConnectivity()) != ConnectivityResult.none;

  static Future<List<School>?> getSchools() async {
    try {
      http.Response res = await http.get(Uri.parse(schoolList));

      if (res.statusCode == 200) {
        List<School> schools = (jsonDecode(res.body) as List).cast<Map>().map((json) => School.fromJson(json)).toList();
        schools.add(School(
          city: "Tiszabura",
          instituteCode: "supporttest-reni-tiszabura-teszt01",
          name: "FILC Éles Reni tiszabura-teszt",
        ));
        return schools;
      } else {
        throw "HTTP ${res.statusCode}: ${res.body}";
      }
    } catch (error) {
      print("ERROR: FilcAPI.getSchools: $error");
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
        return Config.fromJson(jsonDecode(res.body));
      } else if (res.statusCode == 429) {
        res = await http.get(Uri.parse(config));
        if (res.statusCode == 200) return Config.fromJson(jsonDecode(res.body));
      }
      throw "HTTP ${res.statusCode}: ${res.body}";
    } catch (error) {
      print("ERROR: FilcAPI.getConfig: $error");
    }
    return null;
  }

  static Future<List<News>?> getNews() async {
    try {
      http.Response res = await http.get(Uri.parse(news));

      if (res.statusCode == 200) {
        return (jsonDecode(res.body) as List).cast<Map>().map((e) => News.fromJson(e)).toList();
      } else {
        throw "HTTP ${res.statusCode}: ${res.body}";
      }
    } catch (error) {
      print("ERROR: FilcAPI.getNews: $error");
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
    } catch (error) {
      print("ERROR: FilcAPI.getSupporters: $error");
    }
    return null;
  }

  static Future<List<Release>?> getReleases() async {
    try {
      http.Response res = await http.get(Uri.parse(releases));

      if (res.statusCode == 200) {
        return (jsonDecode(res.body) as List).cast<Map>().map((e) => Release.fromJson(e)).toList();
      } else {
        throw "HTTP ${res.statusCode}: ${res.body}";
      }
    } catch (error) {
      print("ERROR: FilcAPI.getReleases: $error");
    }
    return null;
  }

  static Future<http.StreamedResponse?> downloadRelease(ReleaseDownload release) {
    try {
      var client = http.Client();
      var request = http.Request('GET', Uri.parse(release.url));
      return client.send(request);
    } catch (error) {
      print("ERROR: FilcAPI.downloadRelease: $error");
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
    } catch (error) {
      print("ERROR: FilcAPI.sendReport: $error");
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
