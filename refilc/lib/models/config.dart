import 'dart:io';

class Config {
  String _userAgent;
  Map? json;
  static const String _version =
      String.fromEnvironment("APPVER", defaultValue: "3.0.4");

  Config({required String userAgent, this.json}) : _userAgent = userAgent;

  factory Config.fromJson(Map json) {
    return Config(
      userAgent: json["user_agent"] ?? "hu.ekreta.student/\$0/\$1/\$2",
      json: json,
    );
  }

  String get userAgent => _userAgent
      .replaceAll("\$0", _version)
      .replaceAll("\$1", platform)
      .replaceAll("\$2", "0");

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
