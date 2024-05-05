// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:refilc/api/providers/update_provider.dart';
import 'package:refilc/models/settings.dart';
import 'package:refilc/ui/widgets/grade/grade_tile.dart';
import 'package:refilc_kreta_api/models/exam.dart';
import 'package:refilc_kreta_api/providers/exam_provider.dart';
// import 'package:refilc_kreta_api/client/api.dart';
// import 'package:refilc_kreta_api/client/client.dart';
import 'package:refilc_kreta_api/providers/grade_provider.dart';
import 'package:refilc/api/providers/user_provider.dart';
import 'package:refilc/theme/colors/colors.dart';
import 'package:refilc_kreta_api/models/grade.dart';
import 'package:refilc_kreta_api/models/subject.dart';
import 'package:refilc_kreta_api/models/group_average.dart';
import 'package:refilc_kreta_api/providers/homework_provider.dart';
import 'package:refilc_mobile_ui/common/average_display.dart';
import 'package:refilc_mobile_ui/common/bottom_sheet_menu/bottom_sheet_menu.dart';
import 'package:refilc_mobile_ui/common/bottom_sheet_menu/rounded_bottom_sheet.dart';
import 'package:refilc_mobile_ui/common/empty.dart';
import 'package:refilc_mobile_ui/common/panel/panel.dart';
import 'package:refilc_mobile_ui/common/profile_image/profile_button.dart';
import 'package:refilc_mobile_ui/common/profile_image/profile_image.dart';
import 'package:refilc_mobile_ui/common/widgets/exam/exam_viewable.dart';
import 'package:refilc_mobile_ui/common/widgets/statistics_tile.dart';
import 'package:refilc_mobile_ui/common/widgets/grade/grade_subject_tile.dart';
import 'package:refilc_mobile_ui/common/trend_display.dart';
import 'package:refilc_mobile_ui/pages/grades/fail_warning.dart';
import 'package:refilc_mobile_ui/pages/grades/grades_count.dart';
import 'package:refilc_mobile_ui/pages/grades/graph.dart';
import 'package:refilc_mobile_ui/pages/grades/grade_subject_view.dart';
import 'package:refilc_mobile_ui/screens/navigation/navigation_route_handler.dart';
import 'package:refilc_mobile_ui/screens/navigation/navigation_screen.dart';
import 'package:refilc_plus/models/premium_scopes.dart';
import 'package:refilc_plus/providers/plus_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:refilc/helpers/average_helper.dart';
import 'package:refilc_plus/ui/mobile/plus/upsell.dart';
import 'average_selector.dart';
import 'package:refilc_plus/ui/mobile/plus/premium_inline.dart';
import 'calculator/grade_calculator.dart';
import 'calculator/grade_calculator_provider.dart';
import 'grades_page.i18n.dart';

class GradesPage extends StatefulWidget {
  const GradesPage({super.key});

  static void jump(BuildContext context, {GradeSubject? subject}) {
    // Go to timetable page with arguments
    NavigationScreen.of(context)
        ?.customRoute(navigationPageRoute((context) => const GradesPage()));

    NavigationScreen.of(context)?.setPage("grades");

    // Show initial Lesson
    if (subject != null) {
      GradeSubjectView(subject, groupAverage: 0.0).push(context, root: true);
    }
  }

  @override
  GradesPageState createState() => GradesPageState();
}

class GradesPageState extends State<GradesPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  PersistentBottomSheetController? _sheetController;

  late UserProvider user;
  late GradeProvider gradeProvider;
  late UpdateProvider updateProvider;
  late GradeCalculatorProvider calculatorProvider;
  late HomeworkProvider homeworkProvider;
  late ExamProvider examProvider;

  late String firstName;
  late Widget yearlyGraph;
  late Widget gradesCount;
  List<Widget> subjectTiles = [];

  int avgDropValue = 0;

  bool gradeCalcMode = false;

  List<Grade> getSubjectGrades(GradeSubject subject,
          {int days = 0}) =>
      !gradeCalcMode
          ? gradeProvider
              .grades
              .where((e) =>
                  e
                          .subject ==
                      subject &&
                  e.type == GradeType.midYear &&
                  (days ==
                          0 ||
                      e.date.isBefore(
                          DateTime.now().subtract(Duration(days: days)))))
              .toList()
          : calculatorProvider.grades
              .where((e) => e.subject == subject)
              .toList();

  void generateTiles() {
    List<GradeSubject> subjects = gradeProvider.grades
        .map((e) => GradeSubject(
              category: e.subject.category,
              id: e.subject.id,
              name: e.subject.name,
              renamedTo: e.subject.renamedTo,
              customRounding: e.subject.customRounding,
              teacher: e.teacher,
            ))
        .toSet()
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    List<Widget> tiles = [];

    Map<GradeSubject, double> subjectAvgs = {};

    if (!gradeCalcMode) {
      var i = 0;

      tiles.addAll(subjects.map((subject) {
        List<Grade> subjectGrades = getSubjectGrades(subject);

        double avg = AverageHelper.averageEvals(subjectGrades);
        double averageBefore = 0.0;

        if (avgDropValue != 0) {
          List<Grade> gradesBefore =
              getSubjectGrades(subject, days: avgDropValue);
          averageBefore = avgDropValue == 0
              ? 0.0
              : AverageHelper.averageEvals(gradesBefore);
        }
        var nullavg = GroupAverage(average: 0.0, subject: subject, uid: "0");
        double groupAverage = gradeProvider.groupAverages
            .firstWhere((e) => e.subject == subject, orElse: () => nullavg)
            .average;

        if (avg != 0) subjectAvgs[subject] = avg;

        i++;

        int homeworkCount = homeworkProvider.homework
            .where((e) =>
                e.subject.id == subject.id &&
                e.deadline.isAfter(DateTime.now()))
            .length;
        bool hasHomework = homeworkCount > 0;

        List<Exam> allExams = examProvider.exams;
        allExams.sort((a, b) => a.date.compareTo(b.date));

        Exam? nearestExam = allExams.firstWhereOrNull((e) =>
            e.subject.id == subject.id && e.writeDate.isAfter(DateTime.now()));

        bool hasUnder = (hasHomework || nearestExam != null) &&
            Provider.of<SettingsProvider>(context).qSubjectsSubTiles;

        return Padding(
          padding: i > 1 ? const EdgeInsets.only(top: 9.0) : EdgeInsets.zero,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    if (Provider.of<SettingsProvider>(context, listen: false)
                        .shadowEffect)
                      BoxShadow(
                        offset: const Offset(0, 21),
                        blurRadius: 23.0,
                        color: Theme.of(context).shadowColor,
                      )
                  ],
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16.0),
                    topRight: const Radius.circular(16.0),
                    bottomLeft: hasUnder
                        ? const Radius.circular(8.0)
                        : const Radius.circular(16.0),
                    bottomRight: hasUnder
                        ? const Radius.circular(8.0)
                        : const Radius.circular(16.0),
                  ),
                  color: Theme.of(context).colorScheme.background,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 6.0),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                    ),
                    child: GradeSubjectTile(
                      subject,
                      averageBefore: averageBefore,
                      average: avg,
                      groupAverage: avgDropValue == 0 ? groupAverage : 0.0,
                      onTap: () {
                        GradeSubjectView(subject, groupAverage: groupAverage)
                            .push(context, root: true);
                      },
                    ),
                  ),
                ),
              ),
              if (hasUnder)
                const SizedBox(
                  height: 6.0,
                ),
              if (hasHomework &&
                  Provider.of<SettingsProvider>(context).qSubjectsSubTiles)
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      if (Provider.of<SettingsProvider>(context, listen: false)
                          .shadowEffect)
                        BoxShadow(
                          offset: const Offset(0, 21),
                          blurRadius: 23.0,
                          color: Theme.of(context).shadowColor,
                        )
                    ],
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(8.0),
                      topRight: const Radius.circular(8.0),
                      bottomLeft: nearestExam != null
                          ? const Radius.circular(8.0)
                          : const Radius.circular(16.0),
                      bottomRight: nearestExam != null
                          ? const Radius.circular(8.0)
                          : const Radius.circular(16.0),
                    ),
                    color: Theme.of(context).colorScheme.background,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 8.0,
                      bottom: 8.0,
                      left: 15.0,
                      right: 8.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'you_have_hw'.i18n.fill([homeworkCount]),
                          style: const TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.w500),
                        ),
                        // const Icon(
                        //   FeatherIcons.chevronRight,
                        //   grade: 0.5,
                        //   size: 20.0,
                        // )
                      ],
                    ),
                  ),
                ),
              if (nearestExam != null &&
                  Provider.of<SettingsProvider>(context).qSubjectsSubTiles)
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      if (Provider.of<SettingsProvider>(context, listen: false)
                          .shadowEffect)
                        BoxShadow(
                          offset: const Offset(0, 21),
                          blurRadius: 23.0,
                          color: Theme.of(context).shadowColor,
                        )
                    ],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      topRight: Radius.circular(8.0),
                      bottomLeft: Radius.circular(16.0),
                      bottomRight: Radius.circular(16.0),
                    ),
                    color: Theme.of(context).colorScheme.background,
                  ),
                  child: ExamViewable(
                    nearestExam,
                    showSubject: false,
                    tilePadding: const EdgeInsets.symmetric(horizontal: 6.0),
                  ),
                ),
            ],
          ),
        );
      }));
    } else {
      tiles.clear();

      List<Grade> ghostGrades = calculatorProvider.ghosts;
      ghostGrades.sort((a, b) => -a.date.compareTo(b.date));

      List<GradeTile> _gradeTiles = [];
      for (Grade grade in ghostGrades) {
        _gradeTiles.add(GradeTile(
          grade,
          viewOverride: true,
        ));
      }

      tiles.add(
        _gradeTiles.isNotEmpty
            ? Panel(
                key: ValueKey(gradeCalcMode),
                title: Text(
                  "Ghost Grades".i18n,
                ),
                child: Column(
                  children: _gradeTiles,
                ),
              )
            : const SizedBox(),
      );
    }

    if (tiles.isNotEmpty || gradeCalcMode) {
      tiles.insert(0, yearlyGraph);
      tiles.insert(1, gradesCount);
      if (!gradeCalcMode) {
        tiles.insert(2, FailWarning(subjectAvgs: subjectAvgs));
        tiles.insert(
          3,
          PanelTitle(
              title: Text(
            avgDropValue == 0 ? "Subjects".i18n : "Subjects_changes".i18n,
          )),
        );

        // tiles.insert(4, const PanelHeader(padding: EdgeInsets.only(top: 12.0)));
        // tiles.add(const PanelFooter(padding: EdgeInsets.only(bottom: 12.0)));
      }
      tiles.add(Padding(
        padding: EdgeInsets.only(bottom: !gradeCalcMode ? 24.0 : 250.0),
      ));
    } else {
      tiles.insert(
        0,
        Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: Empty(subtitle: "empty".i18n),
        ),
      );
    }

    double subjectAvg = subjectAvgs.isNotEmpty
        ? subjectAvgs.values.fold(0.0, (double a, double b) => a + b) /
            subjectAvgs.length
        : 0.0;
    final double classAvg = gradeProvider.groupAverages.isNotEmpty
        ? gradeProvider.groupAverages
                .map((e) => e.average)
                .fold(0.0, (double a, double b) => a + b) /
            gradeProvider.groupAverages.length
        : 0.0;

    if (subjectAvg > 0 && !gradeCalcMode) {
      tiles.add(
        PanelTitle(title: Text("data".i18n)),
      );
      tiles.add(Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: StatisticsTile(
              fill: true,
              title: AutoSizeText(
                "subjectavg".i18n,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              value: subjectAvg,
            ),
          ),
          const SizedBox(width: 24.0),
          Expanded(
            child: StatisticsTile(
              outline: true,
              title: AutoSizeText(
                "classavg".i18n,
                textAlign: TextAlign.center,
                maxLines: 1,
                wrapWords: false,
                overflow: TextOverflow.ellipsis,
              ),
              value: classAvg,
            ),
          ),
        ],
      ));
    }

    tiles.add(Provider.of<PlusProvider>(context, listen: false).hasPremium
        ? const SizedBox()
        : const Padding(
            padding: EdgeInsets.only(top: 24.0),
            child: PremiumInline(features: [
              PremiumInlineFeature.goal,
              PremiumInlineFeature.stats,
            ]),
          ));

    // padding
    tiles.add(const SizedBox(height: 32.0));

    subjectTiles = List.castFrom(tiles);
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context);
    gradeProvider = Provider.of<GradeProvider>(context);
    updateProvider = Provider.of<UpdateProvider>(context);
    calculatorProvider = Provider.of<GradeCalculatorProvider>(context);
    homeworkProvider = Provider.of<HomeworkProvider>(context);
    examProvider = Provider.of<ExamProvider>(context);

    context.watch<PlusProvider>();

    List<String> nameParts = user.displayName?.split(" ") ?? ["?"];
    firstName = nameParts.length > 1 ? nameParts[1] : nameParts[0];

    final double totalClassAvg = gradeProvider.groupAverages.isEmpty
        ? 0.0
        : gradeProvider.groupAverages
                .map((e) => e.average)
                .fold(0.0, (double a, double b) => a + b) /
            gradeProvider.groupAverages.length;

    final now = gradeProvider.grades.isNotEmpty
        ? gradeProvider.grades
            .reduce((v, e) => e.date.isAfter(v.date) ? e : v)
            .date
        : DateTime.now();

    final currentStudentAvg = AverageHelper.averageEvals(!gradeCalcMode
        ? gradeProvider.grades
            .where((e) => e.type == GradeType.midYear)
            .toList()
        : calculatorProvider.grades);

    final prevStudentAvg = AverageHelper.averageEvals(gradeProvider.grades
        .where((e) => e.type == GradeType.midYear)
        .where((e) => e.date.isBefore(now.subtract(const Duration(days: 30))))
        .toList());

    List<Grade> graphGrades = !gradeCalcMode
        ? gradeProvider.grades
            .where((e) =>
                e.type == GradeType.midYear &&
                (avgDropValue == 0 ||
                    e.date.isAfter(
                        DateTime.now().subtract(Duration(days: avgDropValue)))))
            .toList()
        : calculatorProvider.grades
            .where(((e) =>
                avgDropValue == 0 ||
                e.date.isAfter(
                    DateTime.now().subtract(Duration(days: avgDropValue)))))
            .toList();

    yearlyGraph = Padding(
      padding: const EdgeInsets.only(top: 12.0, bottom: 8.0),
      child: Panel(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AverageSelector(
              value: avgDropValue,
              onChanged: (value) {
                setState(() {
                  avgDropValue = value!;
                });
              },
            ),
            Row(
              children: [
                // if (totalClassAvg >= 1.0) AverageDisplay(average: totalClassAvg, border: true),
                // const SizedBox(width: 4.0),
                TrendDisplay(
                    previous: prevStudentAvg, current: currentStudentAvg),
                if (gradeProvider.grades
                    .where((e) => e.type == GradeType.midYear)
                    .isNotEmpty)
                  AverageDisplay(average: currentStudentAvg),
              ],
            )
          ],
        ),
        child: Container(
          padding: const EdgeInsets.only(top: 12.0, right: 12.0),
          child:
              GradeGraph(graphGrades, dayThreshold: 2, classAvg: totalClassAvg),
        ),
      ),
    );

    gradesCount = Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Panel(child: GradesCount(grades: graphGrades)),
    );

    generateTiles();

    return Scaffold(
      key: _scaffoldKey,
      body: Padding(
        padding: const EdgeInsets.only(top: 9.0),
        child: NestedScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          headerSliverBuilder: (context, _) => [
            SliverAppBar(
              centerTitle: false,
              pinned: true,
              floating: false,
              snap: false,
              surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
              actions: [
                if (!gradeCalcMode)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5.0, vertical: 0.0),
                    child: IconButton(
                      splashRadius: 24.0,
                      onPressed: () {
                        showQuickSettings(context);
                      },
                      icon: Icon(
                        FeatherIcons.moreHorizontal,
                        color: AppColors.of(context).text,
                      ),
                    ),
                  ),

                // profile Icon
                Padding(
                  padding: const EdgeInsets.only(right: 24.0),
                  child: ProfileButton(
                    child: ProfileImage(
                      heroTag: "profile",
                      name: firstName,
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .tertiary, //ColorUtils.stringToColor(user.displayName ?? "?"),
                      badge: updateProvider.available,
                      role: user.role,
                      profilePictureString: user.picture,
                    ),
                  ),
                ),
              ],
              automaticallyImplyLeading: false,
              title: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "Grades".i18n,
                  style: TextStyle(
                      color: AppColors.of(context).text,
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              shadowColor: Theme.of(context).shadowColor,
            ),
          ],
          body: RefreshIndicator(
            onRefresh: () => gradeProvider.fetch(),
            color: Theme.of(context).colorScheme.secondary,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              physics: const BouncingScrollPhysics(),
              itemCount: max(subjectTiles.length, 1),
              itemBuilder: (context, index) {
                if (subjectTiles.isNotEmpty) {
                  EdgeInsetsGeometry panelPadding =
                      const EdgeInsets.symmetric(horizontal: 24.0);

                  if (subjectTiles[index].runtimeType == GradeSubjectTile) {
                    return Padding(
                        padding: panelPadding,
                        child: PanelBody(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: subjectTiles[index],
                        ));
                  } else {
                    return Padding(
                        padding: panelPadding, child: subjectTiles[index]);
                  }
                } else {
                  return Container();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  void gradeCalcTotal(BuildContext context) {
    calculatorProvider.clear();
    calculatorProvider.addAllGrades(gradeProvider.grades);

    _sheetController = _scaffoldKey.currentState?.showBottomSheet(
      (context) => const RoundedBottomSheet(
          borderRadius: 14.0, child: GradeCalculator(null)),
      backgroundColor: const Color(0x00000000),
      elevation: 12.0,
    );

    // Hide the fab and grades
    setState(() {
      gradeCalcMode = true;
    });

    _sheetController!.closed.then((value) {
      // Show fab and grades
      if (mounted) {
        setState(() {
          gradeCalcMode = false;
        });
      }
    });
  }

  void showQuickSettings(BuildContext context) {
    showRoundedModalBottomSheet(
      context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: BottomSheetMenu(items: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: Theme.of(context).colorScheme.background),
          child: ListTile(
            title: Row(
              children: [
                const Icon(FeatherIcons.plusCircle),
                const SizedBox(
                  width: 10.0,
                ),
                Text('grade_calc'.i18n),
              ],
            ),
            onTap: () {
              if (!Provider.of<PlusProvider>(context, listen: false)
                  .hasScope(PremiumScopes.totalGradeCalculator)) {
                PlusLockedFeaturePopup.show(
                    context: context, feature: PremiumFeature.gradeCalculation);
                return;
              }

              // SoonAlert.show(context: context);
              gradeCalcTotal(context);
            },
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: Theme.of(context).colorScheme.background),
          child: SwitchListTile(
            title: Row(
              children: [
                const Icon(Icons.edit_document),
                const SizedBox(
                  width: 10.0,
                ),
                Text('show_exams_homework'.i18n),
              ],
            ),
            value: Provider.of<SettingsProvider>(context, listen: false)
                .qSubjectsSubTiles,
            onChanged: (v) {
              Provider.of<SettingsProvider>(context, listen: false)
                  .update(qSubjectsSubTiles: v);

              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
        ),
      ]),
    );
  }
}
