import 'dart:math';

import 'package:animations/animations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:filcnaplo/api/providers/update_provider.dart';
import 'package:filcnaplo/ui/date_widget.dart';
import 'package:filcnaplo_kreta_api/models/absence.dart';
import 'package:filcnaplo_kreta_api/models/lesson.dart';
import 'package:filcnaplo_kreta_api/models/subject.dart';
import 'package:filcnaplo_kreta_api/models/week.dart';
import 'package:filcnaplo_kreta_api/providers/absence_provider.dart';
import 'package:filcnaplo_kreta_api/providers/note_provider.dart';
import 'package:filcnaplo/api/providers/user_provider.dart';
import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:filcnaplo_kreta_api/providers/timetable_provider.dart';
import 'package:filcnaplo_mobile_ui/common/action_button.dart';
import 'package:filcnaplo_mobile_ui/common/empty.dart';
import 'package:filcnaplo_mobile_ui/common/filter_bar.dart';
import 'package:filcnaplo_mobile_ui/common/panel/panel.dart';
import 'package:filcnaplo_mobile_ui/common/profile_image/profile_button.dart';
import 'package:filcnaplo_mobile_ui/common/profile_image/profile_image.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/absence/absence_subject_tile.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/absence/absence_viewable.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/statistics_tile.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/miss_tile.dart';
import 'package:filcnaplo_mobile_ui/pages/absences/absence_subject_view.dart';
import 'package:filcnaplo/ui/filter/sort.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:filcnaplo/utils/color.dart';
import 'absences_page.i18n.dart';

enum AbsenceFilter { absences, delays, misses }

class SubjectAbsence {
  Subject subject;
  List<Absence> absences;
  double percentage;

  SubjectAbsence({required this.subject, this.absences = const [], this.percentage = 0.0});
}

class AbsencesPage extends StatefulWidget {
  const AbsencesPage({Key? key}) : super(key: key);

  @override
  _AbsencesPageState createState() => _AbsencesPageState();
}

class _AbsencesPageState extends State<AbsencesPage> with TickerProviderStateMixin {
  late UserProvider user;
  late AbsenceProvider absenceProvider;
  late TimetableProvider timetableProvider;
  late NoteProvider noteProvider;
  late UpdateProvider updateProvider;
  late String firstName;
  late TabController _tabController;
  late List<SubjectAbsence> absences = [];
  final Map<Subject, Lesson> _lessonCount = {};

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this);
    timetableProvider = Provider.of<TimetableProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      for (final lesson in timetableProvider.getWeek(Week.current()) ?? []) {
        if (!lesson.isEmpty && lesson.subject.id != '' && lesson.lessonYearIndex != null) {
          _lessonCount.update(
            lesson.subject,
            (value) {
              if (lesson.lessonYearIndex! > value.lessonYearIndex!) {
                return lesson;
              } else {
                return value;
              }
            },
            ifAbsent: () => lesson,
          );
        }
      }
      setState(() {});
    });
  }

  void buildSubjectAbsences() {
    Map<Subject, SubjectAbsence> _absences = {};

    for (final absence in absenceProvider.absences) {
      if (absence.delay != 0) continue;

      if (!_absences.containsKey(absence.subject)) {
        _absences[absence.subject] = SubjectAbsence(subject: absence.subject, absences: [absence]);
      } else {
        _absences[absence.subject]?.absences.add(absence);
      }
    }

    _absences.forEach((subject, absence) {
      final absentLessonsOfSubject = absenceProvider.absences.where((e) => e.subject == subject && e.delay == 0).length;
      final totalLessonsOfSubject = _lessonCount[subject]?.lessonYearIndex ?? 0;

      double absentLessonsOfSubjectPercentage;

      if (absentLessonsOfSubject <= totalLessonsOfSubject) {
        absentLessonsOfSubjectPercentage = absentLessonsOfSubject / totalLessonsOfSubject * 100;
      } else {
        absentLessonsOfSubjectPercentage = -1;
      }

      _absences[subject]?.percentage = absentLessonsOfSubjectPercentage.clamp(-1, 100.0);
    });

    absences = _absences.values.toList();
    absences.sort((a, b) => -a.percentage.compareTo(b.percentage));
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context);
    absenceProvider = Provider.of<AbsenceProvider>(context);
    noteProvider = Provider.of<NoteProvider>(context);
    updateProvider = Provider.of<UpdateProvider>(context);
    timetableProvider = Provider.of<TimetableProvider>(context);

    List<String> nameParts = user.displayName?.split(" ") ?? ["?"];
    firstName = nameParts.length > 1 ? nameParts[1] : nameParts[0];

    buildSubjectAbsences();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: NestedScrollView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          headerSliverBuilder: (context, _) => [
            SliverAppBar(
              pinned: true,
              floating: false,
              snap: false,
              centerTitle: false,
              surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
              actions: [
                // Profile Icon
                Padding(
                  padding: const EdgeInsets.only(right: 24.0),
                  child: ProfileButton(
                    child: ProfileImage(
                      heroTag: "profile",
                      name: firstName,
                      backgroundColor: ColorUtils.stringToColor(user.displayName ?? "?"),
                      badge: updateProvider.available,
                      role: user.role,
                      profilePictureString: user.picture,
                    ),
                  ),
                ),
              ],
              automaticallyImplyLeading: false,
              shadowColor: Theme.of(context).shadowColor,
              title: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "Absences".i18n,
                  style: TextStyle(color: AppColors.of(context).text, fontSize: 32.0, fontWeight: FontWeight.bold),
                ),
              ),
              bottom: FilterBar(items: [
                Tab(text: "Absences".i18n),
                Tab(text: "Delays".i18n),
                Tab(text: "Misses".i18n),
              ], controller: _tabController, disableFading: true),
            ),
          ],
          body: TabBarView(
              physics: const BouncingScrollPhysics(),
              controller: _tabController,
              children: List.generate(3, (index) => filterViewBuilder(context, index))),
        ),
      ),
    );
  }

  List<DateWidget> getFilterWidgets(AbsenceFilter activeData) {
    List<DateWidget> items = [];
    switch (activeData) {
      case AbsenceFilter.absences:
        for (var a in absences) {
          items.add(DateWidget(
            date: DateTime.fromMillisecondsSinceEpoch(0),
            widget: AbsenceSubjectTile(
              a.subject,
              percentage: a.percentage,
              excused: a.absences.where((a) => a.state == Justification.excused).length,
              unexcused: a.absences.where((a) => a.state == Justification.unexcused).length,
              pending: a.absences.where((a) => a.state == Justification.pending).length,
              onTap: () => AbsenceSubjectView.show(a.subject, a.absences, context: context),
            ),
          ));
        }
        break;
      case AbsenceFilter.delays:
        for (var absence in absenceProvider.absences) {
          if (absence.delay != 0) {
            items.add(DateWidget(
              date: absence.date,
              widget: AbsenceViewable(absence, padding: EdgeInsets.zero),
            ));
          }
        }
        break;
      case AbsenceFilter.misses:
        for (var note in noteProvider.notes) {
          if (note.type?.name == "HaziFeladatHiany" || note.type?.name == "Felszereleshiany") {
            items.add(DateWidget(
              date: note.date,
              widget: MissTile(note),
            ));
          }
        }
        break;
    }
    return items;
  }

  Widget filterViewBuilder(context, int activeData) {
    List<Widget> filterWidgets = [];

    if (activeData > 0) {
      filterWidgets = sortDateWidgets(
        context,
        dateWidgets: getFilterWidgets(AbsenceFilter.values[activeData]),
        padding: EdgeInsets.zero,
        hasShadow: true,
      );
    } else {
      filterWidgets = [
        Padding(
          padding: const EdgeInsets.only(bottom: 24.0),
          child: Panel(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Subjects".i18n),
                Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                          title: Text("attention".i18n),
                          content: Text("attention_body".i18n),
                          actions: [ActionButton(label: "Ok", onTap: () => Navigator.of(context).pop())],
                        ),
                      );
                    },
                    padding: EdgeInsets.zero,
                    splashRadius: 24.0,
                    visualDensity: VisualDensity.compact,
                    constraints: BoxConstraints.tight(const Size(42.0, 42.0)),
                    icon: const Icon(FeatherIcons.info),
                  ),
                ),
              ],
            ),
            child: PageTransitionSwitcher(
              transitionBuilder: (
                Widget child,
                Animation<double> primaryAnimation,
                Animation<double> secondaryAnimation,
              ) {
                return FadeThroughTransition(
                  child: child,
                  animation: primaryAnimation,
                  secondaryAnimation: secondaryAnimation,
                  fillColor: Theme.of(context).colorScheme.background,
                );
              },
              child: Column(
                children: getFilterWidgets(AbsenceFilter.values[activeData]).map((e) => e.widget).cast<Widget>().toList(),
              ),
            ),
          ),
        )
      ];
    }

    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: RefreshIndicator(
        color: Theme.of(context).colorScheme.secondary,
        onRefresh: () async {
          await absenceProvider.fetch();
          await noteProvider.fetch();
        },
        child: ListView.builder(
          padding: EdgeInsets.zero,
          physics: const BouncingScrollPhysics(),
          itemCount: max(filterWidgets.length + (activeData <= 1 ? 1 : 0), 1),
          itemBuilder: (context, index) {
            if (filterWidgets.isNotEmpty) {
              if ((index == 0 && activeData == 1) || (index == 0 && activeData == 0)) {
                int value1 = 0;
                int value2 = 0;
                String title1 = "";
                String title2 = "";
                String suffix = "";

                if (activeData == AbsenceFilter.absences.index) {
                  value1 = absenceProvider.absences.where((e) => e.delay == 0 && e.state == Justification.excused).length;
                  value2 = absenceProvider.absences.where((e) => e.delay == 0 && e.state == Justification.unexcused).length;
                  title1 = "stat_1".i18n;
                  title2 = "stat_2".i18n;
                  suffix = " " + "hr".i18n;
                } else if (activeData == AbsenceFilter.delays.index) {
                  value1 = absenceProvider.absences
                      .where((e) => e.delay != 0 && e.state == Justification.excused)
                      .map((e) => e.delay)
                      .fold(0, (a, b) => a + b);
                  value2 = absenceProvider.absences
                      .where((e) => e.delay != 0 && e.state == Justification.unexcused)
                      .map((e) => e.delay)
                      .fold(0, (a, b) => a + b);
                  title1 = "stat_3".i18n;
                  title2 = "stat_4".i18n;
                  suffix = " " + "min".i18n;
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 24.0, left: 24.0, right: 24.0),
                  child: Row(children: [
                    Expanded(
                      child: StatisticsTile(
                        title: AutoSizeText(
                          title1,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        valueSuffix: suffix,
                        value: value1.toDouble(),
                        decimal: false,
                        color: AppColors.of(context).green,
                      ),
                    ),
                    const SizedBox(width: 24.0),
                    Expanded(
                      child: StatisticsTile(
                        title: AutoSizeText(
                          title2,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        valueSuffix: suffix,
                        value: value2.toDouble(),
                        decimal: false,
                        color: AppColors.of(context).red,
                      ),
                    ),
                  ]),
                );
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 6.0),
                child: filterWidgets[index - (activeData <= 1 ? 1 : 0)],
              );
            } else {
              return Empty(subtitle: "empty".i18n);
            }
          },
        ),
      ),
    );
  }
}
