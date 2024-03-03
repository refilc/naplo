import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:refilc/api/client.dart';
import 'package:refilc/helpers/storage_helper.dart';
import 'package:refilc/models/release.dart';
import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';

enum UpdateState { none, preparing, downloading, installing }

typedef UpdateCallback = Function(double progress, UpdateState state);

// ignore: todo
// TODO: cleanup old apk files

extension UpdateHelper on Release {
  Future<void> install({UpdateCallback? updateCallback}) async {
    updateCallback!(-1, UpdateState.preparing);

    String downloads = await StorageHelper.downloadsPath();
    File apk = File("$downloads/refilc-v$version.apk");

    if (!await apk.exists()) {
      updateCallback(-1, UpdateState.downloading);

      var bytes = await download(updateCallback: updateCallback);
      if (!await StorageHelper.write(apk.path, bytes)) {
        throw "failed to write apk: permission denied";
      }
    }

    updateCallback(-1, UpdateState.installing);

    var installPerms =
        (await Permission.manageExternalStorage.request().isGranted &&
            await Permission.requestInstallPackages.request().isGranted);
    if (installPerms) {
      var result = await OpenFilex.open(apk.path);

      if (result.type != ResultType.done) {
        // ignore: avoid_print
        print("ERROR: installUpdate.openFile: ${result.message}");
        throw result.message;
      }
    }

    updateCallback(-1, UpdateState.none);
  }

  Future<Uint8List> download({UpdateCallback? updateCallback}) async {
    var response = await reFilcAPI.downloadRelease(downloads.first);

    List<List<int>> chunks = [];
    int downloaded = 0;

    var completer = Completer<Uint8List>();

    response?.stream.listen((List<int> chunk) {
      updateCallback!(
          downloaded / (response.contentLength ?? 0), UpdateState.downloading);

      chunks.add(chunk);
      downloaded += chunk.length;
    }, onDone: () {
      // Save the file
      final Uint8List bytes = Uint8List(response.contentLength ?? 0);
      int offset = 0;
      for (List<int> chunk in chunks) {
        bytes.setRange(offset, offset + chunk.length, chunk);
        offset += chunk.length;
      }

      completer.complete(bytes);
    });

    return completer.future;
  }
}
