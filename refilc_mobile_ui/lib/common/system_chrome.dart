import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void setSystemChrome(BuildContext context) {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Theme.of(context).brightness == Brightness.light ? Brightness.dark : Brightness.light,
    systemNavigationBarColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
    systemNavigationBarIconBrightness: Theme.of(context).brightness == Brightness.light ? Brightness.dark : Brightness.light,
    statusBarBrightness: Platform.isIOS ? Theme.of(context).brightness : null,
  ));
}
