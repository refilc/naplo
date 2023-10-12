import 'package:filcnaplo/api/providers/ad_provider.dart';
import 'package:filcnaplo/api/providers/update_provider.dart';
import 'package:filcnaplo/models/settings.dart';
import 'package:filcnaplo/ui/date_widget.dart';
import 'package:filcnaplo/ui/filter/widgets/grades.dart' as grade_filter;
import 'package:filcnaplo/ui/filter/widgets/certifications.dart'
    as certification_filter;
import 'package:filcnaplo/ui/filter/widgets/messages.dart' as message_filter;
import 'package:filcnaplo/ui/filter/widgets/absences.dart' as absence_filter;
import 'package:filcnaplo/ui/filter/widgets/homework.dart' as homework_filter;
import 'package:filcnaplo/ui/filter/widgets/exams.dart' as exam_filter;
import 'package:filcnaplo/ui/filter/widgets/notes.dart' as note_filter;
import 'package:filcnaplo/ui/filter/widgets/events.dart' as event_filter;
import 'package:filcnaplo/ui/filter/widgets/lessons.dart' as lesson_filter;
import 'package:filcnaplo/ui/filter/widgets/update.dart' as update_filter;
import 'package:filcnaplo/ui/filter/widgets/missed_exams.dart'
    as missed_exam_filter;
import 'package:filcnaplo/ui/filter/widgets/ads.dart' as ad_filter;
import 'package:filcnaplo_kreta_api/models/week.dart';
import 'package:filcnaplo_kreta_api/providers/absence_provider.dart';
import 'package:filcnaplo_kreta_api/providers/event_provider.dart';
import 'package:filcnaplo_kreta_api/providers/exam_provider.dart';
import 'package:filcnaplo_kreta_api/providers/grade_provider.dart';
import 'package:filcnaplo_kreta_api/providers/homework_provider.dart';
import 'package:filcnaplo_kreta_api/providers/message_provider.dart';
import 'package:filcnaplo_kreta_api/providers/note_provider.dart';
import 'package:filcnaplo_kreta_api/providers/timetable_provider.dart';
import 'package:filcnaplo_premium/providers/premium_provider.dart';
import 'package:filcnaplo_premium/ui/mobile/premium/premium_inline.dart';
import 'package:filcnaplo_mobile_ui/common/panel/panel.dart';
import 'package:flutter/material.dart';
import 'package:animated_list_plus/transitions.dart';
import 'package:provider/provider.dart';

const List<FilterType> homeFilters = [
  FilterType.all,
  FilterType.grades,
  FilterType.messages,
  FilterType.absences
];

enum FilterType {
  all,
  grades,
  newGrades,
  messages,
  absences,
  homework,
  exams,
  notes,
  events,
  lessons,
  updates,
  certifications,
  missedExams,
  ads,
}

Future<List<DateWidget>> getFilterWidgets(FilterType activeData,
    {bool absencesNoExcused = false, required BuildContext context}) async {
  final gradeProvider = Provider.of<GradeProvider>(context);
  final timetableProvider = Provider.of<TimetableProvider>(context);
  final messageProvider = Provider.of<MessageProvider>(context);
  final absenceProvider = Provider.of<AbsenceProvider>(context);
  final homeworkProvider = Provider.of<HomeworkProvider>(context);
  final examProvider = Provider.of<ExamProvider>(context);
  final noteProvider = Provider.of<NoteProvider>(context);
  final eventProvider = Provider.of<EventProvider>(context);
  final updateProvider = Provider.of<UpdateProvider>(context);
  final settingsProvider = Provider.of<SettingsProvider>(context);
  final adProvider = Provider.of<AdProvider>(context);

  List<DateWidget> items = [];

  switch (activeData) {
    // All
    case FilterType.all:
      final all = await Future.wait<List<DateWidget>>([
        getFilterWidgets(FilterType.grades, context: context),
        getFilterWidgets(FilterType.lessons, context: context),
        getFilterWidgets(FilterType.messages, context: context),
        getFilterWidgets(FilterType.absences,
            context: context, absencesNoExcused: true),
        getFilterWidgets(FilterType.homework, context: context),
        getFilterWidgets(FilterType.exams, context: context),
        getFilterWidgets(FilterType.updates, context: context),
        getFilterWidgets(FilterType.certifications, context: context),
        getFilterWidgets(FilterType.missedExams, context: context),
        getFilterWidgets(FilterType.ads, context: context),
      ]);
      items = all.expand((x) => x).toList();

      break;

    // Grades
    case FilterType.grades:
      if (!settingsProvider.gradeOpeningFun) {
        gradeProvider.seenAll();
      }
      items = grade_filter.getWidgets(
          gradeProvider.grades, gradeProvider.lastSeenDate);
      if (settingsProvider.gradeOpeningFun) {
        items.addAll(
            // ignore: use_build_context_synchronously
            await getFilterWidgets(FilterType.newGrades, context: context));
      }
      break;

    // Grades
    case FilterType.newGrades:
      items = grade_filter.getNewWidgets(
          gradeProvider.grades, gradeProvider.lastSeenDate);
      break;

    // Certifications
    case FilterType.certifications:
      items = certification_filter.getWidgets(gradeProvider.grades);
      break;

    // Messages
    case FilterType.messages:
      items = message_filter.getWidgets(
        messageProvider.messages,
        noteProvider.notes,
        eventProvider.events,
      );
      break;

    // Absences
    case FilterType.absences:
      items = absence_filter.getWidgets(absenceProvider.absences,
          noExcused: absencesNoExcused);
      break;

    // Homework
    case FilterType.homework:
      items = homework_filter.getWidgets(homeworkProvider.homework);
      break;

    // Exams
    case FilterType.exams:
      items = exam_filter.getWidgets(examProvider.exams);
      break;

    // Notes
    case FilterType.notes:
      items = note_filter.getWidgets(noteProvider.notes);
      break;

    // Events
    case FilterType.events:
      items = event_filter.getWidgets(eventProvider.events);
      break;

    // Changed Lessons
    case FilterType.lessons:
      items = lesson_filter
          .getWidgets(timetableProvider.getWeek(Week.current()) ?? []);
      break;

    // Updates
    case FilterType.updates:
      if (updateProvider.available) {
        items = [update_filter.getWidget(updateProvider.releases.first)];
      }
      break;

    // Missed Exams
    case FilterType.missedExams:
      items = missed_exam_filter
          .getWidgets(timetableProvider.getWeek(Week.current()) ?? []);
      break;

    // Ads
    case FilterType.ads:
      if (adProvider.available) {
        items = ad_filter.getWidgets(adProvider.ads);
      }
      break;
  }
  return items;
}

Widget filterItemBuilder(
    BuildContext context, Animation<double> animation, Widget item, int index) {
  if (item.key == const Key("\$premium")) {
    return Provider.of<PremiumProvider>(context, listen: false).hasPremium ||
            DateTime.now().weekday <= 5
        ? const SizedBox()
        : const Padding(
            padding: EdgeInsets.only(bottom: 24.0),
            child: PremiumInline(features: [
              PremiumInlineFeature.nickname,
              PremiumInlineFeature.theme,
              PremiumInlineFeature.widget,
            ]),
          );
  }

  final wrappedItem = SizeFadeTransition(
    curve: Curves.easeInOutCubic,
    animation: animation,
    child: item,
  );

  return item is Panel
      // Re-add & animate shadow
      ? AnimatedBuilder(
          animation: animation,
          child: wrappedItem,
          builder: (context, child) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  boxShadow: [
                    if (Provider.of<SettingsProvider>(context, listen: false)
                        .shadowEffect)
                      BoxShadow(
                        offset: const Offset(0, 21),
                        blurRadius: 23.0,
                        color: Theme.of(context).shadowColor.withOpacity(
                              Theme.of(context).shadowColor.opacity *
                                  CurvedAnimation(
                                    parent: CurvedAnimation(
                                        parent: animation,
                                        curve: Curves.easeInOutCubic),
                                    curve: const Interval(2 / 3, 1.0),
                                  ).value,
                            ),
                      ),
                  ],
                ),
                child: child,
              ),
            );
          })
      : wrappedItem;
}
