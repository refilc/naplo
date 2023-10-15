import 'dart:math';

import 'package:filcnaplo/api/providers/user_provider.dart';
import 'package:filcnaplo/helpers/average_helper.dart';
import 'package:filcnaplo/models/settings.dart';
import 'package:filcnaplo/ui/widgets/grade/grade_tile.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:filcnaplo_kreta_api/models/grade.dart';
import 'package:filcnaplo_kreta_api/models/subject.dart';
import 'package:filcnaplo_kreta_api/providers/grade_provider.dart';
import 'package:filcnaplo_mobile_ui/screens/summary/summary_screen.i18n.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:i18n_extension/i18n_widget.dart';

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

class GradesBody extends StatefulWidget {
  const GradesBody({Key? key}) : super(key: key);

  @override
  _GradesBodyState createState() => _GradesBodyState();
}

class _GradesBodyState extends State<GradesBody> {
  late UserProvider user;
  late GradeProvider gradeProvider;
  late SettingsProvider settings;

  late double subjectAvg;
  late double endYearAvg;
  late String endYearAvgText;

  List<Widget> subjectTiles5 = [];
  List<Widget> subjectTiles3 = [];
  List<Widget> subjectTiles1 = [];

  int avgDropValue = 0;
  bool animation = false;

  List<Grade> getSubjectGrades(GradeSubject subject, {int days = 0}) =>
      gradeProvider.grades
          .where((e) =>
              e.subject == subject &&
              e.type == GradeType.midYear &&
              (days == 0 ||
                  e.date
                      .isBefore(DateTime.now().subtract(Duration(days: days)))))
          .toList();

  @override
  void initState() {
    super.initState();

    gradeProvider = Provider.of<GradeProvider>(context, listen: false);
    settings = Provider.of<SettingsProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        animation = true;
      });
    });
  }

  void generateTiles({required int filter}) {
    List<GradeSubject> subjects = gradeProvider.grades
        .map((e) => e.subject)
        .toSet()
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    List<Widget> tiles = [];

    Map<GradeSubject, double> subjectAvgs = {};

    var count = 1;

    for (GradeSubject subject in subjects) {
      List<Grade> subjectGrades = getSubjectGrades(subject);

      double avg = AverageHelper.averageEvals(subjectGrades);
      if (avg != 0) subjectAvgs[subject] = avg;

      Widget widget = AnimatedContainer(
        curve: Curves.easeInOut,
        duration: Duration(milliseconds: 300 + (count * 120)),
        transform: Matrix4.translationValues(
            animation ? 0 : MediaQuery.of(context).size.width, 0, 0),
        child: Row(
          children: [
            GradeValueWidget(
              GradeValue(avg.round(), '', '', 100),
              fill: true,
              size: 28.0,
            ),
            const SizedBox(width: 8),
            Text(
              subject.renamedTo ?? subject.name.capital(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: Colors.white.withOpacity(0.98),
                fontStyle: settings.renamedSubjectsItalics && subject.isRenamed
                    ? FontStyle.italic
                    : null,
              ),
            )
          ],
        ),
      );

      if (avg.round() == filter) {
        tiles.add(widget);
        count++;
      }
    }

    if (tiles.isEmpty) {
      int index = Random(DateTime.now().minute).nextInt(faces.length);
      Widget faceWidget = Center(
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
                text: "\n${'no_grades'.i18n}",
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
      tiles.insert(0, faceWidget);
    }

    subjectAvg = subjectAvgs.isNotEmpty
        ? subjectAvgs.values.fold(0.0, (double a, double b) => a + b) /
            subjectAvgs.length
        : 0.0;

    List<Grade> endYearGrades = gradeProvider.grades
        .where((grade) => grade.type == GradeType.endYear)
        .toList();
    endYearAvg = AverageHelper.averageEvals(endYearGrades, finalAvg: true);
    endYearAvgText = endYearAvg.toStringAsFixed(1);
    if (I18n.of(context).locale.languageCode != "en") {
      endYearAvgText = endYearAvgText.replaceAll(".", ",");
    }

    if (filter == 5) {
      subjectTiles5 = List.castFrom(tiles);
      if (subjectTiles5.length > 4) {
        subjectTiles5.length = 4;
      }
    } else if (filter == 3) {
      subjectTiles3 = List.castFrom(tiles);
      if (subjectTiles3.length > 3) {
        subjectTiles3.length = 3;
      }
    } else if (filter == 1) {
      subjectTiles1 = List.castFrom(tiles);
      if (subjectTiles1.length > 2) {
        subjectTiles1.length = 2;
      }
    }
  }

  void getGrades() {
    generateTiles(filter: 5);
    generateTiles(filter: 3);
    generateTiles(filter: 1);
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context);
    settings = Provider.of<SettingsProvider>(context);

    getGrades();

    return Expanded(
      child: ListView(
        children: [
          SizedBox(
            height: ((100 * subjectTiles5.length) /
                    (subjectTiles5[0].runtimeType == AnimatedContainer
                        ? 1.95
                        : 1.2))
                .toDouble(),
            child: ListView.builder(
              padding: const EdgeInsets.only(left: 5),
              physics: const BouncingScrollPhysics(),
              itemCount: max(subjectTiles5.length, 1),
              itemBuilder: (context, index) {
                if (subjectTiles5.isNotEmpty) {
                  EdgeInsetsGeometry panelPadding =
                      const EdgeInsets.symmetric(horizontal: 24.0);

                  if (subjectTiles5[index].runtimeType == AnimatedContainer) {
                    return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: subjectTiles5[index]);
                  } else {
                    return Padding(
                        padding: panelPadding, child: subjectTiles5[index]);
                  }
                } else {
                  return Container();
                }
              },
            ),
          ),
          const SizedBox(height: 12.0),
          Text(
            'tryagain'.i18n,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22.0,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12.0),
          SizedBox(
            height: ((100 * subjectTiles3.length) /
                    (subjectTiles3[0].runtimeType == AnimatedContainer
                        ? 1.95
                        : 1.2))
                .toDouble(),
            child: ListView.builder(
              padding: const EdgeInsets.only(left: 5),
              physics: const BouncingScrollPhysics(),
              itemCount: max(subjectTiles3.length, 1),
              itemBuilder: (context, index) {
                if (subjectTiles3.isNotEmpty) {
                  EdgeInsetsGeometry panelPadding =
                      const EdgeInsets.symmetric(horizontal: 24.0);

                  if (subjectTiles3[index].runtimeType == AnimatedContainer) {
                    return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: subjectTiles3[index]);
                  } else {
                    return Padding(
                        padding: panelPadding, child: subjectTiles3[index]);
                  }
                } else {
                  return Container();
                }
              },
            ),
          ),
          const SizedBox(height: 12.0),
          Text(
            'oops'.i18n,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22.0,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12.0),
          SizedBox(
            height: ((100 * subjectTiles1.length) /
                    (subjectTiles1[0].runtimeType == AnimatedContainer
                        ? 1.95
                        : 1.2))
                .toDouble(),
            child: ListView.builder(
              padding: const EdgeInsets.only(left: 5),
              physics: const BouncingScrollPhysics(),
              itemCount: max(subjectTiles1.length, 1),
              itemBuilder: (context, index) {
                if (subjectTiles1.isNotEmpty) {
                  EdgeInsetsGeometry panelPadding =
                      const EdgeInsets.symmetric(horizontal: 24.0);

                  if (subjectTiles1[index].runtimeType == AnimatedContainer) {
                    return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: subjectTiles1[index]);
                  } else {
                    return Padding(
                        padding: panelPadding, child: subjectTiles1[index]);
                  }
                } else {
                  return Container();
                }
              },
            ),
          ),
          const SizedBox(height: 30.0),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'endyear_avg'.i18n,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22.0,
                    color: Colors.white,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: gradeColor(context: context, value: endYearAvg)
                        .withOpacity(.2),
                    border: Border.all(
                      color: (gradeColor(context: context, value: endYearAvg))
                          .withOpacity(0.0),
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(45.0),
                  ),
                  child: AutoSizeText.rich(
                    TextSpan(
                      text: endYearAvgText,
                    ),
                    maxLines: 1,
                    minFontSize: 5,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: gradeColor(context: context, value: endYearAvg),
                      fontWeight: FontWeight.w800,
                      fontSize: 32.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
