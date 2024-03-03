import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:refilc/api/providers/update_provider.dart';
import 'package:refilc/helpers/quick_actions.dart';
import 'package:refilc/models/settings.dart';
import 'package:refilc/theme/observer.dart';
import 'package:refilc_kreta_api/client/client.dart';
import 'package:refilc_kreta_api/providers/grade_provider.dart';
import 'package:refilc_mobile_ui/common/system_chrome.dart';
import 'package:refilc_mobile_ui/screens/navigation/nabar.dart';
import 'package:refilc_mobile_ui/screens/navigation/navbar_item.dart';
import 'package:refilc_mobile_ui/screens/navigation/navigation_route.dart';
import 'package:refilc_mobile_ui/screens/navigation/navigation_route_handler.dart';
import 'package:refilc/icons/filc_icons.dart';
import 'package:refilc_mobile_ui/screens/navigation/status_bar.dart';
import 'package:refilc_mobile_ui/screens/news/news_view.dart';
import 'package:refilc_mobile_ui/screens/settings/settings_screen.dart';
import 'package:refilc_plus/ui/mobile/goal_planner/goal_complete_modal.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:refilc_mobile_ui/common/screens.i18n.dart';
import 'package:refilc/api/providers/news_provider.dart';
import 'package:refilc/api/providers/sync.dart';
import 'package:home_widget/home_widget.dart';
import 'package:wtf_sliding_sheet/wtf_sliding_sheet.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:refilc_plus/providers/goal_provider.dart';
import 'package:refilc/api/providers/ad_provider.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  static NavigationScreenState? of(BuildContext context) =>
      context.findAncestorStateOfType<NavigationScreenState>();

  @override
  NavigationScreenState createState() => NavigationScreenState();
}

class NavigationScreenState extends State<NavigationScreen>
    with WidgetsBindingObserver {
  late NavigationRoute selected;
  List<String> initializers = [];
  final _navigatorState = GlobalKey<NavigatorState>();

  late SettingsProvider settings;
  late NewsProvider newsProvider;
  late GoalProvider goalProvider;
  late UpdateProvider updateProvider;
  late GradeProvider gradeProvicer;
  late AdProvider adProvider;

  NavigatorState? get navigator => _navigatorState.currentState;

  void customRoute(Route route) => navigator?.pushReplacement(route);

  bool init(String id) {
    if (initializers.contains(id)) return false;

    initializers.add(id);

    return true;
  }

  void _checkForWidgetLaunch() {
    HomeWidget.initiallyLaunchedFromHomeWidget().then(_launchedFromWidget);
  }

  void _launchedFromWidget(Uri? uri) async {
    if (uri == null) return;

    if (uri.scheme == "timetable" && uri.authority == "refresh") {
      Navigator.of(context).popUntil((route) => route.isFirst);

      setPage("timetable");
      _navigatorState.currentState
          ?.pushNamedAndRemoveUntil("timetable", (_) => false);
    } else if (uri.scheme == "settings" && uri.authority == "premium") {
      Navigator.of(context).popUntil((route) => route.isFirst);

      showSlidingBottomSheet(
        context,
        useRootNavigator: true,
        builder: (context) => SlidingSheetDialog(
          color: Theme.of(context).scaffoldBackgroundColor,
          duration: const Duration(milliseconds: 400),
          scrollSpec: const ScrollSpec.bouncingScroll(),
          snapSpec: const SnapSpec(
            snap: true,
            snappings: [1.0],
            initialSnap: 1.0,
            positioning: SnapPositioning.relativeToSheetHeight,
          ),
          cornerRadius: 16,
          cornerRadiusOnFullscreen: 0,
          builder: (context, state) => Material(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: const SettingsScreen(),
          ),
        ),
      );
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Configure BackgroundFetch.
    int status = await BackgroundFetch.configure(
        BackgroundFetchConfig(
            minimumFetchInterval: 15,
            stopOnTerminate: false,
            enableHeadless: true,
            requiresBatteryNotLow: false,
            requiresCharging: false,
            requiresStorageNotLow: false,
            requiresDeviceIdle: false,
            requiredNetworkType: NetworkType.ANY), (String taskId) async {
      // <-- Event handler
      // This is the fetch-event callback.
      if (kDebugMode) {
        print("[BackgroundFetch] Event received $taskId");
      }

      // IMPORTANT:  You must signal completion of your task or the OS can punish your app
      // for taking too long in the background.
      BackgroundFetch.finish(taskId);
    }, (String taskId) async {
      // <-- Task timeout handler.
      // This task has exceeded its allowed running-time.  You must stop what you're doing and immediately .finish(taskId)
      if (kDebugMode) {
        print("[BackgroundFetch] TASK TIMEOUT taskId: $taskId");
      }
      BackgroundFetch.finish(taskId);
    });
    if (kDebugMode) {
      print('[BackgroundFetch] configure success: $status');
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  @override
  void initState() {
    super.initState();

    HomeWidget.setAppGroupId('hu.refilc.naplo.group');

    _checkForWidgetLaunch();
    HomeWidget.widgetClicked.listen(_launchedFromWidget);

    settings = Provider.of<SettingsProvider>(context, listen: false);
    selected = NavigationRoute();
    selected.index = settings.startPage.index; // set page index to start page

    // add brightness observer
    WidgetsBinding.instance.addObserver(this);

    // set client User-Agent
    Provider.of<KretaClient>(context, listen: false).userAgent =
        settings.config.userAgent;

    // get news
    newsProvider = Provider.of<NewsProvider>(context, listen: false);
    newsProvider.restore().then((value) => newsProvider.fetch());

    // init grade provider (for goals)
    gradeProvicer = Provider.of<GradeProvider>(context, listen: false);

    // get goals
    goalProvider = Provider.of<GoalProvider>(context, listen: false);
    goalProvider.fetchDone(gradeProvider: gradeProvicer);

    // get releases
    updateProvider = Provider.of<UpdateProvider>(context, listen: false);
    updateProvider.fetch();

    // get advertisements
    adProvider = Provider.of<AdProvider>(context, listen: false);
    adProvider.fetch();

    // initial sync
    syncAll(context);
    setupQuickActions();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    if (settings.theme == ThemeMode.system) {
      // ignore: deprecated_member_use
      Brightness? brightness =
          // ignore: deprecated_member_use
          WidgetsBinding.instance.window.platformBrightness;
      Provider.of<ThemeModeObserver>(context, listen: false).changeTheme(
          brightness == Brightness.light ? ThemeMode.light : ThemeMode.dark);
    }
    super.didChangePlatformBrightness();
  }

  void setPage(String page) => setState(() => selected.name = page);

  @override
  Widget build(BuildContext context) {
    setSystemChrome(context);
    settings = Provider.of<SettingsProvider>(context);
    newsProvider = Provider.of<NewsProvider>(context);
    goalProvider = Provider.of<GoalProvider>(context);

    // show news and complete goals
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (newsProvider.show) {
        NewsView.show(newsProvider.news[0], context: context)
            .then((value) => newsProvider.release());
        newsProvider.lock();
      }

      if (goalProvider.hasDoneGoals) {
        GoalCompleteModal.show(goalProvider.doneSubject!, context: context);
        goalProvider.lock();
      }
    });

    handleQuickActions(context, (page) {
      setPage(page);
      _navigatorState.currentState?.pushReplacementNamed(page);
    });

    // SvgTheme navIcTheme =
    //     SvgTheme(currentColor: Theme.of(context).colorScheme.primary);

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        if (_navigatorState.currentState?.canPop() ?? false) {
          _navigatorState.currentState?.pop();
          if (!kDebugMode) {
            return true;
          }
          return false;
        }

        if (selected.index != 0) {
          setState(() => selected.index = 0);
          _navigatorState.currentState?.pushReplacementNamed(selected.name);
        }

        return false;
      },
      child: Scaffold(
        body: Column(
          children: [
            // actual page
            Expanded(
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Navigator(
                    key: _navigatorState,
                    initialRoute: selected.name,
                    onGenerateRoute: (settings) =>
                        navigationRouteHandler(settings),
                  ),
                ],
              ),
            ),

            // navbar
            Container(
              decoration: settings.navShadow
                  ? BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          offset: const Offset(0, -4),
                          blurRadius: 14,
                          spreadRadius: 18,
                        ),
                      ],
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0.0, 0.175],
                        colors: [
                          Theme.of(context).scaffoldBackgroundColor,
                          Theme.of(context).scaffoldBackgroundColor,
                        ],
                      ),
                    )
                  : null,
              child: Column(
                children: [
                  // Status bar
                  Material(
                    color: Theme.of(context).colorScheme.background,
                    child: const StatusBar(),
                  ),

                  // Bottom Navigaton Bar
                  Material(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: Navbar(
                        selectedIndex: selected.index,
                        onSelected: onPageSelected,
                        items: [
                          NavItem(
                            title: "home".i18n,
                            icon: Stack(
                              alignment: AlignmentDirectional.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/svg/menu_icons/today.svg',
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  height: 24,
                                ),
                                Transform.translate(
                                  offset: const Offset(0, 1.6),
                                  child: Text(
                                    DateTime.now().day.toString(),
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            activeIcon: Stack(
                              alignment: AlignmentDirectional.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/svg/menu_icons/today_selected.svg',
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  height: 24,
                                ),
                                Transform.translate(
                                  offset: const Offset(0, 1.8),
                                  child: Text(
                                    DateTime.now().day.toString(),
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          NavItem(
                            title: "grades".i18n,
                            icon: const Icon(FeatherIcons.bookmark),
                            activeIcon: const Icon(FilcIcons.gradesfill),
                          ),
                          NavItem(
                            title: "timetable".i18n,
                            icon: const Icon(FeatherIcons.calendar),
                            activeIcon: const Icon(FilcIcons.timetablefill),
                          ),
                          NavItem(
                            title: "messages".i18n,
                            icon: const Icon(FeatherIcons.messageSquare),
                            activeIcon: const Icon(FilcIcons.messagesfill),
                          ),
                          NavItem(
                            title: "absences".i18n,
                            icon: const Icon(FeatherIcons.clock),
                            activeIcon: const Icon(FilcIcons.absencesfill),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onPageSelected(int index) {
    // Vibrate, then set the active screen
    if (selected.index != index) {
      switch (settings.vibrate) {
        case VibrationStrength.light:
          HapticFeedback.lightImpact();
          break;
        case VibrationStrength.medium:
          HapticFeedback.mediumImpact();
          break;
        case VibrationStrength.strong:
          HapticFeedback.heavyImpact();
          break;
        default:
      }
      setState(() => selected.index = index);
      _navigatorState.currentState?.pushReplacementNamed(selected.name);
    }
  }
}
