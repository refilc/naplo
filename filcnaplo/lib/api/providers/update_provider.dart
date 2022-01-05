import 'dart:io';

import 'package:filcnaplo/api/client.dart';
import 'package:filcnaplo/models/release.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class UpdateProvider extends ChangeNotifier {
  // Private
  late List<Release> _releases;
  bool _available = false;
  bool get available => _available && _releases.isNotEmpty;
  PackageInfo? _packageInfo;

  // Public
  List<Release> get releases => _releases;

  UpdateProvider({
    List<Release> initialReleases = const [],
    required BuildContext context,
  }) {
    _releases = List.castFrom(initialReleases);
    PackageInfo.fromPlatform().then((value) => _packageInfo = value);
  }

  String get currentVersion => _packageInfo?.version ?? "";

  Future<void> fetch() async {
    if (!Platform.isAndroid) return;

    _releases = await FilcAPI.getReleases() ?? [];
    _releases.sort((a, b) => -a.version.compareTo(b.version));

    // Check for new releases
    if (_releases.isNotEmpty) {
      _available = _packageInfo != null && _releases.first.version.compareTo(Version.fromString(currentVersion)) == 1;
      // ignore: avoid_print
      if (_available) print("INFO: New update: ${releases.first.version}");
      notifyListeners();
    }
  }
}
