import 'package:filcnaplo/helpers/subject.dart';
import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:filcnaplo/ui/date_widget.dart';
import 'package:filcnaplo/utils/reverse_search.dart';
import 'package:filcnaplo_kreta_api/models/absence.dart';
import 'package:filcnaplo_kreta_api/models/subject.dart';
import 'package:filcnaplo_mobile_ui/common/custom_snack_bar.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/absence/absence_viewable.dart';
import 'package:filcnaplo_mobile_ui/common/hero_scrollview.dart';
import 'package:filcnaplo_mobile_ui/pages/absences/absence_subject_view_container.dart';
import 'package:filcnaplo_mobile_ui/pages/timetable/timetable_page.dart';
import 'package:filcnaplo/ui/filter/sort.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/utils/format.dart';

import 'package:filcnaplo_mobile_ui/common/widgets/absence/absence_view.i18n.dart';

class AbsenceSubjectView extends StatelessWidget {
  const AbsenceSubjectView(this.subject, {Key? key, this.absences = const []}) : super(key: key);

  final Subject subject;
  final List<Absence> absences;

  static void show(Subject subject, List<Absence> absences, {required BuildContext context}) {
    Navigator.of(context, rootNavigator: true)
        .push<Absence>(CupertinoPageRoute(builder: (context) => AbsenceSubjectView(subject, absences: absences)))
        .then((value) {
      if (value == null) return;

      Future.delayed(const Duration(milliseconds: 250)).then((_) {
        ReverseSearch.getLessonByAbsence(value, context).then((lesson) {
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
    });
  }

  @override
  Widget build(BuildContext context) {
    final dateWidgets = absences
        .map((a) => DateWidget(
              widget: AbsenceViewable(a, padding: EdgeInsets.zero),
              date: a.date,
            ))
        .toList();
    List<Widget> absenceTiles = sortDateWidgets(context, dateWidgets: dateWidgets, padding: EdgeInsets.zero, hasShadow: true);

    return Scaffold(
      body: HeroScrollView(
        title: subject.renamedTo ?? subject.name.capital(),
        italic: subject.isRenamed,
        icon: SubjectIcon.resolveVariant(subject: subject, context: context),
        child: AbsenceSubjectViewContainer(
          child: CupertinoScrollbar(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(24.0),
              shrinkWrap: true,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: absenceTiles[index],
              ),
              itemCount: absenceTiles.length,
            ),
          ),
        ),
      ),
    );
  }
}
