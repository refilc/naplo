import 'dart:io';
import 'dart:typed_data';

import 'package:filcnaplo/helpers/storage_helper.dart';
import 'package:filcnaplo_kreta_api/client/client.dart';
import 'package:filcnaplo_kreta_api/models/attachment.dart';
import 'package:flutter/widgets.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';

extension AttachmentHelper on Attachment {
  Future<String> download(BuildContext context, {bool overwrite = false}) async {
    String downloads = await StorageHelper.downloadsPath();

    if (!overwrite && await File("$downloads/$name").exists()) return "$downloads/$name";

    Uint8List data = await Provider.of<KretaClient>(context, listen: false).getAPI(downloadUrl, rawResponse: true);
    if (!await StorageHelper.write("$downloads/$name", data)) return "";

    return "$downloads/$name";
  }

  Future<bool> open(BuildContext context) async {
    String downloads = await StorageHelper.downloadsPath();
    
    if (!await File("$downloads/$name").exists()) await download(context);
    var result = await OpenFile.open("$downloads/$name");
    return result.type == ResultType.done;
  }
}
