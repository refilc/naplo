import 'package:filcnaplo/api/providers/database_provider.dart';
import 'package:filcnaplo/api/providers/user_provider.dart';
import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:filcnaplo_kreta_api/models/subject.dart';
import 'package:filcnaplo_mobile_ui/common/average_display.dart';
import 'package:filcnaplo_premium/ui/mobile/goal_planner/goal_state_screen.i18n.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GoalCompleteModal extends StatelessWidget {
  const GoalCompleteModal(
    this.subject, {
    Key? key,
    required this.user,
    required this.database,
    required this.goalAverage,
    required this.beforeAverage,
    required this.averageDifference,
  }) : super(key: key);

  final UserProvider user;
  final DatabaseProvider database;
  final GradeSubject subject;

  final double goalAverage;
  final double beforeAverage;
  final double averageDifference;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage('assets/images/static_confetti.png'),
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.topCenter,
                ),
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: const EdgeInsets.all(6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    goalAverage.toStringAsFixed(1),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 64.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  // const SizedBox(width: 10.0),
                  // Icon(
                  //   SubjectIcon.resolveVariant(
                  //       subject: subject, context: context),
                  //   color: Colors.white,
                  //   size: 64.0,
                  // ),
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              'congrats_title'.i18n,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 27.0,
                fontWeight: FontWeight.w700,
                height: 1.2,
                color: AppColors.of(context).text,
              ),
            ),
            Text(
              'goal_reached'.i18n.fill(['20']),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                height: 1.1,
                color: AppColors.of(context).text,
              ),
            ),
            const SizedBox(height: 18.0),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'started_at'.i18n,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.w500,
                        color: AppColors.of(context).text,
                      ),
                    ),
                    const SizedBox(width: 5.0),
                    AverageDisplay(
                      average: beforeAverage,
                    ),
                  ],
                ),
                Text(
                  'improved_by'.i18n.fill([
                    averageDifference.toStringAsFixed(2) + '%',
                  ]),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.w500,
                    color: AppColors.of(context).text,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Hamarosan...")),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFCAECFA),
                          Color(0xFFF4D9EE),
                          Color(0xFFF3EFDA),
                        ],
                        stops: [0.0, 0.53, 1.0],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'detailed_stats'.i18n,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF691A9B),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: const Color.fromARGB(38, 131, 131, 131),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'later'.i18n,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w700,
                          color: AppColors.of(context).text,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    // return Padding(
    //   padding: const EdgeInsets.symmetric(vertical: 100.0, horizontal: 32.0),
    //   child: Material(
    //     borderRadius: BorderRadius.circular(12.0),
    //     child: Padding(
    //       padding: const EdgeInsets.all(12.0),
    //       child: Column(
    //         children: [
    //           // content or idk
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }

  static Future<T?> show<T>(
    GradeSubject subject, {
    required BuildContext context,
  }) async {
    UserProvider user = Provider.of<UserProvider>(context, listen: false);
    DatabaseProvider db = Provider.of<DatabaseProvider>(context, listen: false);

    var goalAvgRes = await db.userQuery.subjectGoalAverages(userId: user.id!);
    var beforeAvgRes = await db.userQuery.subjectGoalBefores(userId: user.id!);

    //DateTime goalPinDate = DateTime.parse((await db.userQuery.subjectGoalPinDates(userId: user.id!))[widget.subject.id]!);

    String? goalAvgStr = goalAvgRes[subject.id];
    String? beforeAvgStr = beforeAvgRes[subject.id];
    double goalAvg = double.parse(goalAvgStr ?? '0.0');
    double beforeAvg = double.parse(beforeAvgStr ?? '0.0');

    double avgDifference = ((goalAvg - beforeAvg) / beforeAvg.abs()) * 100;

    return showDialog<T?>(
      context: context,
      builder: (context) => GoalCompleteModal(
        subject,
        user: user,
        database: db,
        goalAverage: goalAvg,
        beforeAverage: beforeAvg,
        averageDifference: avgDifference,
      ),
      barrierDismissible: false,
    );
  }
}
