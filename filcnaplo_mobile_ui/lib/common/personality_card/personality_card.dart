import 'package:filcnaplo/api/providers/user_provider.dart';
import 'package:filcnaplo/helpers/average_helper.dart';
import 'package:filcnaplo/models/settings.dart';
import 'package:filcnaplo/models/personality.dart';
import 'package:filcnaplo_kreta_api/models/absence.dart';
import 'package:filcnaplo_kreta_api/models/grade.dart';
import 'package:filcnaplo_kreta_api/models/lesson.dart';
import 'package:filcnaplo_kreta_api/models/subject.dart';
import 'package:filcnaplo_kreta_api/models/week.dart';
import 'package:filcnaplo_kreta_api/providers/absence_provider.dart';
import 'package:filcnaplo_kreta_api/providers/grade_provider.dart';
import 'package:filcnaplo_kreta_api/providers/timetable_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PersonalityCard extends StatefulWidget {
  const PersonalityCard({
    Key? key,
    required this.user,
  }) : super(key: key);

  final UserProvider user;

  @override
  State<PersonalityCard> createState() => _PersonalityCardState();
}

class _PersonalityCardState extends State<PersonalityCard> {
  late GradeProvider gradeProvider;
  late AbsenceProvider absenceProvider;
  late TimetableProvider timetableProvider;
  late SettingsProvider settings;

  late List<int> subjectAvgsList = [];
  late Map<Subject, double> subjectAvgs = {};
  late double subjectAvg;
  late List<Grade> classWorkGrades;
  late int mostCommonGrade;
  late int onesCount;
  late List<Absence> absences = [];
  late List<Absence> delays = [];
  final Map<Subject, Lesson> _lessonCount = {};

  late PersonalityType finalPersonality;

  List<Grade> getSubjectGrades(Subject subject, {int days = 0}) => gradeProvider
      .grades
      .where((e) =>
          e.subject == subject &&
          e.type == GradeType.midYear &&
          (days == 0 ||
              e.date.isBefore(DateTime.now().subtract(Duration(days: days)))))
      .toList();

  @override
  void initState() {
    super.initState();

    gradeProvider = Provider.of<GradeProvider>(context, listen: false);
    absenceProvider = Provider.of<AbsenceProvider>(context, listen: false);
    timetableProvider = Provider.of<TimetableProvider>(context, listen: false);
    settings = Provider.of<SettingsProvider>(context, listen: false);

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

  void getGrades() {
    List<Subject> subjects = gradeProvider.grades
        .map((e) => e.subject)
        .toSet()
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));

    for (Subject subject in subjects) {
      List<Grade> subjectGrades = getSubjectGrades(subject);

      double avg = AverageHelper.averageEvals(subjectGrades);
      if (avg != 0) subjectAvgs[subject] = avg;

      subjectAvgsList.add(avg.round());
    }

    subjectAvg = subjectAvgs.isNotEmpty
        ? subjectAvgs.values.fold(0.0, (double a, double b) => a + b) /
            subjectAvgs.length
        : 0.0;

    classWorkGrades =
        gradeProvider.grades.where((a) => a.value.weight <= 75).toList();
  }

  void getMostCommonGrade() {
    Map<int, int> counts = {};

    subjectAvgsList.map((e) {
      if (counts.containsKey(e)) {
        counts.update(e, (value) => value++);
      } else {
        counts[e] = 1;
      }
    });

    var maxValue = 0;
    var maxKey = 0;

    counts.forEach((k, v) {
      if (v > maxValue) {
        maxValue = v;
        maxKey = k;
      }
    });

    mostCommonGrade = maxKey;
    onesCount = counts.values.toList()[0];
  }

  void getAbsences() {
    absences = absenceProvider.absences.where((a) => a.delay == 0).toList();
  }

  void getAndSortDelays() {
    delays = absenceProvider.absences;
    delays.sort((a, b) => -a.delay.compareTo(b.delay));
  }

  void doEverything() {
    getGrades();
    getMostCommonGrade();
    getAbsences();
    getAndSortDelays();
  }

  void getPersonality() {
    if (settings.goodStudent) {
      finalPersonality = PersonalityType.cheater;
    } else if (subjectAvg > 4.7) {
      finalPersonality = PersonalityType.geek;
    } else if (onesCount > 1) {
      finalPersonality = PersonalityType.fallible;
    } else if (absences.length < 10) {
      finalPersonality = PersonalityType.healthy;
    } else if ((absences.where(
                (a) => a.state == Justification.unexcused && a.delay == 0))
            .length >=
        10) {
      finalPersonality = PersonalityType.quitter;
    } else if ((absences.where(
                (a) => a.state == Justification.unexcused && a.delay > 0))
            .map((e) => e.delay)
            .reduce((a, b) => a + b) >
        50) {
      finalPersonality = PersonalityType.late;
    } else if (absences.length >= 100) {
      finalPersonality = PersonalityType.sick;
    } else if (mostCommonGrade == 2) {
      finalPersonality = PersonalityType.acceptable;
    } else if (mostCommonGrade == 3) {
      finalPersonality = PersonalityType.average;
    } else if (classWorkGrades.length >= 5) {
      finalPersonality = PersonalityType.diligent;
    } else {
      finalPersonality = PersonalityType.npc;
    }
  }

  @override
  Widget build(BuildContext context) {
    doEverything();
    getPersonality();

    return Container();
  }
}
