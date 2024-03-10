import 'package:refilc_kreta_api/models/note.dart';
import 'package:refilc_mobile_ui/common/profile_image/profile_image.dart';
import 'package:refilc/utils/format.dart';
import 'package:refilc_mobile_ui/common/sliding_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter_linkify/flutter_linkify.dart';

class NoteView extends StatelessWidget {
  const NoteView(this.note, {super.key});

  final Note note;

  static void show(Note note, {required BuildContext context}) =>
      showSlidingBottomSheet(context: context, child: NoteView(note));

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          ListTile(
            leading: ProfileImage(
              name: (note.teacher.isRenamed
                      ? note.teacher.renamedTo
                      : note.teacher.name) ??
                  '',
              radius: 22.0,
              backgroundColor: Theme.of(context).colorScheme.secondary,
              // backgroundColor: ColorUtils.stringToColor(
              //   (note.teacher.isRenamed
              //           ? note.teacher.renamedTo
              //           : note.teacher.name) ??
              //       '',
              // ),
            ),
            title: Text(
              note.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              (note.teacher.isRenamed
                      ? note.teacher.renamedTo
                      : note.teacher.name) ??
                  '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            trailing: Text(
              note.date.format(context),
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),

          // Details
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: SelectableLinkify(
                text: note.content.escapeHtml(),
                options: const LinkifyOptions(looseUrl: true, removeWww: true),
                onOpen: (link) {
                  launchUrl(
                    Uri.parse(link.url),
                    customTabsOptions: CustomTabsOptions(
                      showTitle: true,
                      colorSchemes: CustomTabsColorSchemes(
                        defaultPrams: CustomTabsColorSchemeParams(
                          toolbarColor:
                              Theme.of(context).scaffoldBackgroundColor,
                        ),
                      ),
                    ),
                  );
                },
                style: const TextStyle(fontWeight: FontWeight.w400),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
