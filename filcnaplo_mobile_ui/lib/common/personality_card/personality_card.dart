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
  late Map<int, int> mostCommonGrade;
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

    mostCommonGrade = {maxKey: maxValue};
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
    } else if (mostCommonGrade.keys.toList()[0] == 1 &&
        mostCommonGrade.values.toList()[0] > 1) {
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
    } else if (mostCommonGrade.keys.toList()[0] == 2) {
      finalPersonality = PersonalityType.acceptable;
    } else if (mostCommonGrade.keys.toList()[0] == 3) {
      finalPersonality = PersonalityType.average;
    } else if (classWorkGrades.length >= 5) {
      finalPersonality = PersonalityType.diligent;
    } else {
      finalPersonality = PersonalityType.npc;
    }
  }

  Widget cardInnerBuilder() {
    Map<PersonalityType, String> emoji = {PersonalityType.geek: '🤓'};
    Map<PersonalityType, Map<String, String>> personality = {
      PersonalityType.geek: {
        'emoji': '🤓',
        'title': 'Stréber',
        'description':
            'Sokat tanulsz, de ezzel semmi baj! Ez egyben áldás és átok, de legalább az életben sikeres leszel.',
        'subtitle': 'Év végi átlagod',
        'subvalue': subjectAvg.toStringAsFixed(2),
      },
      PersonalityType.sick: {
        'emoji': '🤒',
        'title': 'Beteges',
        'description':
            'Jobbulást, tesó. Még akkor is, ha hazudtál arról, hogy beteg vagy, hogy ne kelljen suliba menned.',
        'subtitle': 'Hiányzásaid',
        'subvalue': absences.length.toString(),
      },
      PersonalityType.late: {
        'emoji': '⌛',
        'title': 'Késős',
        'description':
            'Kilukadt a villamos kereke. Kisiklott a repülő. A kutyád megette a cipőd. Elhisszük.',
        'subtitle': 'Késésed (perc)',
        'subvalue': (absences.where(
                (a) => a.state == Justification.unexcused && a.delay > 0))
            .map((e) => e.delay)
            .reduce((a, b) => a + b)
            .toString(),
      },
      PersonalityType.quitter: {
        'emoji': '❓',
        'title': 'Lógós',
        'description': 'Osztályzóvizsga incoming.',
        'subtitle': 'Igazolatlan hiányzások',
        'subvalue': (absences.where(
                (a) => a.state == Justification.unexcused && a.delay == 0))
            .length
            .toString(),
      },
      PersonalityType.healthy: {
        'emoji': '😷',
        'title': 'Makk',
        'description':
            '...egészséges vagy! Egész évben alig hiányoztál az iskolából.',
        'subtitle': 'Hiányzásaid',
        'subvalue': absences.length.toString(),
      },
      PersonalityType.acceptable: {
        'emoji': '🤏',
        'title': 'Elmegy',
        'description':
            'A kettes érettségi is érettségi. Nem egy jó érettségi, de biztos, hogy egy érettségi.',
        'subtitle': 'Kettesek',
        'subvalue': mostCommonGrade.values.toList()[0].toString(),
      },
      PersonalityType.fallible: {
        'emoji': '📉',
        'title': 'Bukós',
        'description': 'Jövőre több sikerrel jársz.',
        'subtitle': 'Karók',
        'subvalue': mostCommonGrade.values.toList()[0].toString(),
      },
      PersonalityType.average: {
        'emoji': '👌',
        'title': 'Közepes',
        'description': 'Se jó, se rossz. Az arany középút, if you will.',
        'subtitle': 'Hármasok',
        'subvalue': mostCommonGrade.values.toList()[0].toString(),
      },
      PersonalityType.diligent: {
        'emoji': '💫',
        'title': 'Szorgalmas',
        'description':
            'Leírtad a jegyzetet, megcsináltad a prezentációt, és te vezetted a projektmunkát.',
        'subtitle': 'Órai munka ötösök',
        'subvalue': classWorkGrades.length.toString(),
      },
      PersonalityType.cheater: {
        'emoji': '‍🧑‍💻',
        'title': 'Csaló',
        'description':
            'Bekapcsoltad a “Jó Tanuló” módot. Wow. Azt hitted, outsmartolhatsz, de outsmartingoltam az outsmartingolásod.',
        'subtitle': 'Bitches',
        'subvalue': '0',
      },
      PersonalityType.npc: {
        'emoji': '⛰️',
        'title': 'NPC',
        'description':
            'Egy akkora nagy non-player character vagy, hogy neked semmilyen személyiség nem jutott ezen kívül.',
        'subtitle': 'In-game playtime (óra)',
        'subvalue': '69420',
      }
    };

    for (var i in personality.keys) {
      Widget w = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            personality[i.name]?['emoji'] ?? '⛰️',
            style: const TextStyle(fontSize: 128),
          )
        ],
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    doEverything();
    getPersonality();

    return Container(
      decoration: const BoxDecoration(color: Color(0x600008FF)),
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/card_border.png'),
          ),
        ),
        child: cardInnerBuilder(),
      ),
    );
  }
}
