import 'dart:math';

import 'package:filcnaplo/helpers/average_helper.dart';
import 'package:filcnaplo/models/settings.dart';
import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:filcnaplo_kreta_api/models/grade.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:provider/provider.dart';
import 'graph.i18n.dart';

class GradeGraph extends StatefulWidget {
  const GradeGraph(this.data, {Key? key, this.dayThreshold = 7, this.classAvg}) : super(key: key);

  final List<Grade> data;
  final int dayThreshold;
  final double? classAvg;

  @override
  _GradeGraphState createState() => _GradeGraphState();
}

class _GradeGraphState extends State<GradeGraph> {
  late SettingsProvider settings;

  List<FlSpot> getSpots(List<Grade> data) {
    List<FlSpot> subjectData = [];
    List<List<Grade>> sortedData = [[]];

    // Sort by date descending
    data.sort((a, b) => -a.writeDate.compareTo(b.writeDate));

    // Sort data to points by treshold
    for (var element in data) {
      if (sortedData.last.isNotEmpty && sortedData.last.last.writeDate.difference(element.writeDate).inDays > widget.dayThreshold) {
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
          dataList[0].writeDate.month + (dataList[0].writeDate.day / 31) + ((dataList[0].writeDate.year - data.last.writeDate.year) * 12),
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
    List<Grade> ghostData = widget.data.where((e) => e.value.weight != 0).where((e) => e.type == GradeType.ghost).toList();

    // Calculate average
    double average = AverageHelper.averageEvals(data);

    // Calculate graph color
    Color averageColor = average >= 1 && average <= 5
        ? ColorTween(begin: settings.gradeColors[average.floor() - 1], end: settings.gradeColors[average.ceil() - 1])
            .transform(average - average.floor())!
        : Theme.of(context).colorScheme.secondary;

    subjectSpots = getSpots(data);

    // naplo/#73
    if (subjectSpots.isNotEmpty) {
      ghostSpots = getSpots(data + ghostData);

      // hax
      ghostSpots = ghostSpots.where((e) => e.x >= subjectSpots.map((f) => f.x).reduce(max)).toList();
      ghostSpots = ghostSpots.map((e) => FlSpot(e.x + 0.1, e.y)).toList();
      ghostSpots.add(subjectSpots.firstWhere((e) => e.x >= subjectSpots.map((f) => f.x).reduce(max), orElse: () => const FlSpot(-1, -1)));
      ghostSpots.removeWhere((element) => element.x == -1 && element.y == -1); // naplo/#74
    }

    Grade halfYearGrade = widget.data.lastWhere((e) => e.type == GradeType.halfYear, orElse: () => Grade.fromJson({}));

    if (halfYearGrade.date.year != 0 && data.isNotEmpty) {
      final maxX = ghostSpots.isNotEmpty ? ghostSpots.first.x : 0;
      final x = halfYearGrade.writeDate.month + (halfYearGrade.writeDate.day / 31) + ((halfYearGrade.writeDate.year - data.last.writeDate.year) * 12);
      if (x <= maxX) {
        extraLinesV.add(
          VerticalLine(
            x: x,
            strokeWidth: 3.0,
            color: AppColors.of(context).red.withOpacity(.75),
            label: VerticalLineLabel(
              labelResolver: (_) => " " + "mid".i18n + " ​", // <- zwsp for padding
              show: true,
              alignment: Alignment.topLeft,
              style: TextStyle(
                backgroundColor: Theme.of(context).colorScheme.background,
                color: AppColors.of(context).text,
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      }
    }

    // Horizontal line displaying the class average
    if (widget.classAvg != null && widget.classAvg! > 0.0 && settings.graphClassAvg) {
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
                          extraLinesData: ExtraLinesData(verticalLines: extraLinesV, horizontalLines: extraLinesH),
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
                                    getDotPainter: (a, b, c, d) => FlDotCirclePainter(
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
                          titlesData: FlTitlesData(
                            bottomTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 24,
                              getTextStyles: (context, value) => TextStyle(
                                color: AppColors.of(context).text.withOpacity(.75),
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                              ),
                              margin: 12.0,
                              getTitles: (value) {
                                var format = DateFormat("MMM", I18n.of(context).locale.toString());

                                String title = format.format(DateTime(0, value.floor() % 12)).replaceAll(".", "");
                                title = title.substring(0, min(title.length, 4));

                                return title.toUpperCase();
                              },
                              interval: () {
                                List<Grade> tData = ghostData.isNotEmpty ? ghostData : data;
                                tData.sort((a, b) => a.writeDate.compareTo(b.writeDate));
                                return tData.first.writeDate.add(const Duration(days: 120)).isBefore(tData.last.writeDate) ? 2.0 : 1.0;
                              }(),
                            ),
                            leftTitles: SideTitles(
                              showTitles: true,
                              interval: 1.0,
                              getTextStyles: (context, value) => TextStyle(
                                color: AppColors.of(context).text,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                              margin: 16,
                            ),
                            rightTitles: SideTitles(showTitles: false),
                            topTitles: SideTitles(showTitles: false),
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
