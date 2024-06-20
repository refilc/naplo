import 'dart:math';

import 'package:refilc/helpers/average_helper.dart';
import 'package:refilc/models/settings.dart';
import 'package:refilc/theme/colors/colors.dart';
import 'package:refilc_kreta_api/models/grade.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:i18n_extension/i18n_extension.dart';
import 'package:provider/provider.dart';
import 'graph.i18n.dart';

class GradeGraph extends StatefulWidget {
  const GradeGraph(this.data,
      {super.key, this.dayThreshold = 7, this.classAvg});

  final List<Grade> data;
  final int dayThreshold;
  final double? classAvg;

  @override
  GradeGraphState createState() => GradeGraphState();
}

class GradeGraphState extends State<GradeGraph> {
  late SettingsProvider settings;

  List<Color> getColors(List<Grade> data) {
    List<Color> colors = [];
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

      Color clr = average >= 1 && average <= 5
          ? ColorTween(
                  begin: settings.gradeColors[average.floor() - 1],
                  end: settings.gradeColors[average.ceil() - 1])
              .transform(average - average.floor())!
          : Theme.of(context).colorScheme.secondary;

      colors.add(clr);
    }

    return colors;
  }

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

    // color magic happens here
    List<Color> averageColors = getColors(data);

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

    Grade halfYearGrade = widget.data.lastWhere(
        (e) => e.type == GradeType.halfYear,
        orElse: () => Grade.fromJson({}));

    if (halfYearGrade.date.year != 0 && data.isNotEmpty) {
      final maxX = ghostSpots.isNotEmpty ? ghostSpots.first.x : 0;
      final x = halfYearGrade.writeDate.month +
          (halfYearGrade.writeDate.day / 31) +
          ((halfYearGrade.writeDate.year - data.last.writeDate.year) * 12);

      List<Grade> dataBeforeMidYr = data
          .where((e) => e.writeDate.isBefore(halfYearGrade.writeDate))
          .toList();

      if (x <= maxX) {
        extraLinesV.add(
          VerticalLine(
            x: x,
            strokeWidth: 3.0,
            color: AppColors.of(context).red.withOpacity(.75),
            label: VerticalLineLabel(
              labelResolver: (_) => " ${"mid".i18n} ​", // <- zwsp for padding
              show: true,
              alignment: dataBeforeMidYr.length < 2
                  ? Alignment.topRight
                  : Alignment.topLeft,
              style: TextStyle(
                backgroundColor: Theme.of(context).colorScheme.surface,
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
              height: 158,
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
                              preventCurveOverShooting: false,
                              spots: subjectSpots,
                              isCurved: true,
                              // colors: averageColors.reversed.toList(),
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: averageColors.reversed.toList(),
                              ),
                              barWidth: 6,
                              curveSmoothness: 0.2,
                              isStrokeCapRound: true,
                              dotData: const FlDotData(show: false),
                              belowBarData: BarAreaData(
                                show: true,
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    averageColor.withOpacity(0.7),
                                    averageColor.withOpacity(0.3),
                                    averageColor.withOpacity(0.2),
                                    averageColor.withOpacity(0.1),
                                  ],
                                  stops: const [0.1, 0.6, 0.8, 1],
                                ),
                                // gradientColorStops: [0.1, 0.6, 0.8, 1],
                                // gradientFrom: const Offset(0, 0),
                                // gradientTo: const Offset(0, 1),
                              ),
                            ),
                            if (ghostData.isNotEmpty && ghostSpots.isNotEmpty)
                              LineChartBarData(
                                preventCurveOverShooting: false,
                                spots: ghostSpots,
                                isCurved: true,
                                color: AppColors.of(context).text,
                                barWidth: 6,
                                curveSmoothness: 0.2,
                                isStrokeCapRound: true,
                                dotData: const FlDotData(show: false),
                                belowBarData: BarAreaData(
                                  show: true,
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      AppColors.of(context)
                                          .text
                                          .withOpacity(0.7),
                                      AppColors.of(context)
                                          .text
                                          .withOpacity(0.3),
                                      AppColors.of(context)
                                          .text
                                          .withOpacity(0.2),
                                      AppColors.of(context)
                                          .text
                                          .withOpacity(0.1),
                                    ],
                                    stops: const [0.1, 0.6, 0.8, 1],
                                  ),
                                  // gradientColorStops: [0.1, 0.6, 0.8, 1],
                                  // gradientFrom: const Offset(0, 0),
                                  // gradientTo: const Offset(0, 1),
                                ),
                              ),
                          ],
                          minY: 1,
                          maxY: 5,
                          gridData: const FlGridData(
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
                            touchTooltipData: const LineTouchTooltipData(
                              // tooltipBgColor: Colors.grey.shade800,
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
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 24,
                                getTitlesWidget: (value, meta) {
                                  if (value == meta.max || value == meta.min) {
                                    return Container();
                                  }

                                  var format = DateFormat("MMM",
                                      I18n.of(context).locale.toString());

                                  String title = format
                                      .format(DateTime(0, value.floor() % 12))
                                      .replaceAll(".", "");
                                  title =
                                      title.substring(0, min(title.length, 4));

                                  return Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(
                                      title.toUpperCase(),
                                      style: TextStyle(
                                        color: AppColors.of(context)
                                            .text
                                            .withOpacity(.75),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  );
                                },
                                // getTextStyles: (context, value) => TextStyle(
                                //   color: AppColors.of(context)
                                //       .text
                                //       .withOpacity(.75),
                                //   fontWeight: FontWeight.bold,
                                //   fontSize: 14.0,
                                // ),
                                // margin: 12.0,
                                // getTitles: (value) {
                                //   var format = DateFormat("MMM",
                                //       I18n.of(context).locale.toString());

                                //   String title = format
                                //       .format(DateTime(0, value.floor() % 12))
                                //       .replaceAll(".", "");
                                //   title =
                                //       title.substring(0, min(title.length, 4));

                                //   return title.toUpperCase();
                                // },
                                interval: () {
                                  List<Grade> tData =
                                      ghostData.isNotEmpty ? ghostData : data;
                                  tData.sort((a, b) =>
                                      a.writeDate.compareTo(b.writeDate));
                                  return ghostData.isNotEmpty
                                      ? 3.0
                                      : tData.first.writeDate
                                              .add(const Duration(days: 120))
                                              .isBefore(tData.last.writeDate)
                                          ? 2.0
                                          : 2.5;
                                }(),
                                // checkToShowTitle: (double minValue,
                                //     double maxValue,
                                //     SideTitles sideTitles,
                                //     double appliedInterval,
                                //     double value) {
                                //   if (value == maxValue || value == minValue) {
                                //     return false;
                                //   }
                                //   return true;
                                // },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 1.0,
                                getTitlesWidget: (value, meta) => Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    value.toInt().toString(),
                                    style: TextStyle(
                                      color: AppColors.of(context).text,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                // getTextStyles: (context, value) => TextStyle(
                                //   color: AppColors.of(context).text,
                                //   fontWeight: FontWeight.bold,
                                //   fontSize: 18.0,
                                // ),
                                // margin: 16,
                              ),
                            ),
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                        ),
                      ),
                    )
                  : null,
            ),
          );
  }
}
