import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:filcnaplo_kreta_api/models/absence.dart';
import 'package:filcnaplo_mobile_ui/common/custom_snack_bar.dart';
import 'package:filcnaplo_mobile_ui/common/panel/panel_button.dart';
import 'package:filcnaplo_mobile_ui/common/viewable.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/absence/absence_tile.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/absence/absence_view.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/absence_group/absence_group_container.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/card_handle.dart';
import 'package:filcnaplo_mobile_ui/pages/absences/absence_subject_view_container.dart';
import 'package:filcnaplo_mobile_ui/pages/timetable/timetable_page.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/utils/reverse_search.dart';

import 'absence_view.i18n.dart';

class AbsenceViewable extends StatelessWidget {
  const AbsenceViewable(this.absence, {Key? key, this.padding}) : super(key: key);

  final Absence absence;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final subject = AbsenceSubjectViewContainer.of(context) != null;
    final group = AbsenceGroupContainer.of(context) != null;
    final tile = AbsenceTile(absence, padding: padding);

    return Viewable(
      tile: group ? AbsenceGroupContainer(child: tile) : tile,
      view: CardHandle(child: AbsenceView(absence, viewable: true)),
      actions: [
        PanelButton(
          background: true,
          title: Text(
            "show in timetable".i18n,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();

            if (subject) {
              Future.delayed(const Duration(milliseconds: 250)).then((_) {
                Navigator.of(context, rootNavigator: true).pop(absence);
              });
            } else {
              Future.delayed(const Duration(milliseconds: 250)).then((_) {
                ReverseSearch.getLessonByAbsence(absence, context).then((lesson) {
                  if (lesson != null) {
                    TimetablePage.jump(context, lesson: lesson);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(
                      content: Text("Cannot find lesson".i18n, style: const TextStyle(color: Colors.white)),
                      backgroundColor: AppColors.of(context).red,
                      context: context,
                    ));
                  }
                });
              });
            }
          },
        ),
      ],
    );
  }
}
