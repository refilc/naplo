// import 'package:filcnaplo/api/providers/database_provider.dart';
// import 'package:filcnaplo/api/providers/user_provider.dart';
// import 'package:filcnaplo_kreta_api/models/subject.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class GoalCompleteModal extends StatelessWidget {
//   const GoalCompleteModal(
//     this.subject, {
//     Key? key,
//     required this.user,
//     required this.database,
//     required this.goalAverage,
//     required this.beforeAverage,
//     required this.averageDifference,
//   }) : super(key: key);

//   final UserProvider user;
//   final DatabaseProvider database;
//   final Subject subject;

//   final double goalAverage;
//   final double beforeAverage;
//   final double averageDifference;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 100.0, horizontal: 32.0),
//       child: Material(
//         borderRadius: BorderRadius.circular(12.0),
//         child: Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: Column(
//             children: [
//               // content or idk
//               Container(
//                 decoration: const BoxDecoration(
//                   image: DecorationImage(
//                     image: AssetImage('assets/images/static_confetti.png'),
//                     fit: BoxFit.fill,
//                     alignment: Alignment.topCenter,
//                   ),
//                 ),
//                 child: Text(
//                   goalAverage.toStringAsFixed(1),
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 40.0,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   static Future<T?> show<T>(
//     Subject subject, {
//     required BuildContext context,
//   }) async {
//     UserProvider user = Provider.of<UserProvider>(context, listen: false);
//     DatabaseProvider db = Provider.of<DatabaseProvider>(context, listen: false);

//     var goalAvgRes = await db.userQuery.subjectGoalAverages(userId: user.id!);
//     var beforeAvgRes = await db.userQuery.subjectGoalBefores(userId: user.id!);

//     //DateTime goalPinDate = DateTime.parse((await db.userQuery.subjectGoalPinDates(userId: user.id!))[widget.subject.id]!);

//     String? goalAvgStr = goalAvgRes[subject.id];
//     String? beforeAvgStr = beforeAvgRes[subject.id];
//     double goalAvg = double.parse(goalAvgStr ?? '0.0');
//     double beforeAvg = double.parse(beforeAvgStr ?? '0.0');

//     double avgDifference = ((goalAvg - beforeAvg) / beforeAvg.abs()) * 100;

//     return showDialog<T?>(
//       context: context,
//       builder: (context) => GoalCompleteModal(
//         subject,
//         user: user,
//         database: db,
//         goalAverage: goalAvg,
//         beforeAverage: beforeAvg,
//         averageDifference: avgDifference,
//       ),
//       barrierDismissible: false,
//     );
//   }
// }
