import 'dart:math';
import 'package:animations/animations.dart';
import 'package:filcnaplo/api/providers/update_provider.dart';
import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:filcnaplo_kreta_api/client/client.dart';
import 'package:filcnaplo_kreta_api/models/week.dart';
import 'package:filcnaplo_kreta_api/providers/timetable_provider.dart';
import 'package:filcnaplo/api/providers/user_provider.dart';
import 'package:filcnaplo_kreta_api/models/lesson.dart';
import 'package:filcnaplo_mobile_ui/common/empty.dart';
import 'package:filcnaplo_mobile_ui/common/panel/panel.dart';
import 'package:filcnaplo_kreta_api/controllers/timetable_controller.dart';
import 'package:filcnaplo_desktop_ui/common/widgets/lesson/lesson_viewable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:intl/intl.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'timetable_page.i18n.dart';

// todo: "fix" overflow (priority: -1)

class TimetablePage extends StatefulWidget {
  const TimetablePage({Key? key, this.initialDay, this.initialWeek}) : super(key: key);

  final DateTime? initialDay;
  final Week? initialWeek;

  static void jump(BuildContext context, {Week? week, DateTime? day, Lesson? lesson}) {
    // Go to timetable page with arguments
    // NavigationScreen.of(context)?.customRoute(navigationPageRoute((context) => TimetablePage(
    //       initialDay: lesson?.date ?? day,
    //       initialWeek: lesson?.date != null
    //           ? Week.fromDate(lesson!.date)
    //           : day != null
    //               ? Week.fromDate(day)
    //               : week,
    //     )));

    // NavigationScreen.of(context)?.setPage("timetable");

    // Show initial Lesson
    // if (lesson != null) LessonView.show(lesson, context: context);
  }

  @override
  _TimetablePageState createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> with TickerProviderStateMixin {
  late UserProvider user;
  late TimetableProvider timetableProvider;
  late UpdateProvider updateProvider;
  late String firstName;
  late TimetableController _controller;
  late TabController _tabController;
  late Widget empty;

  int _getDayIndex(DateTime date) {
    int index = 0;
    if (_controller.days == null || (_controller.days?.isEmpty ?? true)) return index;

    // find the first day with upcoming lessons
    index = _controller.days!.indexWhere((day) => day.last.end.isAfter(date));
    if (index == -1) index = 0; // fallback

    return index;
  }

  // Update timetable on user change
  Future<void> _userListener() async {
    await Provider.of<KretaClient>(context, listen: false).refreshLogin();
    if (mounted) _controller.jump(_controller.currentWeek, context: context);
  }

  @override
  void initState() {
    super.initState();

    // Initalize controllers
    _controller = TimetableController();
    _tabController = TabController(length: 0, vsync: this, initialIndex: 0);

    empty = Empty(subtitle: "empty".i18n);

    bool initial = true;

    // Only update the TabController on week changes
    _controller.addListener(() {
      if (_controller.days == null) return;
      setState(() {
        _tabController = TabController(
          length: _controller.days!.length,
          vsync: this,
          initialIndex: min(_tabController.index, max(_controller.days!.length - 1, 0)),
        );

        if (initial || _controller.previousWeekId != _controller.currentWeekId) {
          _tabController.animateTo(_getDayIndex(widget.initialDay ?? DateTime.now()));
        }
        initial = false;

        // Empty is updated once every week change
        empty = Empty(subtitle: "empty".i18n);
      });
    });

    if (mounted) {
      if (widget.initialWeek != null) {
        _controller.jump(widget.initialWeek!, context: context, initial: true);
      } else {
        _controller.jump(_controller.currentWeek, context: context, initial: true, skip: true);
      }
    }
    // Listen for user changes
    user = Provider.of<UserProvider>(context, listen: false);
    user.addListener(_userListener);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _controller.dispose();
    user.removeListener(_userListener);
    super.dispose();
  }

  String dayTitle(int index) {
    // Sometimes when changing weeks really fast,
    // controller.days might be null or won't include index
    try {
      return DateFormat("EEEE", I18n.of(context).locale.languageCode).format(_controller.days![index].first.date);
    } catch (e) {
      return "timetable".i18n;
    }
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context);
    timetableProvider = Provider.of<TimetableProvider>(context);
    updateProvider = Provider.of<UpdateProvider>(context);

    // First name
    List<String> nameParts = user.name?.split(" ") ?? ["?"];
    firstName = nameParts.length > 1 ? nameParts[1] : nameParts[0];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 18.0),
        child: Column(
          children: [
            Expanded(
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
                    fillColor: Theme.of(context).scaffoldBackgroundColor,
                  );
                },
                child: _controller.days != null
                    ?
                    // Week view
                    _tabController.length > 0
                        ? CupertinoScrollbar(
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _controller.days!.length,
                              itemBuilder: (context, tab) => SizedBox(
                                width: 400,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Day Title
                                    Padding(
                                      padding: const EdgeInsets.only(left: 24.0, right: 28.0, top: 18.0, bottom: 8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            dayTitle(tab).capital(),
                                            style: const TextStyle(
                                              fontSize: 32.0,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            "${_controller.days![tab].first.date.day}".padLeft(2, '0') + ".",
                                            style: TextStyle(
                                              color: AppColors.of(context).text.withOpacity(.5),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Lessons
                                    Expanded(
                                      child: ListView.builder(
                                        padding: EdgeInsets.zero,
                                        physics: const BouncingScrollPhysics(),
                                        itemCount: _controller.days![tab].length + 2,
                                        itemBuilder: (context, index) {
                                          if (_controller.days == null) return Container();

                                          // Header
                                          if (index == 0) {
                                            return const Padding(
                                              padding: EdgeInsets.only(top: 8.0, left: 24.0, right: 24.0),
                                              child: PanelHeader(padding: EdgeInsets.only(top: 12.0)),
                                            );
                                          }

                                          // Footer
                                          if (index == _controller.days![tab].length + 1) {
                                            return const Padding(
                                              padding: EdgeInsets.only(bottom: 8.0, left: 24.0, right: 24.0),
                                              child: PanelFooter(padding: EdgeInsets.only(top: 12.0)),
                                            );
                                          }

                                          // Body
                                          final Lesson lesson = _controller.days![tab][index - 1];
                                          final bool swapDescDay = _controller.days![tab].map((l) => l.swapDesc ? 1 : 0).reduce((a, b) => a + b) >=
                                              _controller.days![tab].length * .5;

                                          return Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                            child: PanelBody(
                                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                              child: LessonViewable(
                                                lesson,
                                                swapDesc: swapDescDay,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )

                        // Empty week
                        : Expanded(
                            child: Center(child: empty),
                          )
                    : Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Previous week
                  IconButton(
                      onPressed: _controller.currentWeekId == 0
                          ? null
                          : () => setState(() {
                                _controller.previous(context);
                              }),
                      splashRadius: 24.0,
                      icon: const Icon(FeatherIcons.chevronLeft),
                      color: Theme.of(context).colorScheme.secondary),

                  // Week selector
                  InkWell(
                    borderRadius: BorderRadius.circular(6.0),
                    onTap: () => setState(() {
                      _controller.current();
                      if (mounted) {
                        _controller.jump(_controller.currentWeek, context: context, loader: _controller.currentWeekId != _controller.previousWeekId);
                      }
                    }),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "${_controller.currentWeekId + 1}. " +
                            "week".i18n +
                            " (" +
                            // Week start
                            DateFormat((_controller.currentWeek.start.year != DateTime.now().year ? "yy. " : "") + "MMM d.",
                                    I18n.of(context).locale.languageCode)
                                .format(_controller.currentWeek.start) +
                            " - " +
                            // Week end
                            DateFormat((_controller.currentWeek.start.year != DateTime.now().year ? "yy. " : "") + "MMM d.",
                                    I18n.of(context).locale.languageCode)
                                .format(_controller.currentWeek.end) +
                            ")",
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ),

                  // Next week
                  IconButton(
                      onPressed: _controller.currentWeekId == 51
                          ? null
                          : () => setState(() {
                                _controller.next(context);
                              }),
                      splashRadius: 24.0,
                      icon: const Icon(FeatherIcons.chevronRight),
                      color: Theme.of(context).colorScheme.secondary),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
