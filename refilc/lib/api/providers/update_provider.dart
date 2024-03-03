import 'dart:io';

import 'package:refilc/api/client.dart';
import 'package:refilc/models/release.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class UpdateProvider extends ChangeNotifier {
  // Private
  late List<Release> _releases;
  bool _available = false;
  bool get available => _available && _releases.isNotEmpty;

  // Public
  List<Release> get releases => _releases;

  UpdateProvider({
    List<Release> initialReleases = const [],
    required BuildContext context,
  }) {
    _releases = List.castFrom(initialReleases);
  }

  Future<void> fetch() async {
    late String currentVersion;
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    currentVersion = packageInfo.version;

    if (!Platform.isAndroid) return;

    _releases = await reFilcAPI.getReleases() ?? [];
    _releases.sort((a, b) => -a.version.compareTo(b.version));

    // Check for new releases
    if (_releases.isNotEmpty) {
      if (!_releases.first.prerelease) {
        _available = _releases.first.version
                .compareTo(Version.fromString(currentVersion)) ==
            1;
      }

      // ignore: avoid_print
      if (_available) print("INFO: New update: ${releases.first.version}");
      notifyListeners();
    }
  }

  Future<Map> installedVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;

    Map<String, String> release = {
      "app_name": appName,
      "package_name": packageName,
      "version": version,
      "build_number": buildNumber,
    };

    return release;
  }
}
