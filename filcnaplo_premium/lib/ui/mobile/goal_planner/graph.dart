import 'dart:math';

import 'package:filcnaplo/helpers/average_helper.dart';
import 'package:filcnaplo/models/settings.dart';
import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:filcnaplo_kreta_api/models/grade.dart';
import 'package:filcnaplo_premium/ui/mobile/goal_planner/graph.i18n.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

class GoalGraph extends StatefulWidget {
  const GoalGraph(this.data, {Key? key, this.dayThreshold = 7, this.classAvg})
      : super(key: key);

  final List<Grade> data;
  final int dayThreshold;
  final double? classAvg;

  @override
  _GoalGraphState createState() => _GoalGraphState();
}

class _GoalGraphState extends State<GoalGraph> {
  late SettingsProvider settings;

  List<FlSpot> getSpots(List<Grade> data) {
    List<FlSpot> subjectData = [];
    List<List<Grade>> sortedData = [[]];

    // Sort by date descending
    data.sort((a, b) => -a.writeDate.compareTo(b.writeDate));

    // Sort data to points by treshold
    for (var element in data) {
      if (sortedData.last.isNotEmpty &&
          sortedData.last.last.writeDate.difference(element.writeDate).inDays >
              widget.dayThreshold) {
        sortedData.add([]);
      }
      for (var dataList in sortedData) {
        dataList.add(element);
      }
    }

    // Create FlSpots from points
    for (var dataList in sortedData) {
      double average = AverageHelper.averageEvals(dataList);

      if (dataList.isNotEmpty) {
        subjectData.add(FlSpot(
          dataList[0].writeDate.month +
              (dataList[0].writeDate.day / 31) +
              ((dataList[0].writeDate.year - data.last.writeDate.year) * 12),
          double.parse(average.toStringAsFixed(2)),
        ));
      }
    }

    return subjectData;
  }

  @override
  Widget build(BuildContext context) {
    settings = Provider.of<SettingsProvider>(context);

    List<FlSpot> subjectSpots = [];
    List<FlSpot> ghostSpots = [];
    List<VerticalLine> extraLinesV = [];
    List<HorizontalLine> extraLinesH = [];

    // Filter data
    List<Grade> data = widget.data
        .where((e) => e.value.weight != 0)
        .where((e) => e.type == GradeType.midYear)
        .where((e) => e.gradeType?.name == "Osztalyzat")
        .toList();

    // Filter ghost data
    List<Grade> ghostData = widget.data
        .where((e) => e.value.weight != 0)
        .where((e) => e.type == GradeType.ghost)
        .toList();

    // Calculate average
    double average = AverageHelper.averageEvals(data);

    // Calculate graph color
    Color averageColor = average >= 1 && average <= 5
        ? ColorTween(
                begin: settings.gradeColors[average.floor() - 1],
                end: settings.gradeColors[average.ceil() - 1])
            .transform(average - average.floor())!
        : Theme.of(context).colorScheme.secondary;

    subjectSpots = getSpots(data);

    // naplo/#73
    if (subjectSpots.isNotEmpty) {
      ghostSpots = getSpots(data + ghostData);

      // hax
      ghostSpots = ghostSpots
          .where((e) => e.x >= subjectSpots.map((f) => f.x).reduce(max))
          .toList();
      ghostSpots = ghostSpots.map((e) => FlSpot(e.x + 0.1, e.y)).toList();
      ghostSpots.add(subjectSpots.firstWhere(
          (e) => e.x >= subjectSpots.map((f) => f.x).reduce(max),
          orElse: () => const FlSpot(-1, -1)));
      ghostSpots.removeWhere(
          (element) => element.x == -1 && element.y == -1); // naplo/#74
    }

    // Horizontal line displaying the class average
    if (widget.classAvg != null &&
        widget.classAvg! > 0.0 &&
        settings.graphClassAvg) {
      extraLinesH.add(HorizontalLine(
        y: widget.classAvg!,
        color: AppColors.of(context).text.withOpacity(.75),
      ));
    }

    // LineChart is really cute because it tries to render it's contents outside of it's rect.
    return widget.data.length <= 2
        ? SizedBox(
            height: 150,
            child: Center(
              child: Text(
                "not_enough_grades".i18n,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          )
        : ClipRect(
            child: SizedBox(
              child: subjectSpots.length > 1
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8.0, right: 8.0),
                      child: LineChart(
                        LineChartData(
                          extraLinesData: ExtraLinesData(
                              verticalLines: extraLinesV,
                              horizontalLines: extraLinesH),
                          lineBarsData: [
                            LineChartBarData(
                              preventCurveOverShooting: true,
                              spots: subjectSpots,
                              isCurved: true,
                              colors: [averageColor],
                              barWidth: 8,
                              isStrokeCapRound: true,
                              dotData: FlDotData(show: false),
                              belowBarData: BarAreaData(
                                show: true,
                                colors: [
                                  averageColor.withOpacity(0.7),
                                  averageColor.withOpacity(0.3),
                                  averageColor.withOpacity(0.2),
                                  averageColor.withOpacity(0.1),
                                ],
                                gradientColorStops: [0.1, 0.6, 0.8, 1],
                                gradientFrom: const Offset(0, 0),
                                gradientTo: const Offset(0, 1),
                              ),
                            ),
                            if (ghostData.isNotEmpty && ghostSpots.isNotEmpty)
                              LineChartBarData(
                                preventCurveOverShooting: true,
                                spots: ghostSpots,
                                isCurved: true,
                                colors: [AppColors.of(context).text],
                                barWidth: 8,
                                isStrokeCapRound: true,
                                dotData: FlDotData(show: false),
                                belowBarData: BarAreaData(
                                  show: true,
                                  colors: [
                                    AppColors.of(context).text.withOpacity(0.7),
                                    AppColors.of(context).text.withOpacity(0.3),
                                    AppColors.of(context).text.withOpacity(0.2),
                                    AppColors.of(context).text.withOpacity(0.1),
                                  ],
                                  gradientColorStops: [0.1, 0.6, 0.8, 1],
                                  gradientFrom: const Offset(0, 0),
                                  gradientTo: const Offset(0, 1),
                                ),
                              ),
                          ],
                          minY: 1,
                          maxY: 5,
                          gridData: FlGridData(
                            show: true,
                            horizontalInterval: 1,
                            // checkToShowVerticalLine: (_) => false,
                            // getDrawingHorizontalLine: (_) => FlLine(
                            //   color: AppColors.of(context).text.withOpacity(.15),
                            //   strokeWidth: 2,
                            // ),
                            // getDrawingVerticalLine: (_) => FlLine(
                            //   color: AppColors.of(context).text.withOpacity(.25),
                            //   strokeWidth: 2,
                            // ),
                          ),
                          lineTouchData: LineTouchData(
                            touchTooltipData: LineTouchTooltipData(
                              tooltipBgColor: Colors.grey.shade800,
                              fitInsideVertically: true,
                              fitInsideHorizontally: true,
                            ),
                            handleBuiltInTouches: true,
                            touchSpotThreshold: 20.0,
                            getTouchedSpotIndicator: (_, spots) {
                              return List.generate(
                                spots.length,
                                (index) => TouchedSpotIndicatorData(
                                  FlLine(
                                    color: Colors.grey.shade900,
                                    strokeWidth: 3.5,
                                  ),
                                  FlDotData(
                                    getDotPainter: (a, b, c, d) =>
                                        FlDotCirclePainter(
                                      strokeWidth: 0,
                                      color: Colors.grey.shade900,
                                      radius: 10.0,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          borderData: FlBorderData(
                            show: false,
                            border: Border.all(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              width: 4,
                            ),
                          ),
                        ),
                      ),
                    )
                  : null,
              height: 158,
            ),
          );
  }
}
