// ignore_for_file: dead_code
import 'dart:math';

import 'package:filcnaplo/api/providers/live_card_provider.dart';
import 'package:filcnaplo/ui/date_widget.dart';
import 'package:filcnaplo_premium/providers/premium_provider.dart';
import 'package:animated_list_plus/animated_list_plus.dart';
import 'package:filcnaplo/api/providers/update_provider.dart';
import 'package:filcnaplo/api/providers/sync.dart';
import 'package:confetti/confetti.dart';
import 'package:filcnaplo/models/settings.dart';
import 'package:filcnaplo_kreta_api/providers/absence_provider.dart';
import 'package:filcnaplo_kreta_api/providers/event_provider.dart';
import 'package:filcnaplo_kreta_api/providers/exam_provider.dart';
import 'package:filcnaplo_kreta_api/providers/grade_provider.dart';
import 'package:filcnaplo_kreta_api/providers/homework_provider.dart';
import 'package:filcnaplo_kreta_api/providers/message_provider.dart';
import 'package:filcnaplo_kreta_api/providers/note_provider.dart';
import 'package:filcnaplo/api/providers/user_provider.dart';
import 'package:filcnaplo/api/providers/status_provider.dart';
import 'package:filcnaplo_kreta_api/providers/timetable_provider.dart';
import 'package:filcnaplo_mobile_ui/common/empty.dart';
import 'package:filcnaplo_mobile_ui/common/filter_bar.dart';
import 'package:filcnaplo_mobile_ui/common/profile_image/profile_button.dart';
import 'package:filcnaplo_mobile_ui/common/profile_image/profile_image.dart';
import 'package:filcnaplo_mobile_ui/pages/home/live_card/live_card.dart';
import 'package:filcnaplo_mobile_ui/screens/navigation/navigation_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_page.i18n.dart';
import 'package:filcnaplo/utils/color.dart';
import 'package:filcnaplo/ui/filter/widgets.dart';
import 'package:filcnaplo/ui/filter/sort.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _tabController;
  late UserProvider user;
  late SettingsProvider settings;
  late UpdateProvider updateProvider;
  late StatusProvider statusProvider;
  late GradeProvider gradeProvider;
  late TimetableProvider timetableProvider;
  late MessageProvider messageProvider;
  late AbsenceProvider absenceProvider;
  late HomeworkProvider homeworkProvider;
  late ExamProvider examProvider;
  late NoteProvider noteProvider;
  late EventProvider eventProvider;

  late PageController _pageController;
  ConfettiController? _confettiController;
  late LiveCardProvider _liveCard;
  late AnimationController _liveCardAnimation;

  late String greeting;
  late String firstName;

  late List<String> listOrder;
  static const pageCount = 4;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: pageCount, vsync: this);
    _pageController = PageController();
    user = Provider.of<UserProvider>(context, listen: false);
    _liveCard = Provider.of<LiveCardProvider>(context, listen: false);
    _liveCardAnimation = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));

    _liveCardAnimation.animateTo(_liveCard.show ? 1.0 : 0.0, duration: Duration.zero);

    listOrder = List.generate(pageCount, (index) => "$index");
  }

  @override
  void dispose() {
    // _filterController.dispose();
    _pageController.dispose();
    _tabController.dispose();
    _confettiController?.dispose();
    _liveCardAnimation.dispose();

    super.dispose();
  }

  void setGreeting() {
    DateTime now = DateTime.now();
    if (now.isBefore(DateTime(now.year, DateTime.august, 31)) && now.isAfter(DateTime(now.year, DateTime.june, 14))) {
      greeting = "goodrest";

      if (NavigationScreen.of(context)?.init("confetti") ?? false) {
        _confettiController = ConfettiController(duration: const Duration(seconds: 1));
        Future.delayed(const Duration(seconds: 1)).then((value) => mounted ? _confettiController?.play() : null);
      }
    } else if (now.month == user.student?.birth.month && now.day == user.student?.birth.day) {
      greeting = "happybirthday";

      if (NavigationScreen.of(context)?.init("confetti") ?? false) {
        _confettiController = ConfettiController(duration: const Duration(seconds: 3));
        Future.delayed(const Duration(seconds: 1)).then((value) => mounted ? _confettiController?.play() : null);
      }
    } else if (now.month == DateTime.december && now.day >= 24 && now.day <= 26) {
      greeting = "merryxmas";
    } else if (now.month == DateTime.january && now.day == 1) {
      greeting = "happynewyear";
    } else if (now.hour >= 18) {
      greeting = "goodevening";
    } else if (now.hour >= 10) {
      greeting = "goodafternoon";
    } else if (now.hour >= 4) {
      greeting = "goodmorning";
    } else {
      greeting = "goodevening";
    }
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context);
    settings = Provider.of<SettingsProvider>(context);
    statusProvider = Provider.of<StatusProvider>(context, listen: false);
    updateProvider = Provider.of<UpdateProvider>(context);
    _liveCard = Provider.of<LiveCardProvider>(context);
    gradeProvider = Provider.of<GradeProvider>(context);
    context.watch<PremiumProvider>();

    _liveCardAnimation.animateTo(_liveCard.show ? 1.0 : 0.0);

    setGreeting();

    List<String> nameParts = user.displayName?.split(" ") ?? ["?"];
    if (!settings.presentationMode) {
      firstName = nameParts.length > 1 ? nameParts[1] : nameParts[0];
    } else {
      firstName = "Béla";
    }

    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: NestedScrollView(
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                headerSliverBuilder: (context, _) => [
                      AnimatedBuilder(
                        animation: _liveCardAnimation,
                        builder: (context, child) {
                          return SliverAppBar(
                            automaticallyImplyLeading: false,
                            surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
                            centerTitle: false,
                            titleSpacing: 0.0,
                            // Welcome text
                            title: Padding(
                              padding: const EdgeInsets.only(left: 24.0),
                              child: Text(
                                greeting.i18n.fill([firstName]),
                                overflow: TextOverflow.fade,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  color: Theme.of(context).textTheme.bodyMedium?.color,
                                ),
                              ),
                            ),
                            actions: [
                              // Profile Icon
                              Padding(
                                padding: const EdgeInsets.only(right: 24.0),
                                child: ProfileButton(
                                  child: ProfileImage(
                                    heroTag: "profile",
                                    name: firstName,
                                    backgroundColor: !settings.presentationMode
                                        ? ColorUtils.stringToColor(user.displayName ?? "?")
                                        : Theme.of(context).colorScheme.secondary,
                                    badge: updateProvider.available,
                                    role: user.role,
                                    profilePictureString: user.picture,
                                  ),
                                ),
                              ),
                            ],

                            expandedHeight: _liveCardAnimation.value * 234.0,

                            // Live Card
                            flexibleSpace: FlexibleSpaceBar(
                              background: Padding(
                                padding: EdgeInsets.only(
                                  left: 24.0,
                                  right: 24.0,
                                  top: 58.0 + MediaQuery.of(context).padding.top,
                                  bottom: 52.0,
                                ),
                                child: Transform.scale(
                                  scale: _liveCardAnimation.value,
                                  child: Opacity(
                                    opacity: _liveCardAnimation.value,
                                    child: const LiveCard(),
                                  ),
                                ),
                              ),
                            ),
                            shadowColor: Colors.black,

                            // Filter Bar
                            bottom: FilterBar(
                              items: [
                                Tab(text: "All".i18n),
                                Tab(text: "Grades".i18n),
                                Tab(text: "Messages".i18n),
                                Tab(text: "Absences".i18n),
                              ],
                              controller: _tabController,
                              onTap: (i) async {
                                int selectedPage = _pageController.page!.round();

                                if (i == selectedPage) return;
                                if (_pageController.page?.roundToDouble() != _pageController.page) {
                                  _pageController.animateToPage(i, curve: Curves.easeIn, duration: kTabScrollDuration);
                                  return;
                                }

                                // swap current page with target page
                                setState(() {
                                  _pageController.jumpToPage(i);
                                  String currentList = listOrder[selectedPage];
                                  listOrder[selectedPage] = listOrder[i];
                                  listOrder[i] = currentList;
                                });
                              },
                            ),
                            pinned: true,
                            floating: false,
                            snap: false,
                          );
                        },
                      ),
                    ],
                body: Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      // from flutter source
                      if (notification is ScrollUpdateNotification && !_tabController.indexIsChanging) {
                        if ((_pageController.page! - _tabController.index).abs() > 1.0) {
                          _tabController.index = _pageController.page!.floor();
                        }
                        _tabController.offset = (_pageController.page! - _tabController.index).clamp(-1.0, 1.0);
                      } else if (notification is ScrollEndNotification) {
                        _tabController.index = _pageController.page!.round();
                        if (!_tabController.indexIsChanging) _tabController.offset = (_pageController.page! - _tabController.index).clamp(-1.0, 1.0);
                      }
                      return false;
                    },
                    child: PageView.custom(
                      controller: _pageController,
                      childrenDelegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return FutureBuilder<List<DateWidget>>(
                            key: ValueKey<String>(listOrder[index]),
                            future: getFilterWidgets(homeFilters[index], context: context),
                            builder: (context, dateWidgets) => dateWidgets.data != null
                                ? RefreshIndicator(
                                    color: Theme.of(context).colorScheme.secondary,
                                    onRefresh: () => syncAll(context),
                                    child: ImplicitlyAnimatedList<Widget>(
                                      items: [
                                        if (index == 0) const SizedBox(key: Key("\$premium")),
                                        ...sortDateWidgets(context, dateWidgets: dateWidgets.data!),
                                      ],
                                      itemBuilder: filterItemBuilder,
                                      spawnIsolate: false,
                                      areItemsTheSame: (a, b) => a.key == b.key,
                                      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                    ))
                                : Container(),
                          );
                        },
                        childCount: 4,
                        findChildIndexCallback: (Key key) {
                          final ValueKey<String> valueKey = key as ValueKey<String>;
                          final String data = valueKey.value;
                          return listOrder.indexOf(data);
                        },
                      ),
                      physics: const PageScrollPhysics().applyTo(const BouncingScrollPhysics()),
                    ),
                  ),
                )),
          ),

          // confetti 🎊
          if (_confettiController != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: ConfettiWidget(
                confettiController: _confettiController!,
                blastDirection: -pi / 2,
                emissionFrequency: 0.01,
                numberOfParticles: 80,
                maxBlastForce: 100,
                minBlastForce: 90,
                gravity: 0.3,
                minimumSize: const Size(5, 5),
                maximumSize: const Size(20, 20),
              ),
            ),
        ],
      ),
    );
  }

  Future<Widget> filterViewBuilder(context, int activeData) async {
    final activeFilter = homeFilters[activeData];

    List<Widget> filterWidgets = sortDateWidgets(
      context,
      dateWidgets: await getFilterWidgets(activeFilter, context: context),
      showDivider: true,
    );

    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: RefreshIndicator(
        color: Theme.of(context).colorScheme.secondary,
        onRefresh: () => syncAll(context),
        child: ListView.builder(
          padding: EdgeInsets.zero,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            if (filterWidgets.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: filterWidgets[index],
              );
            } else {
              return Empty(subtitle: "empty".i18n);
            }
          },
          itemCount: max(filterWidgets.length, 1),
        ),
      ),
    );
  }
}
