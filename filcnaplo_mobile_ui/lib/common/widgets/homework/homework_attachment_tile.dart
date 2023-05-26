import 'dart:io';
import 'package:filcnaplo/helpers/attachment_helper.dart';
import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:filcnaplo_mobile_ui/common/custom_snack_bar.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/message/image_view.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import 'package:filcnaplo_kreta_api/models/homework.dart';
import 'package:flutter/material.dart';

import 'homework_attachment_tile.i18n.dart';

class HomeworkAttachmentTile extends StatelessWidget {
  const HomeworkAttachmentTile(this.attachment, {Key? key}) : super(key: key);

  final HomeworkAttachment attachment;

  Widget buildImage(BuildContext context) {
    return FutureBuilder<String>(
      future: attachment.download(context),
      builder: (context, snapshot) {
        return snapshot.hasData
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Material(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                          builder: (context) => ImageView(snapshot.data!),
                        ));
                      },
                      child: Ink.image(
                        image: FileImage(File(snapshot.data ?? "")),
                        height: 200.0,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              )
            : Center(
                child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: CircularProgressIndicator(color: Theme.of(context).colorScheme.secondary),
              ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (attachment.isImage) return buildImage(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0),
        onTap: () {
          attachment.open(context).then((value) {
            if (!value) {
              ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(
                context: context,
                content: Text("Failed to open attachment".i18n),
                backgroundColor: AppColors.of(context).red,
                duration: const Duration(seconds: 1),
              ));
            }
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(children: [
            const Icon(FeatherIcons.paperclip),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(attachment.name, maxLines: 2, overflow: TextOverflow.ellipsis),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
