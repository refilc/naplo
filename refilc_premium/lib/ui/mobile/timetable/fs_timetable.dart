import 'package:refilc/helpers/subject.dart';
import 'package:refilc/theme/colors/colors.dart';
import 'package:refilc_kreta_api/controllers/timetable_controller.dart';
import 'package:refilc_mobile_ui/common/empty.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:refilc/utils/format.dart';
import 'dart:math' as math;
import 'package:intl/intl.dart';
import 'package:i18n_extension/i18n_widget.dart';

class PremiumFSTimetable extends StatefulWidget {
  const PremiumFSTimetable({Key? key, required this.controller})
      : super(key: key);

  final TimetableController controller;

  @override
  State<PremiumFSTimetable> createState() => _PremiumFSTimetableState();
}

class _PremiumFSTimetableState extends State<PremiumFSTimetable> {
  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ));
  }

  @override
  Widget build(BuildContext context) {
    if (widget.controller.days == null || widget.controller.days!.isEmpty) {
      return const Center(child: Empty());
    }

    final days = widget.controller.days!;
    final everyLesson = days.expand((x) => x).toList();
    everyLesson.sort((a, b) => a.start.compareTo(b.start));

    final int maxLessonCount = days.fold(
        0,
        (a, b) => math.max(
            a, b.where((l) => l.subject.id != "" || l.isEmpty).length));

    const prefixw = 40;
    const padding = prefixw + 6 * 2;
    final colw = (MediaQuery.of(context).size.width - padding) / days.length;

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
        leading: BackButton(color: AppColors.of(context).text),
        shadowColor: Colors.transparent,
      ),
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 24.0),
        itemCount: maxLessonCount + 1,
        itemBuilder: (context, index) {
          List<Widget> columns = [];
          for (int dayIndex = -1; dayIndex < days.length; dayIndex++) {
            if (dayIndex == -1) {
              if (index >= 1) {
                columns.add(SizedBox(
                  width: prefixw.toDouble(),
                  height: 40.0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      (index).toString() + ".",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                  ),
                ));
              } else {
                columns.add(SizedBox(width: prefixw.toDouble()));
              }
              continue;
            }

            final lessons = days[dayIndex]
                .where((l) => l.subject.id != "" || l.isEmpty)
                .toList();

            if (lessons.isEmpty) continue;

            final dayOffset = int.tryParse(lessons.first.lessonIndex) ?? 0;

            if (index == 0 && dayIndex >= 0) {
              columns.add(
                SizedBox(
                  width: colw,
                  height: 40.0,
                  child: Text(
                    DateFormat("EEEE", I18n.of(context).locale.languageCode)
                        .format(lessons.first.date)
                        .capital(),
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
              continue;
            }

            final lessonIndex = index - dayOffset;

            if (lessonIndex < 0 || lessonIndex >= lessons.length) {
              columns.add(SizedBox(width: colw));
              continue;
            }

            if (lessons[lessonIndex].isEmpty) {
              columns.add(
                SizedBox(
                  width: colw,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        FeatherIcons.slash,
                        size: 18.0,
                        color: AppColors.of(context).text.withOpacity(.3),
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        "Lyukas óra",
                        style: TextStyle(
                          color: AppColors.of(context).text.withOpacity(.3),
                        ),
                      ),
                    ],
                  ),
                ),
              );
              continue;
            }

            columns.add(
              SizedBox(
                width: colw,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          SubjectIcon.resolveVariant(
                            context: context,
                            subject: lessons[lessonIndex].subject,
                          ),
                          size: 18.0,
                          color: AppColors.of(context).text.withOpacity(.7),
                        ),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: Text(
                            lessons[lessonIndex].subject.renamedTo ??
                                lessons[lessonIndex].subject.name.capital(),
                            maxLines: 1,
                            style: TextStyle(
                              fontStyle: lessons[lessonIndex].subject.isRenamed
                                  ? FontStyle.italic
                                  : null,
                            ),
                            overflow: TextOverflow.clip,
                            softWrap: false,
                          ),
                        ),
                        const SizedBox(width: 15),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 26.0),
                      child: Text(
                        lessons[lessonIndex].room,
                        style: TextStyle(
                          color: AppColors.of(context).text.withOpacity(.5),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: columns,
          );
        },
      ),
    );
  }
}
