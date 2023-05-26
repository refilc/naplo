// ignore_for_file: empty_catches

import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:filcnaplo_kreta_api/models/absence.dart';
import 'package:filcnaplo_mobile_ui/common/bottom_card.dart';
import 'package:filcnaplo_mobile_ui/common/custom_snack_bar.dart';
import 'package:filcnaplo_mobile_ui/common/detail.dart';
import 'package:filcnaplo_mobile_ui/common/panel/panel_action_button.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/absence/absence_tile.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:filcnaplo_mobile_ui/pages/timetable/timetable_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:filcnaplo/utils/reverse_search.dart';
import 'absence_view.i18n.dart';

class AbsenceView extends StatelessWidget {
  const AbsenceView(this.absence, {Key? key, this.outsideContext, this.viewable = false}) : super(key: key);

  final Absence absence;
  final BuildContext? outsideContext;
  final bool viewable;

  static show(Absence absence, {required BuildContext context}) {
    showBottomCard(context: context, child: AbsenceView(absence, outsideContext: context));
  }

  @override
  Widget build(BuildContext context) {
    Color color = AbsenceTile.justificationColor(absence.state, context: context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            visualDensity: VisualDensity.compact,
            contentPadding: const EdgeInsets.only(left: 16.0, right: 12.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
            leading: Container(
              width: 44.0,
              height: 44.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(.25),
              ),
              child: Center(
                child: Icon(
                  AbsenceTile.justificationIcon(absence.state),
                  color: color,
                ),
              ),
            ),
            title: Text(
              absence.subject.renamedTo ?? absence.subject.name.capital(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.w700, fontStyle: absence.subject.isRenamed ? FontStyle.italic : null),
            ),
            subtitle: Text(
              absence.teacher,
              // DateFormat("MM. dd. (EEEEE)", I18n.of(context).locale.toString()).format(absence.date),
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            trailing: Text(
              absence.date.format(context),
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),

          // Absence Details
          if (absence.delay > 0)
            Detail(
              title: "delay".i18n,
              description: absence.delay.toString() + " " + "minutes".i18n.plural(absence.delay),
            ),
          if (absence.lessonIndex != null)
            Detail(
              title: "Lesson".i18n,
              description: "${absence.lessonIndex}. (${absence.lessonStart.format(context, timeOnly: true)}"
                  " - "
                  "${absence.lessonEnd.format(context, timeOnly: true)})",
            ),
          if (absence.justification != null)
            Detail(
              title: "Excuse".i18n,
              description: absence.justification?.description ?? "",
            ),
          if (absence.mode != null) Detail(title: "Mode".i18n, description: absence.mode?.description ?? ""),
          Detail(title: "Submit date".i18n, description: absence.submitDate.format(context)),

          // Show in timetable
          if (!viewable)
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 6.0, top: 12.0),
              child: PanelActionButton(
                leading: const Icon(FeatherIcons.calendar),
                title: Text(
                  "show in timetable".i18n,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                onPressed: () {
                  Navigator.of(context).pop();

                  if (outsideContext != null) {
                    ReverseSearch.getLessonByAbsence(absence, context).then((lesson) {
                      if (lesson != null) {
                        TimetablePage.jump(outsideContext!, lesson: lesson);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(
                          content: Text("Cannot find lesson".i18n, style: const TextStyle(color: Colors.white)),
                          backgroundColor: AppColors.of(context).red,
                          context: context,
                        ));
                      }
                    });
                  }
                },
              ),
            ),
        ],
      ),
    );
  }
}
