import 'package:refilc/helpers/subject.dart';
import 'package:refilc/models/settings.dart';
import 'package:refilc_kreta_api/models/homework.dart';
import 'package:refilc/utils/format.dart';
import 'package:refilc_mobile_ui/common/detail.dart';
import 'package:refilc_mobile_ui/common/sliding_bottom_sheet.dart';
import 'package:refilc_mobile_ui/common/widgets/homework/homework_attachment_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:provider/provider.dart';
import 'homework_view.i18n.dart';

class HomeworkView extends StatelessWidget {
  const HomeworkView(this.homework, {Key? key}) : super(key: key);

  final Homework homework;

  static show(Homework homework, {required BuildContext context}) {
    showSlidingBottomSheet(context: context, child: HomeworkView(homework));
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> attachmentTiles = [];
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);

    for (var attachment in homework.attachments) {
      attachmentTiles.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
        child: HomeworkAttachmentTile(
          attachment,
        ),
      ));
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          ListTile(
            leading: Icon(
              SubjectIcon.resolveVariant(
                  subjectName: homework.subject.name, context: context),
              size: 36.0,
            ),
            title: Text(
              homework.subject.renamedTo ?? homework.subject.name.capital(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontStyle: homework.subject.isRenamed &&
                          settingsProvider.renamedSubjectsItalics
                      ? FontStyle.italic
                      : null),
            ),
            subtitle: Text(
              (homework.teacher.isRenamed
                      ? homework.teacher.renamedTo
                      : homework.teacher.name) ??
                  '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            trailing: Text(
              homework.date.format(context),
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),

          // Details
          if (homework.deadline.year != 0)
            Detail(
                title: "deadline".i18n,
                description: homework.deadline.format(context)),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 18.0, vertical: 6.0),
            child: SelectableLinkify(
              text: homework.content.escapeHtml(),
              options: const LinkifyOptions(looseUrl: true, removeWww: true),
              onOpen: (link) {
                launch(link.url,
                    customTabsOption: CustomTabsOption(
                      toolbarColor: Theme.of(context).scaffoldBackgroundColor,
                      showPageTitle: true,
                    ));
              },
              style: const TextStyle(fontWeight: FontWeight.w400),
            ),
          ),

          // Attachments
          ...attachmentTiles,
        ],
      ),
    );
  }
}
