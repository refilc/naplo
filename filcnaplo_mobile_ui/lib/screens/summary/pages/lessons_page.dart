import 'dart:math';

import 'package:filcnaplo/api/providers/user_provider.dart';
import 'package:filcnaplo/helpers/subject.dart';
import 'package:filcnaplo/models/settings.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:filcnaplo_kreta_api/models/absence.dart';
import 'package:filcnaplo_kreta_api/models/lesson.dart';
import 'package:filcnaplo_kreta_api/models/subject.dart';
import 'package:filcnaplo_kreta_api/models/week.dart';
import 'package:filcnaplo_kreta_api/providers/absence_provider.dart';
import 'package:filcnaplo_kreta_api/providers/timetable_provider.dart';
import 'package:filcnaplo_mobile_ui/screens/summary/summary_screen.i18n.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

List<String> faces = [
  "(·.·)",
  "(≥o≤)",
  "(·_·)",
  "(˚Δ˚)b",
  "(^-^*)",
  "(='X'=)",
  "(>_<)",
  "(;-;)",
  "\\(^Д^)/",
  "\\(o_o)/",
];

class SubjectAbsence {
  GradeSubject subject;
  List<Absence> absences;
  double percentage;

  SubjectAbsence(
      {required this.subject, this.absences = const [], this.percentage = 0.0});
}

class LessonsBody extends StatefulWidget {
  const LessonsBody({Key? key}) : super(key: key);

  @override
  _LessonsBodyState createState() => _LessonsBodyState();
}

class _LessonsBodyState extends State<LessonsBody> {
  late UserProvider user;
  late AbsenceProvider absenceProvider;
  late SettingsProvider settingsProvider;
  late TimetableProvider timetableProvider;

  late List<SubjectAbsence> absences = [];
  late List<Widget> lessons = [];
  late List<Absence> delays = [];
  final Map<GradeSubject, Lesson> _lessonCount = {};

  @override
  void initState() {
    super.initState();

    absenceProvider = Provider.of<AbsenceProvider>(context, listen: false);
    settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    timetableProvider = Provider.of<TimetableProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      for (final lesson in timetableProvider.getWeek(Week.current()) ?? []) {
        if (!lesson.isEmpty &&
            lesson.subject.id != '' &&
            lesson.lessonYearIndex != null) {
          _lessonCount.update(
            lesson.subject,
            (value) {
              if (lesson.lessonYearIndex! > value.lessonYearIndex!) {
                return lesson;
              } else {
                return value;
              }
            },
            ifAbsent: () => lesson,
          );
        }
      }
      setState(() {});
    });
  }

  void buildSubjectAbsences() {
    Map<GradeSubject, SubjectAbsence> _absences = {};

    for (final absence in absenceProvider.absences) {
      if (absence.delay != 0) continue;

      if (!_absences.containsKey(absence.subject)) {
        _absences[absence.subject] =
            SubjectAbsence(subject: absence.subject, absences: [absence]);
      } else {
        _absences[absence.subject]?.absences.add(absence);
      }
    }

    _absences.forEach((subject, absence) {
      final absentLessonsOfSubject = absenceProvider.absences
          .where((e) => e.subject == subject && e.delay == 0)
          .length;
      final totalLessonsOfSubject = _lessonCount[subject]?.lessonYearIndex ?? 0;

      double absentLessonsOfSubjectPercentage;

      if (absentLessonsOfSubject <= totalLessonsOfSubject) {
        absentLessonsOfSubjectPercentage =
            absentLessonsOfSubject / totalLessonsOfSubject * 100;
      } else {
        absentLessonsOfSubjectPercentage = -1;
      }

      _absences[subject]?.percentage =
          absentLessonsOfSubjectPercentage.clamp(-1, 100.0);
    });

    absences = _absences.values.toList();
    absences.sort((a, b) => -a.percentage.compareTo(b.percentage));
  }

  void getAndSortDelays() {
    delays = absenceProvider.absences;
    delays.sort((a, b) => -a.delay.compareTo(b.delay));
  }

  void generateTiles() {
    Widget leastAbsent = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            SubjectIcon.resolveVariant(
                subject: absences.last.subject, context: context),
            color: Colors.white,
            size: 64,
          ),
          Text(
            absences.last.subject.renamedTo ??
                absences.last.subject.name.capital(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 36.0,
              fontStyle: absences.last.subject.isRenamed &&
                      settingsProvider.renamedSubjectsItalics
                  ? FontStyle.italic
                  : null,
              color: Colors.white,
            ),
          ),
          Text(
            'absence'.i18n.fill([absences.last.absences.length]),
            style: const TextStyle(
              fontSize: 18.0,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
    if (absences.last.absences.isNotEmpty) {
      lessons.add(leastAbsent);
    } else {
      lessons.add(buildFaceWidget());
    }

    Widget mostAbsent = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            SubjectIcon.resolveVariant(
                subject: absences.first.subject, context: context),
            color: Colors.white,
            size: 64,
          ),
          Text(
            absences.first.subject.renamedTo ??
                absences.first.subject.name.capital(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 36.0,
              fontStyle: absences.first.subject.isRenamed &&
                      settingsProvider.renamedSubjectsItalics
                  ? FontStyle.italic
                  : null,
              color: Colors.white,
            ),
          ),
          Text(
            'absence'.i18n.fill([absences.first.absences.length]),
            style: const TextStyle(
              fontSize: 18.0,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
    if (absences.first.absences.isNotEmpty) {
      lessons.add(mostAbsent);
    } else {
      lessons.add(buildFaceWidget());
    }

    Widget mostDelays = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            SubjectIcon.resolveVariant(
                subject: delays.first.subject, context: context),
            color: Colors.white,
            size: 64,
          ),
          Text(
            delays.first.subject.renamedTo ??
                delays.first.subject.name.capital(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 36.0,
              fontStyle: delays.first.subject.isRenamed &&
                      settingsProvider.renamedSubjectsItalics
                  ? FontStyle.italic
                  : null,
              color: Colors.white,
            ),
          ),
          Text(
            'delay'.i18n.fill([delays.first.delay]),
            style: const TextStyle(
              fontSize: 18.0,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
    if (delays.first.delay != 0) {
      lessons.add(mostDelays);
    } else {
      lessons.add(buildFaceWidget());
    }
  }

  @override
  Widget build(BuildContext context) {
    buildSubjectAbsences();
    getAndSortDelays();
    generateTiles();

    return Expanded(
      child: ListView(
        children: [
          lessons[0],
          const SizedBox(height: 18.0),
          Text(
            'dontfelt'.i18n,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22.0,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 18.0),
          lessons[1],
          const SizedBox(height: 18.0),
          Text(
            'youlate'.i18n,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22.0,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 18.0),
          lessons[2],
        ],
      ),
    );
  }

  Widget buildFaceWidget() {
    int index = Random(DateTime.now().minute).nextInt(faces.length);
    return Center(
      child: Text.rich(
        TextSpan(
          text: faces[index],
          style: const TextStyle(
            fontSize: 32.0,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
          children: [
            TextSpan(
              text: "\n${'no_lesson'.i18n}",
              style: TextStyle(
                  fontSize: 18.0,
                  height: 2.0,
                  color: Colors.white.withOpacity(0.5)),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
