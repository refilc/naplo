import 'package:filcnaplo/api/providers/database_provider.dart';
import 'package:filcnaplo/api/providers/user_provider.dart';
import 'package:filcnaplo/helpers/average_helper.dart';
import 'package:filcnaplo/helpers/subject.dart';
import 'package:filcnaplo/models/settings.dart';
import 'package:filcnaplo_kreta_api/models/grade.dart';
import 'package:filcnaplo_kreta_api/models/group_average.dart';
import 'package:filcnaplo_kreta_api/models/subject.dart';
import 'package:filcnaplo_kreta_api/providers/grade_provider.dart';
import 'package:filcnaplo_mobile_ui/common/average_display.dart';
import 'package:filcnaplo_mobile_ui/common/round_border_icon.dart';
import 'package:filcnaplo_mobile_ui/pages/grades/calculator/grade_calculator_provider.dart';
import 'package:filcnaplo_premium/ui/mobile/goal_planner/goal_input.dart';
import 'package:filcnaplo_premium/ui/mobile/goal_planner/goal_planner.dart';
import 'package:filcnaplo_premium/ui/mobile/goal_planner/goal_planner_screen.i18n.dart';
import 'package:filcnaplo_premium/ui/mobile/goal_planner/route_option.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum PlanResult {
  available, // There are possible solutions
  unreachable, // The solutions are too hard don't even try
  unsolvable, // There are no solutions
  reached, // Goal already reached
}

class GoalPlannerScreen extends StatefulWidget {
  final GradeSubject subject;

  const GoalPlannerScreen({Key? key, required this.subject}) : super(key: key);

  @override
  State<GoalPlannerScreen> createState() => _GoalPlannerScreenState();
}

class _GoalPlannerScreenState extends State<GoalPlannerScreen> {
  late GradeProvider gradeProvider;
  late GradeCalculatorProvider calculatorProvider;
  late SettingsProvider settingsProvider;
  late DatabaseProvider dbProvider;
  late UserProvider user;

  bool gradeCalcMode = false;

  List<Grade> getSubjectGrades(GradeSubject subject) => !gradeCalcMode
      ? gradeProvider.grades.where((e) => e.subject == subject).toList()
      : calculatorProvider.grades.where((e) => e.subject == subject).toList();

  double goalValue = 4.0;
  List<Grade> grades = [];

  Plan? recommended;
  Plan? fastest;
  Plan? selectedRoute;
  List<Plan> otherPlans = [];

  @override
  void initState() {
    super.initState();
    user = Provider.of<UserProvider>(context, listen: false);
    dbProvider = Provider.of<DatabaseProvider>(context, listen: false);
  }

  Future<Map<String, String>> fetchGoalPlans() async {
    return await dbProvider.userQuery.subjectGoalPlans(userId: user.id!);
  }

  Future<Map<String, String>> fetchGoalAverages() async {
    return await dbProvider.userQuery.subjectGoalAverages(userId: user.id!);
  }

  // haha bees lol
  Future<Map<String, String>> fetchGoalBees() async {
    return await dbProvider.userQuery.subjectGoalBefores(userId: user.id!);
  }

  Future<Map<String, String>> fetchGoalPinDates() async {
    return await dbProvider.userQuery.subjectGoalPinDates(userId: user.id!);
  }

  PlanResult getResult() {
    final currentAvg = GoalPlannerHelper.averageEvals(grades);

    recommended = null;
    fastest = null;
    otherPlans = [];

    if (currentAvg >= goalValue) return PlanResult.reached;

    final planner = GoalPlanner(goalValue, grades);
    final plans = planner.solve();

    plans.sort((a, b) => (a.avg - (2 * goalValue + 5) / 3)
        .abs()
        .compareTo(b.avg - (2 * goalValue + 5) / 3));

    try {
      final singleSolution = plans.every((e) => e.sigma == 0);
      recommended =
          plans.where((e) => singleSolution ? true : e.sigma > 0).first;
      plans.removeWhere((e) => e == recommended);
    } catch (_) {}

    plans.sort((a, b) => a.plan.length.compareTo(b.plan.length));

    try {
      fastest = plans.removeAt(0);
    } catch (_) {}

    if ((recommended?.plan.length ?? 0) - (fastest?.plan.length ?? 0) >= 3) {
      recommended = fastest;
    }

    if (recommended == null) {
      recommended = null;
      fastest = null;
      otherPlans = [];
      selectedRoute = null;
      return PlanResult.unsolvable;
    }

    if (recommended!.plan.length > 10) {
      recommended = null;
      fastest = null;
      otherPlans = [];
      selectedRoute = null;
      return PlanResult.unreachable;
    }

    otherPlans = List.from(plans);

    return PlanResult.available;
  }

  void getGrades() {
    grades = getSubjectGrades(widget.subject).toList();
  }

  @override
  Widget build(BuildContext context) {
    gradeProvider = Provider.of<GradeProvider>(context);
    calculatorProvider = Provider.of<GradeCalculatorProvider>(context);
    settingsProvider = Provider.of<SettingsProvider>(context);

    getGrades();

    final currentAvg = GoalPlannerHelper.averageEvals(grades);

    final result = getResult();

    List<Grade> subjectGrades = getSubjectGrades(widget.subject);

    double avg = AverageHelper.averageEvals(subjectGrades);

    var nullavg = GroupAverage(average: 0.0, subject: widget.subject, uid: "0");
    double groupAverage = gradeProvider.groupAverages
        .firstWhere((e) => e.subject == widget.subject, orElse: () => nullavg)
        .average;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(
            top: 5.0,
            bottom: 220.0,
            right: 15.0,
            left: 2.0,
          ),
          children: [
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     const BackButton(),
            //     Padding(
            //       padding: const EdgeInsets.only(right: 15.0),
            //       child: Row(
            //         children: [
            //           Text(
            //             'goal_planner_title'.i18n,
            //             style: const TextStyle(
            //                 fontWeight: FontWeight.w500, fontSize: 18.0),
            //           ),
            //           const SizedBox(
            //             width: 5,
            //           ),
            //           const BetaChip(),
            //         ],
            //       ),
            //     ),
            //   ],
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    const BackButton(),
                    RoundBorderIcon(
                      icon: Icon(
                        SubjectIcon.resolveVariant(
                          context: context,
                          subject: widget.subject,
                        ),
                        size: 18,
                        weight: 1.5,
                      ),
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      (widget.subject.isRenamed
                              ? widget.subject.renamedTo
                              : widget.subject.name) ??
                          'goal_planner_title'.i18n,
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    if (groupAverage != 0)
                      AverageDisplay(average: groupAverage, border: true),
                    const SizedBox(width: 6.0),
                    AverageDisplay(average: avg),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            Padding(
              padding: const EdgeInsets.only(left: 22.0, right: 22.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "set_a_goal".i18n,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    goalValue.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 48.0,
                      color: gradeColor(goalValue.round(), settingsProvider),
                    ),
                  ),
                  // Column(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Text(
                  //       "select_subject".i18n,
                  //       style: const TextStyle(
                  //         fontWeight: FontWeight.bold,
                  //         fontSize: 20.0,
                  //       ),
                  //     ),
                  //     const SizedBox(height: 4.0),
                  //     Column(
                  //       children: [
                  //         Icon(
                  //           SubjectIcon.resolveVariant(
                  //             context: context,
                  //             subject: widget.subject,
                  //           ),
                  //           size: 48.0,
                  //         ),
                  //         Text(
                  //           (widget.subject.isRenamed
                  //                   ? widget.subject.renamedTo
                  //                   : widget.subject.name) ??
                  //               '',
                  //           style: const TextStyle(
                  //             fontSize: 17.0,
                  //             fontWeight: FontWeight.w500,
                  //           ),
                  //         )
                  //       ],
                  //     )
                  //   ],
                  // )
                  const SizedBox(height: 24.0),
                  Text(
                    "pick_route".i18n,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  if (recommended != null)
                    RouteOption(
                      plan: recommended!,
                      mark: RouteMark.recommended,
                      selected: selectedRoute == recommended!,
                      onSelected: () => setState(() {
                        selectedRoute = recommended;
                      }),
                    ),
                  if (fastest != null && fastest != recommended)
                    RouteOption(
                      plan: fastest!,
                      mark: RouteMark.fastest,
                      selected: selectedRoute == fastest!,
                      onSelected: () => setState(() {
                        selectedRoute = fastest;
                      }),
                    ),
                  ...otherPlans.map((e) => RouteOption(
                        plan: e,
                        selected: selectedRoute == e,
                        onSelected: () => setState(() {
                          selectedRoute = e;
                        }),
                      )),
                  if (result != PlanResult.available) Text(result.name.i18n),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: MediaQuery.removePadding(
        context: context,
        removeBottom: false,
        removeTop: true,
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Container(
            padding: const EdgeInsets.only(top: 24.0),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.1),
                    blurRadius: 8.0,
                  )
                ]),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GoalInput(
                      value: goalValue,
                      currentAverage: currentAvg,
                      onChanged: (v) => setState(() {
                        selectedRoute = null;
                        goalValue = v;
                      }),
                    ),
                    const SizedBox(height: 24.0),
                    SizedBox(
                      width: double.infinity,
                      child: RawMaterialButton(
                        onPressed: () async {
                          if (selectedRoute == null) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('${"pick_route".i18n}...')));
                          }

                          final goalPlans = await fetchGoalPlans();
                          final goalAvgs = await fetchGoalAverages();
                          final goalBeforeGrades = await fetchGoalBees();
                          final goalPinDates = await fetchGoalPinDates();

                          goalPlans[widget.subject.id] =
                              selectedRoute!.dbString;
                          goalAvgs[widget.subject.id] =
                              goalValue.toStringAsFixed(2);
                          goalBeforeGrades[widget.subject.id] =
                              avg.toStringAsFixed(2);
                          goalPinDates[widget.subject.id] =
                              DateTime.now().toIso8601String();
                          // goalPlans[widget.subject.id] = '1,2,3,4,5,';
                          // goalAvgs[widget.subject.id] = '3.69';
                          // goalBeforeGrades[widget.subject.id] = '3.69';
                          // goalPinDates[widget.subject.id] =
                          //     DateTime.now().toIso8601String();

                          await dbProvider.userStore.storeSubjectGoalPlans(
                              goalPlans,
                              userId: user.id!);
                          await dbProvider.userStore.storeSubjectGoalAverages(
                              goalAvgs,
                              userId: user.id!);
                          await dbProvider.userStore.storeSubjectGoalBefores(
                              goalBeforeGrades,
                              userId: user.id!);
                          await dbProvider.userStore.storeSubjectGoalPinDates(
                              goalPinDates,
                              userId: user.id!);

                          Navigator.of(context).pop();
                        },
                        fillColor: Theme.of(context).colorScheme.primary,
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          "track_it".i18n,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
