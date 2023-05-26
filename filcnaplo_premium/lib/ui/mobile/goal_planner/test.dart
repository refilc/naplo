import 'package:filcnaplo_kreta_api/models/grade.dart';
import 'package:filcnaplo_premium/ui/mobile/goal_planner/goal_input.dart';
import 'package:filcnaplo_premium/ui/mobile/goal_planner/goal_planner.dart';
import 'package:filcnaplo_premium/ui/mobile/goal_planner/route_option.dart';
import 'package:flutter/material.dart';

enum PlanResult {
  available, // There are possible solutions
  unreachable, // The solutions are too hard don't even try
  unsolvable, // There are no solutions
  reached, // Goal already reached
}

class GoalPlannerTest extends StatefulWidget {
  const GoalPlannerTest({Key? key}) : super(key: key);

  @override
  State<GoalPlannerTest> createState() => _GoalPlannerTestState();
}

class _GoalPlannerTestState extends State<GoalPlannerTest> {
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

    plans.sort((a, b) => (a.avg - (2 * goalValue + 5) / 3).abs().compareTo(b.avg - (2 * goalValue + 5) / 3));

    try {
      final singleSolution = plans.every((e) => e.sigma == 0);
      recommended = plans.where((e) => singleSolution ? true : e.sigma > 0).first;
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

  @override
  Widget build(BuildContext context) {
    final currentAvg = GoalPlannerHelper.averageEvals(grades);

    final result = getResult();

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            const Align(
              alignment: Alignment.topLeft,
              child: BackButton(),
            ),
            const SizedBox(height: 12.0),
            const Text(
              "Set a goal",
              style: TextStyle(
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
                color: gradeColor(goalValue.round()),
              ),
            ),
            const SizedBox(height: 24.0),
            const Text(
              "Pick a route",
              style: TextStyle(
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
                color: const Color.fromARGB(255, 215, 255, 242),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24.0)),
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
                        onPressed: () {},
                        fillColor: const Color(0xff01342D),
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: const Text(
                          "Track it!",
                          style: TextStyle(
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
