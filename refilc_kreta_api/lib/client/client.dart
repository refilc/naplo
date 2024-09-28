// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

// import 'package:refilc/api/login.dart';
// import 'package:refilc/api/nonce.dart';
import 'package:refilc/api/providers/database_provider.dart';
import 'package:refilc/api/providers/user_provider.dart';
import 'package:refilc/api/providers/status_provider.dart';
import 'package:refilc/models/settings.dart';
import 'package:refilc/models/user.dart';
// import 'package:refilc/utils/jwt.dart';
import 'package:refilc_kreta_api/client/api.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart' as http;
import 'dart:async';

class KretaClient {
  String? accessToken;
  String? refreshToken;
  String? idToken;
  String? userAgent;
  late http.Client client;

  late final SettingsProvider _settings;
  late final UserProvider _user;
  late final DatabaseProvider _database;
  late final StatusProvider _status;

  bool _loginRefreshing = false;

  KretaClient({
    this.accessToken,
    required SettingsProvider settings,
    required UserProvider user,
    required DatabaseProvider database,
    required StatusProvider status,
  })  : _settings = settings,
        _user = user,
        _database = database,
        _status = status,
        userAgent = settings.config.userAgent {
    var ioclient = HttpClient();
    ioclient.badCertificateCallback = _checkCerts;
    client = http.IOClient(ioclient);
  }

  bool _checkCerts(X509Certificate cert, String host, int port) {
    return _settings.developerMode;
  }

  Future<dynamic> getAPI(
    String url, {
    Map<String, String>? headers,
    bool autoHeader = true,
    bool json = true,
    bool rawResponse = false,
  }) async {
    Map<String, String> headerMap;

    if (rawResponse) json = false;

    if (headers != null) {
      headerMap = headers;
    } else {
      headerMap = {};
    }

    try {
      http.Response? res;

      for (int i = 0; i < 3; i++) {
        if (autoHeader) {
          if (!headerMap.containsKey("authorization") && accessToken != null) {
            headerMap["authorization"] = "Bearer $accessToken";
          }
          if (!headerMap.containsKey("user-agent") && userAgent != null) {
            headerMap["user-agent"] = "$userAgent";
          }
        }

        res = await client.get(Uri.parse(url), headers: headerMap);
        _status.triggerRequest(res);

        if (res.statusCode == 401) {
          headerMap.remove("authorization");
          print("DEBUG: 401 error, refreshing login");
          await refreshLogin();
        } else {
          break;
        }

        // Wait before retrying
        await Future.delayed(const Duration(milliseconds: 500));
      }

      if (res == null) throw "Login error";
      if (res.body == 'invalid_grant' || res.body.replaceAll(' ', '') == '') {
        throw "Auth error";
      }

      if (json) {
        return jsonDecode(res.body);
      } else if (rawResponse) {
        return res.bodyBytes;
      } else {
        return res.body;
      }
    } on http.ClientException catch (error) {
      print(
          "ERROR: KretaClient.getAPI ($url) ClientException: ${error.message}");
    } catch (error) {
      print("ERROR: KretaClient.getAPI ($url) ${error.runtimeType}: $error");
    }
  }

  Future<dynamic> postAPI(
    String url, {
    Map<String, String>? headers,
    bool autoHeader = true,
    bool json = true,
    Object? body,
  }) async {
    Map<String, String> headerMap;

    if (headers != null) {
      headerMap = headers;
    } else {
      headerMap = {};
    }

    try {
      http.Response? res;

      for (int i = 0; i < 3; i++) {
        if (autoHeader) {
          if (!headerMap.containsKey("authorization") && accessToken != null) {
            headerMap["authorization"] = "Bearer $accessToken";
          }
          if (!headerMap.containsKey("user-agent") && userAgent != null) {
            headerMap["user-agent"] = "$userAgent";
          }
          if (!headerMap.containsKey("content-type")) {
            headerMap["content-type"] = "application/json";
          }
          if (url.contains('kommunikacio/uzenetek')) {
            headerMap["X-Uzenet-Lokalizacio"] = "hu-HU";
          }
        }

        res = await client.post(Uri.parse(url), headers: headerMap, body: body);
        if (res.statusCode == 401) {
          await refreshLogin();
          headerMap.remove("authorization");
        } else {
          break;
        }
      }

      if (res == null) throw "Login error";

      if (json) {
        print(jsonDecode(res.body));
        return jsonDecode(res.body);
      } else {
        return res.body;
      }
    } on http.ClientException catch (error) {
      print(
          "ERROR: KretaClient.postAPI ($url) ClientException: ${error.message}");
    } catch (error) {
      print("ERROR: KretaClient.postAPI ($url) ${error.runtimeType}: $error");
    }
  }

  Future<dynamic> sendFilesAPI(
    String url, {
    Map<String, String>? headers,
    bool autoHeader = true,
    Map<String, String>? body,
  }) async {
    Map<String, String> headerMap;

    if (headers != null) {
      headerMap = headers;
    } else {
      headerMap = {};
    }

    try {
      http.StreamedResponse? res;

      for (int i = 0; i < 3; i++) {
        if (autoHeader) {
          if (!headerMap.containsKey("authorization") && accessToken != null) {
            headerMap["authorization"] = "Bearer $accessToken";
          }
          if (!headerMap.containsKey("user-agent") && userAgent != null) {
            headerMap["user-agent"] = "$userAgent";
          }
          if (!headerMap.containsKey("content-type")) {
            headerMap["content-type"] = "multipart/form-data";
          }
          if (url.contains('kommunikacio/uzenetek')) {
            headerMap["X-Uzenet-Lokalizacio"] = "hu-HU";
          }
        }

        var request = http.MultipartRequest("POST", Uri.parse(url));

        // request.files.add(value)

        request.fields.addAll(body ?? {});
        request.headers.addAll(headers ?? {});

        res = await request.send();

        if (res.statusCode == 401) {
          headerMap.remove("authorization");
          await refreshLogin();
        } else {
          break;
        }
      }

      if (res == null) throw "Login error";

      print(res.statusCode);

      return res.statusCode;
    } on http.ClientException catch (error) {
      print(
          "ERROR: KretaClient.postAPI ($url) ClientException: ${error.message}");
    } catch (error) {
      print("ERROR: KretaClient.postAPI ($url) ${error.runtimeType}: $error");
    }
  }

  Future<String?> refreshLogin() async {
    if (_loginRefreshing) return null;
    _loginRefreshing = true;

    User? loginUser = _user.user;
    if (loginUser == null) return null;

    Map<String, String> headers = {
      "content-type": "application/x-www-form-urlencoded; charset=UTF-8",
      "accept": "*/*",
      "user-agent": "eKretaStudent/264745 CFNetwork/1494.0.7 Darwin/23.4.0",
    };

    if (_settings.presentationMode) {
      print("DEBUG: refreshLogin: ${loginUser.id}");
    } else {
      print("DEBUG: refreshLogin: ${loginUser.id} ${loginUser.name}");
    }

    refreshToken ??= loginUser.refreshToken;

    print("REFRESH TOKEN BELOW");
    print(refreshToken);

    if (refreshToken != null) {
      // print("REFRESHING LOGIN");
      Map? res = await postAPI(KretaAPI.login,
          headers: headers,
          body: User.refreshBody(
            refreshToken: loginUser.refreshToken,
            instituteCode: loginUser.instituteCode,
          ));
      print("REFRESH RESPONSE BELOW");
      print(res);
      if (res != null) {
        if (res.containsKey("error")) {
          // remove user if refresh token expired
          if (res["error"] == "invalid_grant") {
            // remove user from app
            // _user.removeUser(loginUser.id);
            // await _database.store.removeUser(loginUser.id);

            print("invalid refresh token (invalid_grant)");

            // return error
            return "refresh_token_expired";
          }
        }

        if (res.containsKey("access_token")) {
          accessToken = res["access_token"];
        }
        if (res.containsKey("refresh_token")) {
          refreshToken = res["refresh_token"];
          loginUser.refreshToken = res["refresh_token"];
          _database.store.storeUser(loginUser);
          _user.refresh();
        }
        if (res.containsKey("id_token")) {
          idToken = res["id_token"];
        }
        _loginRefreshing = false;
      } else {
        _loginRefreshing = false;
      }
    } else {
      _loginRefreshing = false;
    }

    return null;
  }

  Future<void> logout() async {
    User? loginUser = _user.user;
    if (loginUser == null) return;

    Map<String, String> headers = {
      "content-type": "application/x-www-form-urlencoded",
    };

    await postAPI(
      KretaAPI.logout,
      headers: headers,
      body: User.logoutBody(
        refreshToken: refreshToken!,
      ),
      json: false,
    );
  }
}
