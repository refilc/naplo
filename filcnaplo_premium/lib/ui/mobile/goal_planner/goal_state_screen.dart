import 'package:filcnaplo/api/providers/database_provider.dart';
import 'package:filcnaplo/api/providers/user_provider.dart';
import 'package:filcnaplo/helpers/average_helper.dart';
import 'package:filcnaplo/helpers/subject.dart';
import 'package:filcnaplo/models/settings.dart';
import 'package:filcnaplo_kreta_api/models/grade.dart';
import 'package:filcnaplo_kreta_api/models/subject.dart';
import 'package:filcnaplo_kreta_api/providers/grade_provider.dart';
import 'package:filcnaplo_mobile_ui/common/action_button.dart';
import 'package:filcnaplo_mobile_ui/common/average_display.dart';
import 'package:filcnaplo_mobile_ui/common/panel/panel.dart';
import 'package:filcnaplo_mobile_ui/common/progress_bar.dart';
import 'package:filcnaplo_mobile_ui/common/round_border_icon.dart';
import 'package:filcnaplo_premium/providers/goal_provider.dart';
import 'package:filcnaplo_premium/ui/mobile/goal_planner/goal_planner.dart';
import 'package:filcnaplo_premium/ui/mobile/goal_planner/goal_state_screen.i18n.dart';
import 'package:filcnaplo_premium/ui/mobile/goal_planner/route_option.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';

import 'goal_planner_screen.dart';
import 'graph.dart';

class GoalStateScreen extends StatefulWidget {
  final GradeSubject subject;

  const GoalStateScreen({Key? key, required this.subject}) : super(key: key);

  @override
  State<GoalStateScreen> createState() => _GoalStateScreenState();
}

class _GoalStateScreenState extends State<GoalStateScreen> {
  late UserProvider user;
  late DatabaseProvider db;
  late GradeProvider gradeProvider;
  late SettingsProvider settingsProvider;

  double currAvg = 0.0;
  double goalAvg = 0.0;
  double beforeAvg = 0.0;
  double afterAvg = 0.0;
  double avgDifference = 0;

  Plan? plan;

  late Widget gradeGraph;

  DateTime goalPinDate = DateTime.now();

  void fetchGoalAverages() async {
    var goalAvgRes = await db.userQuery.subjectGoalAverages(userId: user.id!);
    var beforeAvgRes = await db.userQuery.subjectGoalBefores(userId: user.id!);

    goalPinDate = DateTime.parse((await db.userQuery
        .subjectGoalPinDates(userId: user.id!))[widget.subject.id]!);

    String? goalAvgStr = goalAvgRes[widget.subject.id];
    String? beforeAvgStr = beforeAvgRes[widget.subject.id];
    goalAvg = double.parse(goalAvgStr ?? '0.0');
    beforeAvg = double.parse(beforeAvgStr ?? '0.0');

    avgDifference = ((goalAvg - beforeAvg) / beforeAvg.abs()) * 100;

    setState(() {});
  }

  void fetchGoalPlan() async {
    var planRes = await db.userQuery.subjectGoalPlans(userId: user.id!);
    List prePlan = planRes[widget.subject.id]!.split(',');
    prePlan.removeLast();

    plan = Plan(
      prePlan.map((e) => int.parse(e)).toList(),
    );

    setState(() {});
  }

  List<Grade> getSubjectGrades(GradeSubject subject) =>
      gradeProvider.grades.where((e) => (e.subject == subject)).toList();

  List<Grade> getAfterGoalGrades(GradeSubject subject) => gradeProvider.grades
      .where((e) => (e.subject == subject && e.date.isAfter(goalPinDate)))
      .toList();

  @override
  void initState() {
    super.initState();
    user = Provider.of<UserProvider>(context, listen: false);
    db = Provider.of<DatabaseProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchGoalAverages();
      fetchGoalPlan();
    });
  }

  @override
  Widget build(BuildContext context) {
    gradeProvider = Provider.of<GradeProvider>(context);
    settingsProvider = Provider.of<SettingsProvider>(context);

    var subjectGrades = getSubjectGrades(widget.subject).toList();
    currAvg = AverageHelper.averageEvals(subjectGrades);

    var afterGoalGrades = getAfterGoalGrades(widget.subject).toList();
    afterAvg = AverageHelper.averageEvals(afterGoalGrades);

    Color averageColor = currAvg >= 1 && currAvg <= 5
        ? ColorTween(
                begin: settingsProvider.gradeColors[currAvg.floor() - 1],
                end: settingsProvider.gradeColors[currAvg.ceil() - 1])
            .transform(currAvg - currAvg.floor())!
        : Theme.of(context).colorScheme.secondary;

    gradeGraph = Padding(
      padding: const EdgeInsets.only(
        top: 12.0,
        bottom: 8.0,
      ),
      child: Panel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 16.0, right: 12.0),
              child: GoalGraph(afterGoalGrades,
                  dayThreshold: 5, classAvg: goalAvg),
            ),
            const SizedBox(height: 5.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'look_at_graph'.i18n,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 23.0,
                    ),
                  ),
                  Text(
                    'thats_progress'.i18n,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 20.0,
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  ProgressBar(
                    value: currAvg / goalAvg,
                    backgroundColor: averageColor,
                    height: 16.0,
                  ),
                  const SizedBox(height: 8.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            decoration: const BoxDecoration(
                // image: DecorationImage(
                //   image:
                //       AssetImage('assets/images/subject_covers/math_light.png'),
                //   fit: BoxFit.fitWidth,
                //   alignment: Alignment.topCenter,
                // ),
                ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(0.2),
                    Theme.of(context).scaffoldBackgroundColor,
                  ],
                  stops: const [
                    0.1,
                    0.22,
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 60.0,
                  left: 2.0,
                  right: 2.0,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const BackButton(),
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0)),
                                title: Text("attention".i18n),
                                content: Text("attention_body".i18n),
                                actions: [
                                  ActionButton(
                                    label: "delete".i18n,
                                    onTap: () async {
                                      // clear the goal
                                      await Provider.of<GoalProvider>(context,
                                              listen: false)
                                          .clearGoal(widget.subject);
                                      // close the modal and the goal page
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: const Icon(FeatherIcons.x),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22.0),
                    Column(
                      children: [
                        RoundBorderIcon(
                          icon: Icon(
                            SubjectIcon.resolveVariant(
                              context: context,
                              subject: widget.subject,
                            ),
                            size: 26.0,
                            weight: 2.5,
                          ),
                          padding: 8.0,
                          width: 2.5,
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          (widget.subject.isRenamed
                                  ? widget.subject.renamedTo
                                  : widget.subject.name) ??
                              'goal_planner_title'.i18n,
                          style: const TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'almost_there'.i18n,
                          style: const TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.w400,
                            height: 1.0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'started_with'.i18n,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20.0,
                                ),
                              ),
                              const SizedBox(width: 5.0),
                              AverageDisplay(average: beforeAvg),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'current'.i18n,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20.0,
                                ),
                              ),
                              const SizedBox(width: 5.0),
                              AverageDisplay(average: currAvg),
                              const SizedBox(width: 5.0),
                              // ide majd kell average difference
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Panel(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'your_goal'.i18n,
                                  style: const TextStyle(
                                    fontSize: 23.0,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                RawMaterialButton(
                                  onPressed: () async {
                                    Navigator.of(context).push(
                                        CupertinoPageRoute(
                                            builder: (context) =>
                                                GoalPlannerScreen(
                                                    subject: widget.subject)));
                                  },
                                  fillColor: Colors.black,
                                  shape: const StadiumBorder(),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18.0),
                                  child: Text(
                                    "change_it".i18n,
                                    style: const TextStyle(
                                      height: 1.0,
                                      color: Colors.white,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  goalAvg.toString(),
                                  style: const TextStyle(
                                    height: 1.1,
                                    fontSize: 42.0,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(width: 10.0),
                                Center(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 5.0,
                                      horizontal: 8.0,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(45.0),
                                      color: avgDifference.isNegative
                                          ? Colors.redAccent.shade400
                                              .withOpacity(.15)
                                          : Colors.greenAccent.shade700
                                              .withOpacity(.15),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          avgDifference.isNegative
                                              ? FeatherIcons.chevronDown
                                              : FeatherIcons.chevronUp,
                                          color: avgDifference.isNegative
                                              ? Colors.redAccent.shade400
                                              : Colors.greenAccent.shade700,
                                          size: 18.0,
                                        ),
                                        const SizedBox(width: 5.0),
                                        Text(
                                          avgDifference.toStringAsFixed(2) +
                                              '%',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: avgDifference.isNegative
                                                ? Colors.redAccent.shade400
                                                : Colors.greenAccent.shade700,
                                            fontSize: 22.0,
                                            height: 0.8,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: gradeGraph,
                    ),
                    const SizedBox(height: 5.0),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 12.0,
                        right: 12.0,
                        top: 5.0,
                        bottom: 8.0,
                      ),
                      child: Panel(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'you_need'.i18n,
                                  style: const TextStyle(
                                    fontSize: 23.0,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            plan != null
                                ? RouteOptionRow(
                                    plan: plan!,
                                  )
                                : const Text(''),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
