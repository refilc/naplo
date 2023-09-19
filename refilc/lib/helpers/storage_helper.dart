// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class StorageHelper {
  static Future<bool> write(String path, Uint8List data) async {
    try {
      if (await Permission.manageExternalStorage.request().isGranted) {
        await File(path).writeAsBytes(data);
        return true;
      } else {
        if (await Permission.storage.isPermanentlyDenied) {
          openAppSettings();
        }
        return false;
      }
    } catch (error) {
      print("ERROR: StorageHelper.write: $error");
      return false;
    }
  }

  static Future<String> downloadsPath() async {
    String downloads;

    if (Platform.isAndroid) {
      downloads = "/storage/self/primary/Download";
    } else {
      downloads = (await getTemporaryDirectory()).path;
    }

    return downloads;
    // return (await getTemporaryDirectory()).path;
  }
}
