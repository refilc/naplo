import 'dart:io';

import 'package:package_info_plus/package_info_plus.dart';

class Config {
  String _userAgent;
  String? _version;
  Map? json;

  Config({required String userAgent, this.json}) : _userAgent = userAgent {
    PackageInfo.fromPlatform().then((value) => _version = value.version);
  }

  factory Config.fromJson(Map json) {
    return Config(
      userAgent: json["user_agent"] ?? "hu.filc.naplo/\$0/\$1/\$2",
      json: json,
    );
  }

  String get userAgent => _userAgent.replaceAll("\$0", _version ?? "0").replaceAll("\$1", platform).replaceAll("\$2", "0");

  static String get platform {
    if (Platform.isAndroid) {
      return "Android";
    } else if (Platform.isIOS) {
      return "iOS";
    } else if (Platform.isLinux) {
      return "Linux";
    } else if (Platform.isWindows) {
      return "Windows";
    } else if (Platform.isMacOS) {
      return "MacOS";
    } else {
      return "Unknown";
    }
  }

  @override
  String toString() => json.toString();
}
