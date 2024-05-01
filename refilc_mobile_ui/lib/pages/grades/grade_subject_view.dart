import 'dart:math';

import 'package:animations/animations.dart';
import 'package:refilc/api/providers/database_provider.dart';
import 'package:refilc/api/providers/user_provider.dart';
import 'package:refilc/models/settings.dart';
import 'package:refilc/ui/widgets/lesson/lesson_tile.dart';
import 'package:refilc/utils/format.dart';
import 'package:refilc_kreta_api/controllers/timetable_controller.dart';
import 'package:refilc_kreta_api/models/exam.dart';
import 'package:refilc_kreta_api/models/lesson.dart';
import 'package:refilc_kreta_api/providers/exam_provider.dart';
// import 'package:refilc_kreta_api/client/api.dart';
// import 'package:refilc_kreta_api/client/client.dart';
import 'package:refilc_kreta_api/providers/grade_provider.dart';
import 'package:refilc/helpers/average_helper.dart';
import 'package:refilc/helpers/subject.dart';
import 'package:refilc_kreta_api/models/grade.dart';
import 'package:refilc_kreta_api/models/subject.dart';
import 'package:refilc_mobile_ui/common/average_display.dart';
import 'package:refilc_mobile_ui/common/bottom_sheet_menu/rounded_bottom_sheet.dart';
import 'package:refilc_mobile_ui/common/filter_bar.dart';
import 'package:refilc_mobile_ui/common/panel/panel.dart';
import 'package:refilc_mobile_ui/common/splitted_panel/splitted_panel.dart';
import 'package:refilc_mobile_ui/common/trend_display.dart';
import 'package:refilc_mobile_ui/common/widgets/cretification/certification_tile.dart';
import 'package:refilc/ui/widgets/grade/grade_tile.dart';
import 'package:refilc_mobile_ui/common/widgets/exam/exam_viewable.dart';
import 'package:refilc_mobile_ui/common/widgets/grade/grade_viewable.dart';
import 'package:refilc_mobile_ui/common/hero_scrollview.dart';
import 'package:refilc_mobile_ui/pages/grades/calculator/grade_calculator.dart';
import 'package:refilc_mobile_ui/pages/grades/calculator/grade_calculator_provider.dart';
import 'package:refilc_mobile_ui/pages/grades/grades_count.dart';
import 'package:refilc_mobile_ui/pages/grades/graph.dart';
import 'package:refilc_mobile_ui/pages/grades/subject_grades_container.dart';
import 'package:refilc_plus/ui/mobile/goal_planner/goal_planner_screen.dart';
// import 'package:refilc_plus/models/premium_scopes.dart';
// import 'package:refilc_plus/providers/plus_provider.dart';
import 'package:refilc_plus/ui/mobile/goal_planner/goal_state_screen.dart';
// import 'package:refilc_plus/ui/mobile/plus/upsell.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'grades_page.i18n.dart';
// import 'package:refilc_plus/ui/mobile/goal_planner/new_goal.dart';

class GradeSubjectView extends StatefulWidget {
  const GradeSubjectView(this.subject, {super.key, this.groupAverage = 0.0});

  final GradeSubject subject;
  final double groupAverage;

  void push(BuildContext context, {bool root = false}) {
    Navigator.of(context, rootNavigator: root)
        .push(CupertinoPageRoute(builder: (context) => this));
  }

  @override
  State<GradeSubjectView> createState() => _GradeSubjectViewState();
}

class _GradeSubjectViewState extends State<GradeSubjectView>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Controllers
  PersistentBottomSheetController? _sheetController;
  final ScrollController _scrollController = ScrollController();
  late TabController _tabController;

  List<Widget> gradeTiles = [];

  // Providers
  late GradeProvider gradeProvider;
  late GradeCalculatorProvider calculatorProvider;
  late SettingsProvider settingsProvider;
  late DatabaseProvider dbProvider;
  late UserProvider user;
  late ExamProvider examProvider;

  late TimetableController _timetableController;

  late double average;
  late Widget gradeGraph;

  bool gradeCalcMode = false;

  String plan = '';

  List<Grade> getSubjectGrades(GradeSubject subject) => !gradeCalcMode
      ? gradeProvider.grades.where((e) => e.subject == subject).toList()
      : calculatorProvider.grades.where((e) => e.subject == subject).toList();
  List<Exam> getSubjectExams(GradeSubject subject) =>
      examProvider.exams.where((e) => e.subject == subject).toList();

  bool showGraph(List<Grade> subjectGrades) {
    if (gradeCalcMode) return true;

    final gradeDates = subjectGrades.map((e) => e.date.millisecondsSinceEpoch);
    final maxGradeDate = gradeDates.fold(0, max);
    final minGradeDate = gradeDates.fold(0, min);
    if (maxGradeDate - minGradeDate < const Duration(days: 5).inMilliseconds) {
      return false; // naplo/#78
    }

    return subjectGrades.where((e) => e.type == GradeType.midYear).length > 1;
  }

  void buildTiles(
    List<Grade> subjectGrades, {
    List<Lesson>? nextWeekLessons,
    List<Exam>? subjectExams,
  }) {
    List<Widget> tiles = [];

    tiles.add(Panel(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.subject.renamedTo ?? widget.subject.name.capital(),
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          Text(
            ((widget.subject.teacher?.isRenamed ?? false) &&
                        settingsProvider.renamedTeachersEnabled
                    ? widget.subject.teacher?.renamedTo
                    : widget.subject.teacher?.name.capital()) ??
                '',
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              height: 1.6,
            ),
          ),
        ],
      ),
    ));

    tiles.addAll(
      [
        const SizedBox(
          height: 5.0,
        ),
        FilterBar(
          padding: EdgeInsets.zero,
          items: [
            Tab(text: "grades".i18n),
            Tab(text: "timetable".i18n),
            Tab(text: "exams".i18n),
          ],
          controller: _tabController,
          disableFading: true,
        ),
      ],
    );

    if (showGraph(subjectGrades) && _tabController.index == 0) {
      tiles.add(gradeGraph);
    } else {
      tiles.add(Container(height: 20.0));
    }

    if (_tabController.index == 0) {
      tiles.add(Padding(
        padding: const EdgeInsets.only(bottom: 24.0),
        child: Panel(
          child: GradesCount(grades: getSubjectGrades(widget.subject).toList()),
        ),
      ));
    }

    // ignore: no_leading_underscores_for_local_identifiers
    List<Widget> _tiles = [];

    if (!gradeCalcMode) {
      if (_tabController.index == 0) {
        subjectGrades.sort((a, b) => -a.date.compareTo(b.date));

        _tiles.add(const SizedBox(
          height: 4.0,
        ));

        for (var grade in subjectGrades) {
          if (grade.type == GradeType.midYear) {
            _tiles.add(GradeViewable(grade));
          } else {
            _tiles.add(CertificationTile(
              grade,
              padding: EdgeInsets.only(
                  bottom: 8.0,
                  top: (subjectGrades.first.id == grade.id) ? 0.0 : 8.0),
              newStyle: true,
            ));
          }
        }

        _tiles.add(const SizedBox(
          height: 4.0,
        ));
      }
      if (_tabController.index == 1) {
        nextWeekLessons!.sort((a, b) => -a.date.compareTo(b.date));

        for (var lesson in nextWeekLessons) {
          _tiles.add(LessonTile(
            lesson,
            subjectPageView: true,
          ));
        }
      }
      if (_tabController.index == 2) {
        subjectExams!.sort((a, b) => -a.writeDate.compareTo(b.writeDate));

        for (var exam in subjectExams) {
          _tiles.add(ExamViewable(
            exam,
            showSubject: false,
          ));
        }
      }
    } else if (subjectGrades.isNotEmpty) {
      _tiles.add(const SizedBox(
        height: 8.0,
      ));

      subjectGrades.sort((a, b) => -a.date.compareTo(b.date));
      for (var grade in subjectGrades) {
        _tiles.add(GradeTile(grade));
      }

      _tiles.add(const SizedBox(
        height: 8.0,
      ));
    }
    tiles.add(
      PageTransitionSwitcher(
        transitionBuilder: (
          Widget child,
          Animation<double> primaryAnimation,
          Animation<double> secondaryAnimation,
        ) {
          return SharedAxisTransition(
            animation: primaryAnimation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.vertical,
            fillColor: Colors.transparent,
            child: child,
          );
        },
        child: _tiles.isNotEmpty
            ? (_tabController.index == 0
                ? Panel(
                    key: ValueKey(gradeCalcMode),
                    title: Text(
                      gradeCalcMode ? "Ghost Grades".i18n : "Grades".i18n,
                    ),
                    child: Column(
                      children: _tiles,
                    ))
                : _tabController.index == 1
                    ? SplittedPanel(
                        padding: EdgeInsets.zero,
                        cardPadding: const EdgeInsets.only(
                            left: 6.0, right: 12.0, top: 6.0, bottom: 6.0),
                        title: Text("upcoming_lessons".i18n),
                        children: _tiles,
                      )
                    : SplittedPanel(
                        padding: EdgeInsets.zero,
                        title: Text("exams".i18n),
                        children: _tiles,
                      ))
            : const SizedBox(),
      ),
    );

    tiles.add(Padding(
        padding: EdgeInsets.only(bottom: !gradeCalcMode ? 24.0 : 269.0)));
    gradeTiles = List.castFrom(tiles);
  }

  @override
  void initState() {
    super.initState();
    user = Provider.of<UserProvider>(context, listen: false);
    dbProvider = Provider.of<DatabaseProvider>(context, listen: false);

    _tabController = TabController(length: 3, vsync: this);

    _timetableController = TimetableController();
    _timetableController.jump(_timetableController.currentWeek,
        context: context, initial: true, skip: true);
    if (DateTime.now().day > 5) {
      _timetableController.next(context);
    }
  }

  void fetchGoalPlans() async {
    plan = (await dbProvider.userQuery
            .subjectGoalPlans(userId: user.id!))[widget.subject.id] ??
        '';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    gradeProvider = Provider.of<GradeProvider>(context);
    calculatorProvider = Provider.of<GradeCalculatorProvider>(context);
    settingsProvider = Provider.of<SettingsProvider>(context);
    examProvider = Provider.of<ExamProvider>(context);

    List<Lesson> nextWeekLessons = (_timetableController.days ?? [])
        .expand((e) => e)
        .where((e) => e.subject.id == widget.subject.id)
        .toList();
    List<Exam> subjectExams = getSubjectExams(widget.subject);

    List<Grade> subjectGrades = getSubjectGrades(widget.subject).toList();
    average = AverageHelper.averageEvals(subjectGrades);
    final prevAvg = subjectGrades.isNotEmpty
        ? AverageHelper.averageEvals(subjectGrades
            .where((e) => e.date.isBefore(subjectGrades
                .reduce((v, e) => e.date.isAfter(v.date) ? e : v)
                .date
                .subtract(const Duration(days: 30))))
            .toList())
        : 0.0;

    gradeGraph = Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Panel(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("annual_average".i18n),
            if (average != prevAvg)
              TrendDisplay(current: average, previous: prevAvg),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.only(top: 16.0, right: 12.0),
          child: GradeGraph(subjectGrades,
              dayThreshold: 5, classAvg: widget.groupAverage),
        ),
      ),
    );

    if (!gradeCalcMode) {
      buildTiles(
        subjectGrades,
        nextWeekLessons: nextWeekLessons,
        subjectExams: subjectExams,
      );
    } else {
      List<Grade> ghostGrades = calculatorProvider.ghosts
          .where((e) => e.subject == widget.subject)
          .toList();
      buildTiles(ghostGrades);
    }

    fetchGoalPlans();

    return Scaffold(
        key: _scaffoldKey,
        floatingActionButtonLocation: ExpandableFab.location,
        floatingActionButton: Visibility(
          visible: !gradeCalcMode &&
              subjectGrades
                  .where((e) => e.type == GradeType.midYear)
                  .isNotEmpty,
          child: ExpandableFab(
            type: ExpandableFabType.up,
            distance: 50,
            childrenOffset: const Offset(-3.8, 0.0),
            children: [
              FloatingActionButton.small(
                heroTag: "btn_ghost_grades",
                backgroundColor: Theme.of(context).colorScheme.secondary,
                onPressed: () {
                  gradeCalc(context);
                },
                child: const Icon(FeatherIcons.plus),
              ),
              FloatingActionButton.small(
                heroTag: "btn_goal_planner",
                backgroundColor: Theme.of(context).colorScheme.secondary,
                onPressed: () {
                  // if (!Provider.of<PlusProvider>(context, listen: false)
                  //     .hasScope(PremiumScopes.goalPlanner)) {
                  //   PlusLockedFeaturePopup.show(
                  //       context: context, feature: PremiumFeature.goalplanner);
                  //   return;
                  // }

                  // ScaffoldMessenger.of(context).showSnackBar(
                  //     const SnackBar(content: Text("Hamarosan...")));

                  Navigator.of(context).push(CupertinoPageRoute(
                      builder: (context) =>
                          GoalPlannerScreen(subject: widget.subject)));
                },
                child: const Icon(FeatherIcons.flag, size: 20.0),
              ),
            ],
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {},
          color: Theme.of(context).colorScheme.secondary,
          child: HeroScrollView(
            showTitleUnscroll: false,
            onClose: () {
              if (_sheetController != null && gradeCalcMode) {
                _sheetController!.close();
              } else {
                Navigator.of(context).pop();
              }
            },
            navBarItems: [
              const SizedBox(width: 6.0),
              if (widget.groupAverage != 0)
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    child: AverageDisplay(
                        average: widget.groupAverage, border: true),
                  ),
                ),
              const SizedBox(width: 6.0),
              if (average != 0)
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    child: AverageDisplay(average: average),
                  ),
                ),
              const SizedBox(width: 6.0),
              if (plan != '')
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(CupertinoPageRoute(
                            builder: (context) =>
                                GoalStateScreen(subject: widget.subject)));
                      },
                      child: Container(
                        width: 54.0,
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(45.0),
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(.15),
                        ),
                        child: Icon(
                          FeatherIcons.flag,
                          size: 17.0,
                          weight: 2.5,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ),
              const SizedBox(width: 12.0),
            ],
            icon: SubjectIcon.resolveVariant(
                subject: widget.subject, context: context),
            scrollController: _scrollController,
            title: widget.subject.renamedTo ?? widget.subject.name.capital(),
            italic: settingsProvider.renamedSubjectsItalics &&
                widget.subject.isRenamed,
            //   child: TabBarView(
            //       physics: const BouncingScrollPhysics(),
            //       controller: _tabController,
            //       children: List.generate(
            //           3, (index) => filterViewBuilder(context, index))),
            // ),
            child: SubjectGradesContainer(
              child: CupertinoScrollbar(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  shrinkWrap: true,
                  itemBuilder: (context, index) => gradeTiles[index],
                  itemCount: gradeTiles.length,
                ),
              ),
            ),
          ),
        ));
  }

  Widget filterViewBuilder(context, int activeData) {
    return Container();
  }

  void gradeCalc(BuildContext context) {
    // Scroll to the top of the page
    _scrollController.animateTo(100,
        duration: const Duration(milliseconds: 500), curve: Curves.ease);

    calculatorProvider.clear();
    calculatorProvider.addAllGrades(gradeProvider.grades);

    _sheetController = _scaffoldKey.currentState?.showBottomSheet(
      (context) => RoundedBottomSheet(
          borderRadius: 14.0, child: GradeCalculator(widget.subject)),
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
}
