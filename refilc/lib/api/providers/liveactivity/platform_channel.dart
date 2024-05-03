import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class PlatformChannel {
  static const MethodChannel _channel = MethodChannel('hu.refilc/liveactivity');

  static Future<void> createLiveActivity(
      Map<String, dynamic> activityData) async {
    if (Platform.isIOS) {
      try {
        debugPrint("creating...");
        await _channel.invokeMethod('createLiveActivity', activityData);
      } on PlatformException catch (e) {
        debugPrint("Hiba történt a Live Activity létrehozásakor: ${e.message}");
      }
    }
  }

  static Future<void> updateLiveActivity(
      Map<String, dynamic> activityData) async {
    if (Platform.isIOS) {
      try {
        debugPrint("updating...");
        await _channel.invokeMethod('updateLiveActivity', activityData);
      } on PlatformException catch (e) {
        debugPrint("Hiba történt a Live Activity frissítésekor: ${e.message}");
      }
    }
  }

  static Future<void> endLiveActivity() async {
    if (Platform.isIOS) {
      try {
        debugPrint("finishing...");
        await _channel.invokeMethod('endLiveActivity');
      } on PlatformException catch (e) {
        debugPrint("Hiba történt a Live Activity befejezésekor: ${e.message}");
      }
    }
  }
}