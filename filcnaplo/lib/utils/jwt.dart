import 'dart:convert';

class JwtUtils {
  static String? getNameFromJWT(String jwt) {
    var parts = jwt.split(".");
    if (parts.length != 3) return null;

    if (parts[1].length % 4 == 2) {
      parts[1] += "==";
    } else if (parts[1].length % 4 == 3) {
      parts[1] += "=";
    }

    var payload = utf8.decode(base64Url.decode(parts[1]));
    var jwtData = jsonDecode(payload);
    return jwtData["name"];
  }
}
