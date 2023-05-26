import 'dart:math';
import 'package:animations/animations.dart';
import 'package:filcnaplo/api/providers/update_provider.dart';
import 'package:filcnaplo_kreta_api/client/client.dart';
import 'package:filcnaplo_kreta_api/models/week.dart';
import 'package:filcnaplo_kreta_api/providers/timetable_provider.dart';
import 'package:filcnaplo/api/providers/user_provider.dart';
import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:filcnaplo_kreta_api/models/lesson.dart';
import 'package:filcnaplo_mobile_ui/common/dot.dart';
import 'package:filcnaplo_mobile_ui/common/empty.dart';
import 'package:filcnaplo_mobile_ui/common/panel/panel.dart';
import 'package:filcnaplo_mobile_ui/common/profile_image/profile_button.dart';
import 'package:filcnaplo_mobile_ui/common/profile_image/profile_image.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/lesson/lesson_view.dart';
import 'package:filcnaplo_kreta_api/controllers/timetable_controller.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/lesson/lesson_viewable.dart';
import 'package:filcnaplo_mobile_ui/pages/timetable/day_title.dart';
import 'package:filcnaplo_mobile_ui/screens/navigation/navigation_route_handler.dart';
import 'package:filcnaplo_mobile_ui/screens/navigation/navigation_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:filcnaplo/utils/color.dart';
import 'package:intl/intl.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:filcnaplo_premium/ui/mobile/timetable/fs_timetable_button.dart';
import 'timetable_page.i18n.dart';

// todo: "fix" overflow (priority: -1)

class TimetablePage extends StatefulWidget {
  const TimetablePage({Key? key, this.initialDay, this.initialWeek}) : super(key: key);

  final DateTime? initialDay;
  final Week? initialWeek;

  static void jump(BuildContext context, {Week? week, DateTime? day, Lesson? lesson}) {
    // Go to timetable page with arguments
    NavigationScreen.of(context)?.customRoute(navigationPageRoute((context) => TimetablePage(
          initialDay: lesson?.date ?? day,
          initialWeek: lesson?.date != null
              ? Week.fromDate(lesson!.date)
              : day != null
                  ? Week.fromDate(day)
                  : week,
        )));

    NavigationScreen.of(context)?.setPage("timetable");

    // Show initial Lesson
    if (lesson != null) LessonView.show(lesson, context: context);
  }

  @override
  _TimetablePageState createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> with TickerProviderStateMixin, WidgetsBindingObserver {
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

  // When the app comes to foreground, refresh the timetable
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (mounted) _controller.jump(_controller.currentWeek, context: context);
    }
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

    // Register listening for app state changes to refresh the timetable
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _controller.dispose();
    user.removeListener(_userListener);
    WidgetsBinding.instance.removeObserver(this);
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
    List<String> nameParts = user.displayName?.split(" ") ?? ["?"];
    firstName = nameParts.length > 1 ? nameParts[1] : nameParts[0];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 9.0),
        child: RefreshIndicator(
          onRefresh: () => mounted ? _controller.jump(_controller.currentWeek, context: context, loader: false) : Future.value(null),
          color: Theme.of(context).colorScheme.secondary,
          edgeOffset: 132.0,
          child: NestedScrollView(
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            headerSliverBuilder: (context, _) => [
              SliverAppBar(
                centerTitle: false,
                pinned: true,
                floating: false,
                snap: false,
                surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
                actions: [
                  PremiumFSTimetableButton(controller: _controller),

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
                // Current day text
                title: PageTransitionSwitcher(
                  reverse: _controller.currentWeekId < _controller.previousWeekId,
                  transitionBuilder: (
                    Widget child,
                    Animation<double> primaryAnimation,
                    Animation<double> secondaryAnimation,
                  ) {
                    return SharedAxisTransition(
                      animation: primaryAnimation,
                      secondaryAnimation: secondaryAnimation,
                      transitionType: SharedAxisTransitionType.horizontal,
                      child: child,
                      fillColor: Theme.of(context).scaffoldBackgroundColor,
                    );
                  },
                  layoutBuilder: (List<Widget> entries) {
                    return Stack(
                      children: entries,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      children: [
                        () {
                          final show =
                              _controller.days == null || (_controller.loadType != LoadType.offline && _controller.loadType != LoadType.online);
                          const duration = Duration(milliseconds: 150);
                          return AnimatedOpacity(
                            opacity: show ? 1.0 : 0.0,
                            duration: duration,
                            curve: Curves.easeInOut,
                            child: AnimatedContainer(
                              duration: duration,
                              width: show ? 24.0 : 0.0,
                              curve: Curves.easeInOut,
                              child: const Padding(
                                padding: EdgeInsets.only(right: 12.0),
                                child: CupertinoActivityIndicator(),
                              ),
                            ),
                          );
                        }(),
                        () {
                          if ((_controller.days?.length ?? 0) > 0) {
                            return DayTitle(controller: _tabController, dayTitle: dayTitle);
                          } else {
                            return Text(
                              "timetable".i18n,
                              style: TextStyle(
                                fontSize: 32.0,
                                fontWeight: FontWeight.bold,
                                color: AppColors.of(context).text,
                              ),
                            );
                          }
                        }(),
                      ],
                    ),
                  ),
                ),
                shadowColor: Theme.of(context).shadowColor,
                bottom: PreferredSize(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
                              _controller.jump(
                                _controller.currentWeek,
                                context: context,
                                loader: _controller.currentWeekId != _controller.previousWeekId,
                              );
                            }
                            _tabController.animateTo(_getDayIndex(DateTime.now()));
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
                  preferredSize: const Size.fromHeight(50.0),
                ),
              ),
            ],
            body: PageTransitionSwitcher(
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
                  ? Column(
                      key: Key(_controller.currentWeek.toString()),
                      children: [
                        // Week view
                        _tabController.length > 0
                            ? Expanded(
                                child: TabBarView(
                                  physics: const BouncingScrollPhysics(),
                                  controller: _tabController,
                                  // days
                                  children: List.generate(
                                    _controller.days!.length,
                                    (tab) => RefreshIndicator(
                                      onRefresh: () =>
                                          mounted ? _controller.jump(_controller.currentWeek, context: context, loader: false) : Future.value(null),
                                      color: Theme.of(context).colorScheme.secondary,
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
                                  ),
                                ),
                              )

                            // Empty week
                            : Expanded(
                                child: Center(child: empty),
                              ),

                        // Day selector
                        TabBar(
                          dividerColor: Colors.transparent,
                          controller: _tabController,
                          // Label
                          labelPadding: EdgeInsets.zero,
                          labelColor: Theme.of(context).colorScheme.secondary,
                          unselectedLabelColor: AppColors.of(context).text.withOpacity(0.9),
                          // Indicator
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicatorPadding: EdgeInsets.zero,
                          indicator: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(45.0),
                          ),
                          overlayColor: MaterialStateProperty.all(const Color(0x00000000)),
                          // Tabs
                          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
                          tabs: List.generate(_tabController.length, (index) {
                            String label = DateFormat("E", I18n.of(context).locale.languageCode).format(_controller.days![index].first.date);
                            return Tab(
                              height: 46.0,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (_sameDate(_controller.days![index].first.date, DateTime.now()))
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Dot(size: 4.0, color: Theme.of(context).colorScheme.secondary),
                                    ),
                                  Text(
                                    label.substring(0, min(2, label.length)),
                                    style: const TextStyle(fontSize: 26.0, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      ],
                    )
                  : const SizedBox(),
            ),
          ),
        ),
      ),
    );
  }
}

// difference.inDays is not reliable
bool _sameDate(DateTime a, DateTime b) => (a.year == b.year && a.month == b.month && a.day == b.day);
