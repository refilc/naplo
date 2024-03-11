import 'package:refilc/helpers/attachment_helper.dart';
import 'package:refilc_kreta_api/models/attachment.dart';
import 'package:flutter/widgets.dart';
import 'package:share_plus/share_plus.dart';

class ShareHelper {
  static Future<void> shareText(String text, {String? subject}) =>
      Share.share(text, subject: subject);
  // ignore: deprecated_member_use
  static Future<void> shareFile(String path, {String? text, String? subject}) =>
      // ignore: deprecated_member_use
      Share.shareFiles([path], text: text, subject: subject);

  static Future<void> shareAttachment(Attachment attachment,
      {required BuildContext context}) async {
    String path = await attachment.download(context);
    await shareFile(path);
  }
}
