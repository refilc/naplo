import 'dart:math';

import 'package:filcnaplo/api/providers/user_provider.dart';
import 'package:filcnaplo/helpers/average_helper.dart';
import 'package:filcnaplo/models/settings.dart';
import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:filcnaplo/ui/widgets/grade/grade_tile.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:filcnaplo_kreta_api/models/grade.dart';
import 'package:filcnaplo_kreta_api/models/subject.dart';
import 'package:filcnaplo_kreta_api/providers/grade_provider.dart';
import 'package:filcnaplo_mobile_ui/common/empty.dart';
import 'package:filcnaplo_mobile_ui/pages/grades/grades_page.i18n.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';

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

    tiles.addAll(subjects.map((subject) {
      List<Grade> subjectGrades = getSubjectGrades(subject);

      double avg = AverageHelper.averageEvals(subjectGrades);
      if (avg != 0) subjectAvgs[subject] = avg;

      if (avg.round() == filter) {
        return Row(
          children: [
            GradeValueWidget(
              GradeValue(avg.round(), '', '', 100),
              fill: true,
              size: 22.0,
            ),
            Text(
              subject.renamedTo ?? subject.name.capital(),
              maxLines: 2,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18.0,
                color: AppColors.of(context).text,
                fontStyle: settings.renamedSubjectsItalics && subject.isRenamed
                    ? FontStyle.italic
                    : null,
              ),
            )
          ],
        );
      } else {
        return Container();
      }
    }));

    if (tiles.isEmpty) {
      tiles.insert(0, Empty(subtitle: "empty".i18n));
    }

    subjectAvg = subjectAvgs.isNotEmpty
        ? subjectAvgs.values.fold(0.0, (double a, double b) => a + b) /
            subjectAvgs.length
        : 0.0;

    if (filter == 5) {
      subjectTiles5 = List.castFrom(tiles);
      if (subjectTiles5.length > 5) {
        subjectTiles5.length = 5;
      }
    }
    if (filter == 3) {
      subjectTiles3 = List.castFrom(tiles);
      if (subjectTiles3.length > 3) {
        subjectTiles3.length = 3;
      }
    }
    if (filter == 1) {
      subjectTiles1 = List.castFrom(tiles);
      if (subjectTiles1.length > 2) {
        subjectTiles1.length = 2;
      }
    }
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

    generateTiles(filter: 5);
    generateTiles(filter: 3);
    generateTiles(filter: 1);

    return Column(
      children: [
        Text(
          'Jó éved volt, $firstName!',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
        Text(
          'Nézzük a jegyeidet... 📖',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
        const SizedBox(height: 20.0),
        ListView.builder(
          padding: EdgeInsets.zero,
          physics: const BouncingScrollPhysics(),
          itemCount: max(subjectTiles5.length, 1),
          itemBuilder: (context, index) {
            if (subjectTiles5.isNotEmpty) {
              EdgeInsetsGeometry panelPadding =
                  const EdgeInsets.symmetric(horizontal: 24.0);

              if (subjectTiles5[index].runtimeType == Row) {
                return subjectTiles5[index];
              } else {
                return Padding(
                    padding: panelPadding, child: subjectTiles5[index]);
              }
            } else {
              return Container();
            }
          },
        ),
        const SizedBox(height: 20.0),
        Text(
          'Próba teszi a mestert! 🔃',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
        const SizedBox(height: 20.0),
        ListView.builder(
          padding: EdgeInsets.zero,
          physics: const BouncingScrollPhysics(),
          itemCount: max(subjectTiles3.length, 1),
          itemBuilder: (context, index) {
            if (subjectTiles3.isNotEmpty) {
              EdgeInsetsGeometry panelPadding =
                  const EdgeInsets.symmetric(horizontal: 24.0);

              if (subjectTiles3[index].runtimeType == Row) {
                return subjectTiles3[index];
              } else {
                return Padding(
                    padding: panelPadding, child: subjectTiles3[index]);
              }
            } else {
              return Container();
            }
          },
        ),
        const SizedBox(height: 20.0),
        Text(
          'Ajajj... 🥴',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
        const SizedBox(height: 20.0),
        ListView.builder(
          padding: EdgeInsets.zero,
          physics: const BouncingScrollPhysics(),
          itemCount: max(subjectTiles1.length, 1),
          itemBuilder: (context, index) {
            if (subjectTiles1.isNotEmpty) {
              EdgeInsetsGeometry panelPadding =
                  const EdgeInsets.symmetric(horizontal: 24.0);

              if (subjectTiles1[index].runtimeType == Row) {
                return subjectTiles1[index];
              } else {
                return Padding(
                    padding: panelPadding, child: subjectTiles1[index]);
              }
            } else {
              return Container();
            }
          },
        ),
        const SizedBox(height: 40.0),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Év végi átlagod',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 4.0),
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
                  text: subjectAvg.toString(),
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
        )
      ],
    );
  }
}
