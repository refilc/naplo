import 'package:filcnaplo/api/providers/user_provider.dart';
import 'package:filcnaplo/models/settings.dart';
import 'package:filcnaplo/ui/date_widget.dart';
import 'package:filcnaplo_desktop_ui/common/filter_bar.dart';
import 'package:flutter/material.dart';
import 'package:animated_list_plus/animated_list_plus.dart';
import 'package:provider/provider.dart';
import 'package:filcnaplo/ui/filter/widgets.dart';
import 'package:filcnaplo/ui/filter/sort.dart';
import 'home_page.i18n.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late UserProvider user;
  late SettingsProvider settings;

  late TabController _tabController;
  late PageController _pageController;

  late String greeting;
  late String firstName;

  late List<String> listOrder;
  static const pageCount = 4;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: pageCount, vsync: this);
    _pageController = PageController();

    listOrder = List.generate(pageCount, (index) => "$index");

    user = Provider.of<UserProvider>(context, listen: false);

    DateTime now = DateTime.now();
    if (now.isBefore(DateTime(now.year, DateTime.august, 31)) && now.isAfter(DateTime(now.year, DateTime.june, 14))) {
      greeting = "goodrest";
    } else if (now.month == user.student?.birth.month && now.day == user.student?.birth.day) {
      greeting = "happybirthday";
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

    List<String> nameParts = user.name?.split(" ") ?? ["?"];
    if (!settings.presentationMode) {
      firstName = nameParts.length > 1 ? nameParts[1] : nameParts[0];
    } else {
      firstName = "Béla";
    }

    return SafeArea(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting
                Padding(
                  padding: const EdgeInsets.only(left: 32.0, top: 24.0, bottom: 12.0),
                  child: Text(
                    greeting.i18n.fill([firstName]),
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: FilterBar(
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
                    disableFading: true,
                  ),
                ),

                // Data filters
                Expanded(
                  child: PageView.custom(
                    controller: _pageController,
                    childrenDelegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return FutureBuilder<List<DateWidget>>(
                          key: ValueKey<String>(listOrder[index]),
                          future: getFilterWidgets(homeFilters[index], context: context),
                          builder: (context, dateWidgets) => dateWidgets.data != null
                              ? ImplicitlyAnimatedList<Widget>(
                                  items: sortDateWidgets(context, dateWidgets: dateWidgets.data!),
                                  itemBuilder: filterItemBuilder,
                                  spawnIsolate: false,
                                  areItemsTheSame: (a, b) => a.key == b.key,
                                  physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                )
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
