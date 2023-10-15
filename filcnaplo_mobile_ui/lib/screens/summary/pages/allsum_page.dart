import 'package:filcnaplo/api/providers/user_provider.dart';
import 'package:filcnaplo_kreta_api/models/absence.dart';
import 'package:filcnaplo_kreta_api/models/grade.dart';
import 'package:filcnaplo_kreta_api/models/subject.dart';
import 'package:filcnaplo_kreta_api/providers/absence_provider.dart';
import 'package:filcnaplo_kreta_api/providers/grade_provider.dart';
import 'package:filcnaplo_kreta_api/providers/homework_provider.dart';
import 'package:filcnaplo_mobile_ui/screens/summary/summary_screen.i18n.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllSumBody extends StatefulWidget {
  const AllSumBody({Key? key}) : super(key: key);

  @override
  _AllSumBodyState createState() => _AllSumBodyState();
}

class _AllSumBodyState extends State<AllSumBody> {
  late UserProvider user;
  late GradeProvider gradeProvider;
  late HomeworkProvider homeworkProvider;
  late AbsenceProvider absenceProvider;
  //late TimetableProvider timetableProvider;

  late Map<String, Map<String, dynamic>> things = {};
  late List<Widget> firstSixTiles = [];
  late List<Widget> lastSixTiles = [];

  int avgDropValue = 0;
  bool animation = false;

  List<Grade> getSubjectGrades(GradeSubject subject, {int days = 0}) => gradeProvider
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
    homeworkProvider = Provider.of<HomeworkProvider>(context, listen: false);
    absenceProvider = Provider.of<AbsenceProvider>(context, listen: false);
    //timetableProvider = Provider.of<TimetableProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        animation = true;
      });
    });
  }

  void getGrades() {
    var allGrades = gradeProvider.grades;
    var testsGrades = gradeProvider.grades.where((a) => a.value.weight == 100);
    var closingTestsGrades =
        gradeProvider.grades.where((a) => a.value.weight >= 200);

    things.addAll({
      'tests': {'name': 'test'.i18n, 'value': testsGrades.length},
      'closingTests': {
        'name': 'closingtest'.i18n,
        'value': closingTestsGrades.length
      },
      'grades': {'name': 'grade'.i18n, 'value': allGrades.length}
    });
  }

  void getHomework() {
    var allHomework = homeworkProvider.homework;

    things.addAll({
      'homework': {'name': 'hw'.i18n, 'value': allHomework.length}
    });
  }

  void getSubjects() {
    var allSubjects = gradeProvider.grades
        .map((e) => e.subject)
        .toSet()
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    //var totalLessons;
    var totalLessons = 0;

    things.addAll({
      'subjects': {'name': 'subject'.i18n, 'value': allSubjects.length},
      'lessons': {'name': 'lesson'.i18n, 'value': totalLessons}
    });
  }

  void getAbsences() {
    var allAbsences = absenceProvider.absences.where((a) => a.delay == 0);
    var excusedAbsences = absenceProvider.absences
        .where((a) => a.state == Justification.excused && a.delay == 0);
    var unexcusedAbsences = absenceProvider.absences.where((a) =>
        (a.state == Justification.unexcused ||
            a.state == Justification.pending) &&
        a.delay == 0);

    things.addAll({
      'absences': {'name': 'absence_sum'.i18n, 'value': allAbsences.length},
      'excusedAbsences': {
        'name': 'excused'.i18n,
        'value': excusedAbsences.length
      },
      'unexcusedAbsences': {
        'name': 'unexcused'.i18n,
        'value': unexcusedAbsences.length
      }
    });
  }

  void getDelays() {
    var allDelays = absenceProvider.absences.where((a) => a.delay > 0);
    var delayTimeList = (allDelays.map((a) {
      return a.delay;
    }).toList());
    var totalDelayTime = 0;
    if (delayTimeList.isNotEmpty) {
      totalDelayTime = delayTimeList.reduce((a, b) => a + b);
    }
    var unexcusedDelays = absenceProvider.absences
        .where((a) => a.state == Justification.unexcused && a.delay > 0);

    things.addAll({
      'delays': {'name': 'delay_sum'.i18n, 'value': allDelays.length},
      'totalDelay': {'name': 'min'.i18n, 'value': totalDelayTime},
      'unexcusedDelays': {
        'name': 'unexcused'.i18n,
        'value': unexcusedDelays.length
      }
    });
  }

  void getEverything() {
    getGrades();
    getHomework();
    getSubjects();
    getAbsences();
    getDelays();
  }

  void generateTiles() {
    for (var i in things.values) {
      Widget w = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            i.values.toList()[1].toString(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 36.0,
              color: Colors.white,
            ),
          ),
          Text(
            i.values.toList()[0],
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18.0,
              color: Colors.white,
            ),
          ),
        ],
      );

      // TO-DO: az orakat es a hazikat szarul keri le, de majd meg lesz csinalva
      if (firstSixTiles.length < 6) {
        firstSixTiles.add(w);
      } else if (lastSixTiles.length < 6) {
        lastSixTiles.add(w);
      } else {
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    getEverything();
    generateTiles();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 45,
        ),
        AnimatedContainer(
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 420),
          transform: Matrix4.translationValues(
              animation ? 0 : MediaQuery.of(context).size.width, 0, 0),
          height: 250,
          child: GridView.count(
            crossAxisCount: 3,
            mainAxisSpacing: 0,
            crossAxisSpacing: 5,
            children: firstSixTiles,
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        AnimatedContainer(
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 420),
          transform: Matrix4.translationValues(
              animation ? 0 : -MediaQuery.of(context).size.width, 0, 0),
          height: 250,
          child: GridView.count(
            crossAxisCount: 3,
            mainAxisSpacing: 0,
            crossAxisSpacing: 5,
            children: lastSixTiles,
          ),
        ),
      ],
    );
  }
}
