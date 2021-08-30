import 'dart:io';

import 'package:filcnaplo/api/client.dart';
import 'package:filcnaplo/models/release.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class UpdateProvider extends ChangeNotifier {
  // Private
  late List<Release> _releases;
  late BuildContext _context;
  bool _available = false;
  bool get available => _available && _releases.length > 0;
  PackageInfo? _packageInfo;

  // Public
  List<Release> get releases => _releases;

  UpdateProvider({
    List<Release> initialReleases = const [],
    required BuildContext context,
  }) {
    _releases = List.castFrom(initialReleases);
    _context = context;
    PackageInfo.fromPlatform().then((value) => _packageInfo = value);
  }

  Future<void> fetch() async {
    if (!Platform.isAndroid) return;

    _releases = await FilcAPI.getReleases() ?? [];
    _releases.sort((a, b) => -a.version.compareTo(b.version));

    // Check for new releases
    if (_releases.length > 0) {
      print("INFO: New update: ${releases.first.version}");
      _available = _packageInfo != null && _releases.first.version.compareTo(Version.fromString(_packageInfo?.version ?? "")) == 1;
      notifyListeners();
    }
  }
}
