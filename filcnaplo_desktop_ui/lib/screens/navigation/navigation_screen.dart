import 'dart:io';

import 'package:filcnaplo/api/providers/news_provider.dart';
import 'package:filcnaplo/api/providers/sync.dart';
import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:filcnaplo/theme/observer.dart';
import 'package:filcnaplo_desktop_ui/screens/navigation/navigation_route.dart';
import 'package:filcnaplo_desktop_ui/screens/navigation/navigation_route_handler.dart';
import 'package:filcnaplo_desktop_ui/screens/navigation/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:provider/provider.dart';
import 'package:filcnaplo/models/settings.dart';
import 'package:filcnaplo_kreta_api/client/client.dart';
import 'package:filcnaplo_premium/providers/goal_provider.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  static NavigationScreenState? of(BuildContext context) =>
      context.findAncestorStateOfType<NavigationScreenState>();

  @override
  State<NavigationScreen> createState() => NavigationScreenState();
}

class NavigationScreenState extends State<NavigationScreen>
    with WidgetsBindingObserver {
  final _navigatorState = GlobalKey<NavigatorState>();
  late NavigationRoute selected;
  late SettingsProvider settings;
  late NewsProvider newsProvider;
  late GoalProvider goalProvider;
  double topInset = 0.0;

  @override
  void initState() {
    super.initState();
    settings = Provider.of<SettingsProvider>(context, listen: false);
    selected = NavigationRoute();
    selected.index = 0;

    // add brightness observer
    WidgetsBinding.instance.addObserver(this);

    // set client User-Agent
    Provider.of<KretaClient>(context, listen: false).userAgent =
        settings.config.userAgent;

    // get news
    newsProvider = Provider.of<NewsProvider>(context, listen: false);
    newsProvider.restore().then((value) => newsProvider.fetch());

    // get goals
    // goalProvider = Provider.of<GoalProvider>(context, listen: false);
    // goalProvider.fetchDone();

    // Initial sync
    syncAll(context);

    () async {
      try {
        await Window.initialize();
      } catch (_) {}
      // Transparent sidebar
      await Window.setEffect(
          effect: WindowEffect.acrylic,
          color: Platform.isMacOS
              ? Colors.transparent
              : const Color.fromARGB(27, 27, 27, 27));

      // todo: do for windows
      if (Platform.isMacOS) {
        topInset = await Window.getTitlebarHeight();
        await Window.enableFullSizeContentView();
        await Window.hideTitle();
        await Window.makeTitlebarTransparent();
      }
    }();
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
    settings = Provider.of<SettingsProvider>(context);
    newsProvider = Provider.of<NewsProvider>(context);
    goalProvider = Provider.of<GoalProvider>(context);

    // show news / complete goals
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (newsProvider.show) {
        newsProvider.lock();
        // NewsView.show(newsProvider.news[newsProvider.state], context: context).then((value) => newsProvider.release());
      }
      if (goalProvider.hasDoneGoals) {
        // to-do
      }
    });

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Row(
        children: [
          if (_navigatorState.currentState != null)
            Container(
              decoration: BoxDecoration(
                color:
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(.5),
                border: Border(
                    right: BorderSide(
                        color: AppColors.of(context).shadow.withOpacity(.7),
                        width: 1.0)),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: topInset),
                child: Sidebar(
                  navigator: _navigatorState.currentState!,
                  selected: selected.name,
                  onRouteChange: (name) => setPage(name),
                ),
              ),
            ),
          Expanded(
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  padding: EdgeInsets.only(top: topInset),
                ),
                child: Navigator(
                  key: _navigatorState,
                  initialRoute: selected.name,
                  onGenerateRoute: (settings) =>
                      navigationRouteHandler(settings),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
