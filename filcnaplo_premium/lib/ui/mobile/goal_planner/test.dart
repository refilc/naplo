import 'package:filcnaplo/helpers/subject.dart';
import 'package:filcnaplo/models/settings.dart';
import 'package:filcnaplo_kreta_api/models/grade.dart';
import 'package:filcnaplo_kreta_api/models/subject.dart';
import 'package:filcnaplo_kreta_api/providers/grade_provider.dart';
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

class GoalPlannerTest extends StatefulWidget {
  final Subject subject;

  const GoalPlannerTest({Key? key, required this.subject}) : super(key: key);

  @override
  State<GoalPlannerTest> createState() => _GoalPlannerTestState();
}

class _GoalPlannerTestState extends State<GoalPlannerTest> {
  late GradeProvider gradeProvider;
  late GradeCalculatorProvider calculatorProvider;
  late SettingsProvider settingsProvider;

  bool gradeCalcMode = false;

  List<Grade> getSubjectGrades(Subject subject) => !gradeCalcMode
      ? gradeProvider.grades.where((e) => e.subject == subject).toList()
      : calculatorProvider.grades.where((e) => e.subject == subject).toList();

  double goalValue = 4.0;
  List<Grade> grades = [];

  Plan? recommended;
  Plan? fastest;
  Plan? selectedRoute;
  List<Plan> otherPlans = [];

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

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(
              left: 22.0, right: 22.0, top: 5.0, bottom: 220.0),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const BackButton(),
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Text(
                    'goal_planner_title'.i18n,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 18.0),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                        fontSize: 42.0,
                        color: gradeColor(goalValue.round(), settingsProvider),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "select_subject".i18n,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Column(
                      children: [
                        Icon(
                          SubjectIcon.resolveVariant(
                            context: context,
                            subject: widget.subject,
                          ),
                          size: 48.0,
                        ),
                        Text(
                          (widget.subject.isRenamed
                                  ? widget.subject.renamedTo
                                  : widget.subject.name) ??
                              '',
                          style: const TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
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
            if (result != PlanResult.available) Text(result.name),
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
                color: Colors.white,
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
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Hamarosan...")));
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
