import 'dart:math';

import 'package:filcnaplo/api/providers/user_provider.dart';
import 'package:filcnaplo/helpers/average_helper.dart';
import 'package:filcnaplo/models/settings.dart';
import 'package:filcnaplo/ui/widgets/grade/grade_tile.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:filcnaplo_kreta_api/models/grade.dart';
import 'package:filcnaplo_kreta_api/models/subject.dart';
import 'package:filcnaplo_kreta_api/providers/grade_provider.dart';
import 'package:filcnaplo_mobile_ui/screens/summary/summary_screen.dart';
import 'package:filcnaplo_mobile_ui/screens/summary/summary_screen.i18n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';

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

  late String firstName;
  late double subjectAvg;

  List<Widget> subjectTiles5 = [];
  List<Widget> subjectTiles3 = [];
  List<Widget> subjectTiles1 = [];

  int avgDropValue = 0;

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
    settings = Provider.of<SettingsProvider>(context, listen: false);
  }

  void generateTiles({required int filter}) {
    List<Subject> subjects = gradeProvider.grades
        .map((e) => e.subject)
        .toSet()
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    List<Widget> tiles = [];

    Map<Subject, double> subjectAvgs = {};

    for (Subject subject in subjects) {
      List<Grade> subjectGrades = getSubjectGrades(subject);

      double avg = AverageHelper.averageEvals(subjectGrades);
      if (avg != 0) subjectAvgs[subject] = avg;

      Widget widget = Row(
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
      );

      if (avg.round() == filter) {
        tiles.add(widget);
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
                text: "\nno_grades".i18n,
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

    List<String> nameParts = user.displayName?.split(" ") ?? ["?"];
    if (!settings.presentationMode) {
      firstName = nameParts.length > 1 ? nameParts[1] : nameParts[0];
    } else {
      firstName = "János";
    }

    getGrades();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Jó éved volt, $firstName!',
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 26.0,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  'Nézzük a jegyeidet... 📖',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22.0,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).maybePop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        const SummaryScreen(currentPage: 'lessons'),
                  ),
                );
              },
              icon: const Icon(
                FeatherIcons.arrowRight,
                color: Colors.white,
              ),
            )
          ],
        ),
        const SizedBox(height: 12.0),
        SizedBox(
          height: ((100 * subjectTiles5.length) /
                  (subjectTiles5[0].runtimeType == Row ? 1.95 : 1.2))
              .toDouble(),
          child: ListView.builder(
            padding: const EdgeInsets.only(left: 5),
            physics: const BouncingScrollPhysics(),
            itemCount: max(subjectTiles5.length, 1),
            itemBuilder: (context, index) {
              if (subjectTiles5.isNotEmpty) {
                EdgeInsetsGeometry panelPadding =
                    const EdgeInsets.symmetric(horizontal: 24.0);

                if (subjectTiles5[index].runtimeType == Row) {
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
        const Text(
          'Próba teszi a mestert! 🔃',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22.0,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12.0),
        SizedBox(
          height: ((100 * subjectTiles3.length) /
                  (subjectTiles3[0].runtimeType == Row ? 1.95 : 1.2))
              .toDouble(),
          child: ListView.builder(
            padding: const EdgeInsets.only(left: 5),
            physics: const BouncingScrollPhysics(),
            itemCount: max(subjectTiles3.length, 1),
            itemBuilder: (context, index) {
              if (subjectTiles3.isNotEmpty) {
                EdgeInsetsGeometry panelPadding =
                    const EdgeInsets.symmetric(horizontal: 24.0);

                if (subjectTiles3[index].runtimeType == Row) {
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
        const Text(
          'Ajajj... 🥴',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22.0,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12.0),
        SizedBox(
          height: ((100 * subjectTiles1.length) /
                  (subjectTiles1[0].runtimeType == Row ? 1.95 : 1.2))
              .toDouble(),
          child: ListView.builder(
            padding: const EdgeInsets.only(left: 5),
            physics: const BouncingScrollPhysics(),
            itemCount: max(subjectTiles1.length, 1),
            itemBuilder: (context, index) {
              if (subjectTiles1.isNotEmpty) {
                EdgeInsetsGeometry panelPadding =
                    const EdgeInsets.symmetric(horizontal: 24.0);

                if (subjectTiles1[index].runtimeType == Row) {
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
        const SizedBox(height: 40.0),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Év végi átlagod',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                  color: Colors.white,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10.0),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: gradeColor(context: context, value: subjectAvg)
                      .withOpacity(.2),
                  border: Border.all(
                    color: (gradeColor(context: context, value: subjectAvg))
                        .withOpacity(0.0),
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(45.0),
                ),
                child: AutoSizeText.rich(
                  TextSpan(
                    text: subjectAvg.toStringAsFixed(2),
                  ),
                  maxLines: 1,
                  minFontSize: 5,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: gradeColor(context: context, value: subjectAvg),
                    fontWeight: FontWeight.w800,
                    fontSize: 32.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
