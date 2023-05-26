// ignore_for_file: prefer_function_declarations_over_variables

import 'dart:io';

import 'package:filcnaplo/helpers/quick_actions.dart';
import 'package:filcnaplo/icons/filc_icons.dart';
import 'package:filcnaplo/models/settings.dart';
import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:filcnaplo/theme/observer.dart';
import 'package:filcnaplo_kreta_api/models/grade.dart';
import 'package:filcnaplo_kreta_api/models/week.dart';
import 'package:filcnaplo_kreta_api/providers/timetable_provider.dart';
import 'package:filcnaplo_mobile_ui/common/bottom_sheet_menu/bottom_sheet_menu.dart';
import 'package:filcnaplo_mobile_ui/common/bottom_sheet_menu/bottom_sheet_menu_item.dart';
import 'package:filcnaplo_mobile_ui/common/bottom_sheet_menu/rounded_bottom_sheet.dart';
import 'package:filcnaplo_mobile_ui/common/filter_bar.dart';
import 'package:filcnaplo_mobile_ui/common/material_action_button.dart';
import 'package:filcnaplo/ui/widgets/grade/grade_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:provider/provider.dart';
import 'package:filcnaplo_mobile_ui/common/screens.i18n.dart';
import 'package:filcnaplo_mobile_ui/screens/settings/settings_screen.i18n.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:filcnaplo/models/icon_pack.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:filcnaplo_premium/ui/mobile/settings/theme.dart';

class SettingsHelper {
  static const Map<String, String> langMap = {"en": "🇬🇧  English", "hu": "🇭🇺  Magyar", "de": "🇩🇪  Deutsch"};

  static const Map<Pages, String> pageTitle = {
    Pages.home: "home",
    Pages.grades: "grades",
    Pages.timetable: "timetable",
    Pages.messages: "messages",
    Pages.absences: "absences",
  };

  static Map<VibrationStrength, String> vibrationTitle = {
    VibrationStrength.off: "voff",
    VibrationStrength.light: "vlight",
    VibrationStrength.medium: "vmedium",
    VibrationStrength.strong: "vstrong",
  };

  static Map<Pages, String> localizedPageTitles() => pageTitle.map((key, value) => MapEntry(key, ScreensLocalization(value).i18n));
  static Map<VibrationStrength, String> localizedVibrationTitles() =>
      vibrationTitle.map((key, value) => MapEntry(key, SettingsLocalization(value).i18n));

  static void language(BuildContext context) {
    showBottomSheetMenu(
      context,
      items: List.generate(langMap.length, (index) {
        String lang = langMap.keys.toList()[index];
        return BottomSheetMenuItem(
          onPressed: () {
            Provider.of<SettingsProvider>(context, listen: false).update(language: lang);
            I18n.of(context).locale = Locale(lang, lang.toUpperCase());
            Navigator.of(context).maybePop();
            if (Platform.isAndroid || Platform.isIOS) {
              setupQuickActions();
            }
          },
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(langMap.values.toList()[index]),
              if (lang == I18n.of(context).locale.languageCode)
                Icon(
                  Icons.check_circle,
                  color: Theme.of(context).colorScheme.secondary,
                ),
            ],
          ),
        );
      }),
    );
  }

  static void iconPack(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    showBottomSheetMenu(
      context,
      items: List.generate(IconPack.values.length, (index) {
        IconPack current = IconPack.values[index];
        return BottomSheetMenuItem(
          onPressed: () {
            settings.update(iconPack: current);
            Navigator.of(context).maybePop();
          },
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(current.name.capital()),
              if (current == settings.iconPack)
                Icon(
                  Icons.check_circle,
                  color: Theme.of(context).colorScheme.secondary,
                ),
            ],
          ),
        );
      }),
    );
  }

  static void startPage(BuildContext context) {
    Map<Pages, IconData> pageIcons = {
      Pages.home: FilcIcons.home,
      Pages.grades: FeatherIcons.bookmark,
      Pages.timetable: FeatherIcons.calendar,
      Pages.messages: FeatherIcons.messageSquare,
      Pages.absences: FeatherIcons.clock,
    };

    showBottomSheetMenu(
      context,
      items: List.generate(Pages.values.length, (index) {
        return BottomSheetMenuItem(
          onPressed: () {
            Provider.of<SettingsProvider>(context, listen: false).update(startPage: Pages.values[index]);
            Navigator.of(context).maybePop();
          },
          title: Row(
            children: [
              Icon(pageIcons[Pages.values[index]], size: 20.0, color: Theme.of(context).colorScheme.secondary),
              const SizedBox(width: 16.0),
              Text(localizedPageTitles()[Pages.values[index]] ?? ""),
              const Spacer(),
              if (Pages.values[index] == Provider.of<SettingsProvider>(context, listen: false).startPage)
                Icon(
                  Icons.check_circle,
                  color: Theme.of(context).colorScheme.secondary,
                ),
            ],
          ),
        );
      }),
    );
  }

  static void rounding(BuildContext context) {
    showRoundedModalBottomSheet(
      context,
      child: const RoundingSetting(),
    );
  }

  static void theme(BuildContext context) {
    var settings = Provider.of<SettingsProvider>(context, listen: false);
    void Function(ThemeMode) setTheme = (mode) {
      settings.update(theme: mode);
      Provider.of<ThemeModeObserver>(context, listen: false).changeTheme(mode);
      Navigator.of(context).maybePop();
    };

    showBottomSheetMenu(context, items: [
      BottomSheetMenuItem(
        onPressed: () => setTheme(ThemeMode.system),
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Icon(FeatherIcons.smartphone, size: 20.0, color: Theme.of(context).colorScheme.secondary),
            ),
            Text(SettingsLocalization("system").i18n),
            const Spacer(),
            if (settings.theme == ThemeMode.system)
              Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.secondary,
              ),
          ],
        ),
      ),
      BottomSheetMenuItem(
        onPressed: () => setTheme(ThemeMode.light),
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Icon(FeatherIcons.sun, size: 20.0, color: Theme.of(context).colorScheme.secondary),
            ),
            Text(SettingsLocalization("light").i18n),
            const Spacer(),
            if (settings.theme == ThemeMode.light)
              Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.secondary,
              ),
          ],
        ),
      ),
      BottomSheetMenuItem(
        onPressed: () => setTheme(ThemeMode.dark),
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Icon(FeatherIcons.moon, size: 20.0, color: Theme.of(context).colorScheme.secondary),
            ),
            Text(SettingsLocalization("dark").i18n),
            const Spacer(),
            if (settings.theme == ThemeMode.dark)
              Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.secondary,
              ),
          ],
        ),
      )
    ]);
  }

  static void accentColor(BuildContext context) {
    Navigator.of(context, rootNavigator: true).push(
      PageRouteBuilder(
        pageBuilder: (context, _, __) => const PremiumCustomAccentColorSetting(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  static void gradeColors(BuildContext context) {
    showRoundedModalBottomSheet(
      context,
      child: const GradeColorsSetting(),
    );
  }

  static void vibrate(BuildContext context) {
    showBottomSheetMenu(
      context,
      items: List.generate(VibrationStrength.values.length, (index) {
        VibrationStrength value = VibrationStrength.values[index];

        return BottomSheetMenuItem(
          onPressed: () {
            Provider.of<SettingsProvider>(context, listen: false).update(vibrate: value);
            Navigator.of(context).maybePop();
          },
          title: Row(
            children: [
              Container(
                width: 12.0,
                height: 12.0,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary.withOpacity((index + 1) / (vibrationTitle.length + 1)),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 16.0),
              Text(localizedVibrationTitles()[value] ?? "?"),
              const Spacer(),
              if (value == Provider.of<SettingsProvider>(context, listen: false).vibrate)
                Icon(
                  Icons.check_circle,
                  color: Theme.of(context).colorScheme.secondary,
                ),
            ],
          ),
        );
      }),
    );
  }

  static void bellDelay(BuildContext context) {
    showRoundedModalBottomSheet(
      context,
      child: const BellDelaySetting(),
    );
  }
}

// Rounding modal
class RoundingSetting extends StatefulWidget {
  const RoundingSetting({Key? key}) : super(key: key);

  @override
  _RoundingSettingState createState() => _RoundingSettingState();
}

class _RoundingSettingState extends State<RoundingSetting> {
  late double rounding;

  @override
  void initState() {
    super.initState();
    rounding = Provider.of<SettingsProvider>(context, listen: false).rounding / 10;
  }

  @override
  Widget build(BuildContext context) {
    int roundingResult;

    if (4.5 >= 4.5.floor() + rounding) {
      roundingResult = 5;
    } else {
      roundingResult = 4;
    }

    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Slider(
              value: rounding,
              min: 0.1,
              max: 0.9,
              divisions: 8,
              label: rounding.toStringAsFixed(1),
              activeColor: Theme.of(context).colorScheme.secondary,
              thumbColor: Theme.of(context).colorScheme.secondary,
              onChanged: (v) => setState(() => rounding = v),
            ),
          ),
          Container(
            width: 50.0,
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(rounding.toStringAsFixed(1),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                  )),
            ),
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("4.5", style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.w500)),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Icon(FeatherIcons.arrowRight, color: Colors.grey),
          ),
          GradeValueWidget(GradeValue(roundingResult, "", "", 100), fill: true, size: 32.0),
        ],
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 12.0, top: 6.0),
        child: MaterialActionButton(
          child: Text(SettingsLocalization("done").i18n),
          onPressed: () {
            Provider.of<SettingsProvider>(context, listen: false).update(rounding: (rounding * 10).toInt());
            Navigator.of(context).maybePop();
          },
        ),
      ),
    ]);
  }
}

// Bell Delay Modal

class BellDelaySetting extends StatefulWidget {
  const BellDelaySetting({Key? key}) : super(key: key);

  @override
  State<BellDelaySetting> createState() => _BellDelaySettingState();
}

class _BellDelaySettingState extends State<BellDelaySetting> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Duration currentDelay;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: Provider.of<SettingsProvider>(context, listen: false).bellDelay > 0 ? 1 : 0);
    currentDelay = Duration(seconds: Provider.of<SettingsProvider>(context, listen: false).bellDelay);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FilterBar(
          scrollable: false,
          items: [
            Tab(text: SettingsLocalization("delay").i18n),
            Tab(text: SettingsLocalization("hurry").i18n),
          ],
          controller: _tabController,
          onTap: (i) async {
            // swap current page with target page
            setState(() {
              currentDelay = i == 0 ? -currentDelay.abs() : currentDelay.abs();
            });
          },
        ),
        SizedBox(
          height: 200,
          child: CupertinoTheme(
            data: CupertinoThemeData(
              brightness: Theme.of(context).brightness,
            ),
            child: CupertinoTimerPicker(
              key: UniqueKey(),
              mode: CupertinoTimerPickerMode.ms,
              initialTimerDuration: currentDelay.abs(),
              onTimerDurationChanged: (Duration d) {
                HapticFeedback.selectionClick();

                currentDelay = _tabController.index == 0 ? -d : d;
              },
            ),
          ),
        ),
        Text(SettingsLocalization("sync_help").i18n,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500, color: AppColors.of(context).text.withOpacity(.75))),
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0, top: 6.0),
          child: Column(
            children: [
              MaterialActionButton(
                backgroundColor: AppColors.of(context).filc,
                child: Text(SettingsLocalization("sync").i18n),
                onPressed: () {
                  final lessonProvider = Provider.of<TimetableProvider>(context, listen: false);

                  Duration? closest;
                  DateTime now = DateTime.now();
                  for (var lesson in lessonProvider.getWeek(Week.current()) ?? []) {
                    Duration sdiff = lesson.start.difference(now);
                    Duration ediff = lesson.end.difference(now);

                    if (closest == null || sdiff.abs() < closest.abs()) closest = sdiff;
                    if (ediff.abs() < closest.abs()) closest = ediff;
                  }
                  if (closest != null) {
                    if (closest.inHours.abs() >= 1) return;
                    currentDelay = closest;
                    Provider.of<SettingsProvider>(context, listen: false).update(bellDelay: currentDelay.inSeconds);
                    _tabController.index = currentDelay.inSeconds > 0 ? 1 : 0;
                    setState(() {});
                  }
                },
              ),
              MaterialActionButton(
                child: Text(SettingsLocalization("done").i18n),
                onPressed: () {
                  //Provider.of<SettingsProvider>(context, listen: false).update(context, rounding: (r * 10).toInt());
                  Provider.of<SettingsProvider>(context, listen: false).update(bellDelay: currentDelay.inSeconds);
                  Navigator.of(context).maybePop();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class GradeColorsSetting extends StatefulWidget {
  const GradeColorsSetting({Key? key}) : super(key: key);

  @override
  _GradeColorsSettingState createState() => _GradeColorsSettingState();
}

class _GradeColorsSettingState extends State<GradeColorsSetting> {
  Color currentColor = const Color(0x00000000);
  late SettingsProvider settings;

  @override
  void initState() {
    super.initState();
    settings = Provider.of<SettingsProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(5, (index) {
            return ClipOval(
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                  onTap: () {
                    currentColor = settings.gradeColors[index];
                    showRoundedModalBottomSheet(
                      context,
                      child: Column(children: [
                        MaterialColorPicker(
                          selectedColor: settings.gradeColors[index],
                          onColorChange: (v) {
                            setState(() {
                              currentColor = v;
                            });
                          },
                          allowShades: true,
                          elevation: 0,
                          physics: const NeverScrollableScrollPhysics(),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              MaterialActionButton(
                                onPressed: () {
                                  List<Color> colors = List.castFrom(settings.gradeColors);
                                  var defaultColors = SettingsProvider.defaultSettings().gradeColors;
                                  colors[index] = defaultColors[index];
                                  settings.update(gradeColors: colors);
                                  Navigator.of(context).maybePop();
                                },
                                child: Text(SettingsLocalization("reset").i18n),
                              ),
                              MaterialActionButton(
                                onPressed: () {
                                  List<Color> colors = List.castFrom(settings.gradeColors);
                                  colors[index] = currentColor.withAlpha(255);
                                  settings.update(gradeColors: settings.gradeColors);
                                  Navigator.of(context).maybePop();
                                },
                                child: Text(SettingsLocalization("done").i18n),
                              ),
                            ],
                          ),
                        ),
                      ]),
                    ).then((value) => setState(() {}));
                  },
                  child: GradeValueWidget(GradeValue(index + 1, "", "", 0), fill: true, size: 36.0),
                ),
              ),
            );
          }),
        ),
      ),
    ]);
  }
}
