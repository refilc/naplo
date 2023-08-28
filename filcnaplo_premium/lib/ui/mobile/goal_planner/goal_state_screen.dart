import 'package:filcnaplo/api/providers/database_provider.dart';
import 'package:filcnaplo/api/providers/user_provider.dart';
import 'package:filcnaplo/helpers/subject.dart';
import 'package:filcnaplo_kreta_api/models/subject.dart';
import 'package:filcnaplo_mobile_ui/common/average_display.dart';
import 'package:filcnaplo_mobile_ui/common/panel/panel.dart';
import 'package:filcnaplo_mobile_ui/common/round_border_icon.dart';
import 'package:filcnaplo_premium/ui/mobile/goal_planner/goal_state_screen.i18n.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GoalStateScreen extends StatefulWidget {
  final Subject subject;

  const GoalStateScreen({Key? key, required this.subject}) : super(key: key);

  @override
  State<GoalStateScreen> createState() => _GoalStateScreenState();
}

class _GoalStateScreenState extends State<GoalStateScreen> {
  late UserProvider user;
  late DatabaseProvider db;

  double goalAvg = 0.0;
  double beforeAvg = 0.0;
  double avgDifference = 0;

  @override
  void initState() {
    super.initState();
    user = Provider.of<UserProvider>(context, listen: false);
    db = Provider.of<DatabaseProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchGoalAverages();
    });
  }

  void fetchGoalAverages() async {
    var goalAvgRes = await db.userQuery.subjectGoalAverages(userId: user.id!);
    var beforeAvgRes = await db.userQuery.subjectGoalBefores(userId: user.id!);

    String? goalAvgStr = goalAvgRes[widget.subject.id];
    String? beforeAvgStr = beforeAvgRes[widget.subject.id];
    goalAvg = double.parse(goalAvgStr ?? '0.0');
    beforeAvg = double.parse(beforeAvgStr ?? '0.0');

    avgDifference = ((goalAvg - beforeAvg) / beforeAvg.abs()) * 100;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/subject_covers/math_light.png'),
            fit: BoxFit.fitWidth,
            alignment: Alignment.topCenter,
          ),
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
            padding: const EdgeInsets.only(top: 10.0, left: 2.0, right: 2.0),
            child: ListView(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    BackButton(),
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
                          children: [
                            Text(
                              'your_goal'.i18n,
                              style: const TextStyle(
                                fontSize: 23.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            RawMaterialButton(
                              onPressed: () async {},
                              fillColor: Colors.black,
                              shape: const StadiumBorder(),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 18.0),
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
                          children: [
                            Text(
                              goalAvg.toString(),
                              style: const TextStyle(
                                height: 1.1,
                                fontSize: 42.0,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Center(
                              child: Container(
                                width: 54.0,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(45.0),
                                  color: Colors.limeAccent.shade700
                                      .withOpacity(.15),
                                ),
                                child: Text(avgDifference.toString()),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
