import 'package:filcnaplo/models/settings.dart';
import 'package:filcnaplo/models/shared_theme.dart';
import 'package:filcnaplo/theme/colors/accent.dart';
import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:filcnaplo/theme/observer.dart';
import 'package:filcnaplo/ui/widgets/grade/grade_tile.dart';
import 'package:filcnaplo/ui/widgets/message/message_tile.dart';
import 'package:filcnaplo_kreta_api/models/grade.dart';
import 'package:filcnaplo_kreta_api/models/homework.dart';
import 'package:filcnaplo_kreta_api/models/message.dart';
import 'package:filcnaplo_mobile_ui/common/action_button.dart';
import 'package:filcnaplo_mobile_ui/common/filter_bar.dart';
import 'package:filcnaplo_mobile_ui/common/panel/panel.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/grade/new_grades.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/homework/homework_tile.dart';
import 'package:filcnaplo_premium/models/premium_scopes.dart';
import 'package:filcnaplo_premium/providers/premium_provider.dart';
import 'package:filcnaplo_premium/providers/share_provider.dart';
import 'package:filcnaplo_premium/ui/mobile/flutter_colorpicker/colorpicker.dart';
import 'package:filcnaplo_premium/ui/mobile/premium/upsell.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'theme.i18n.dart';
import 'package:share_plus/share_plus.dart';

class PremiumCustomAccentColorSetting extends StatefulWidget {
  const PremiumCustomAccentColorSetting({Key? key}) : super(key: key);

  @override
  State<PremiumCustomAccentColorSetting> createState() =>
      _PremiumCustomAccentColorSettingState();
}

enum CustomColorMode {
  theme,
  saved,
  accent,
  background,
  highlight,
  icon,
  enterId,
}

class _PremiumCustomAccentColorSettingState
    extends State<PremiumCustomAccentColorSetting>
    with TickerProviderStateMixin {
  late final SettingsProvider settings;
  late final ShareProvider shareProvider;
  bool colorSelection = false;
  bool customColorMenu = false;
  CustomColorMode colorMode = CustomColorMode.theme;
  final customColorInput = TextEditingController();
  final unknownColor = Colors.black;

  late TabController _testTabController;
  late TabController _colorsTabController;
  late AnimationController _openAnimController;

  late final Animation<double> backgroundAnimation =
      Tween<double>(begin: 0, end: 1).animate(
    CurvedAnimation(
      parent: _openAnimController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeInOut),
    ),
  );

  late final Animation<double> fullPageAnimation =
      Tween<double>(begin: 0, end: 1).animate(
    CurvedAnimation(
      parent: _openAnimController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
    ),
  );

  late final Animation<double> backContainerAnimation =
      Tween<double>(begin: 100, end: 0).animate(
    CurvedAnimation(
      parent: _openAnimController,
      curve: const Interval(0.0, 0.9, curve: Curves.easeInOut),
    ),
  );

  late final Animation<double> backContentAnimation =
      Tween<double>(begin: 100, end: 0).animate(
    CurvedAnimation(
      parent: _openAnimController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeInOut),
    ),
  );

  late final Animation<double> backContentScaleAnimation =
      Tween<double>(begin: 0.8, end: 0.9).animate(
    CurvedAnimation(
      parent: _openAnimController,
      curve: const Interval(0.45, 1.0, curve: Curves.easeInOut),
    ),
  );

  late final Animation<double> pickerContainerAnimation =
      Tween<double>(begin: 0, end: 1).animate(
    CurvedAnimation(
      parent: _openAnimController,
      curve: const Interval(0.25, 0.8, curve: Curves.easeInOut),
    ),
  );

  @override
  void initState() {
    super.initState();
    _colorsTabController = TabController(length: 5, vsync: this);
    _testTabController = TabController(length: 4, vsync: this);
    settings = Provider.of<SettingsProvider>(context, listen: false);
    shareProvider = Provider.of<ShareProvider>(context, listen: false);

    _openAnimController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 750));
    _openAnimController.forward();
  }

  @override
  void dispose() {
    _openAnimController.dispose();
    super.dispose();
  }

  void setTheme(ThemeMode mode, bool store) async {
    await settings.update(theme: mode, store: store);
    Provider.of<ThemeModeObserver>(context, listen: false)
        .changeTheme(mode, updateNavbarColor: false);
  }

  dynamic getCustomColor() {
    switch (colorMode) {
      case CustomColorMode.theme:
        return accentColorMap[settings.accentColor];
      case CustomColorMode.saved:
        return [
          settings.customBackgroundColor,
          settings.customHighlightColor,
          settings.customAccentColor
        ];
      case CustomColorMode.background:
        return settings.customBackgroundColor;
      case CustomColorMode.highlight:
        return settings.customHighlightColor;
      case CustomColorMode.accent:
        return settings.customAccentColor;
      case CustomColorMode.icon:
        return settings.customIconColor;
      case CustomColorMode.enterId:
        // do nothing here lol
        break;
    }
  }

  void updateCustomColor(dynamic v, bool store,
      {Color? accent, Color? background, Color? panels, Color? icon}) {
    if (colorMode != CustomColorMode.theme) {
      settings.update(accentColor: AccentColor.custom, store: store);
    }
    switch (colorMode) {
      case CustomColorMode.theme:
        settings.update(
            accentColor: accentColorMap.keys.firstWhere(
                (element) => accentColorMap[element] == v,
                orElse: () => AccentColor.filc),
            store: store);
        settings.update(
            customBackgroundColor: AppColors.of(context).background,
            store: store);
        settings.update(
            customHighlightColor: AppColors.of(context).highlight,
            store: store);
        settings.update(customAccentColor: v, store: store);
        break;
      case CustomColorMode.saved:
        settings.update(customBackgroundColor: v[0], store: store);
        settings.update(customHighlightColor: v[1], store: store);
        settings.update(customAccentColor: v[3], store: store);
        break;
      case CustomColorMode.background:
        settings.update(customBackgroundColor: v, store: store);
        break;
      case CustomColorMode.highlight:
        settings.update(customHighlightColor: v, store: store);
        break;
      case CustomColorMode.accent:
        settings.update(customAccentColor: v, store: store);
        break;
      case CustomColorMode.icon:
        settings.update(customIconColor: v, store: store);
        break;
      case CustomColorMode.enterId:
        settings.update(customBackgroundColor: background, store: store);
        settings.update(customHighlightColor: panels, store: store);
        settings.update(customAccentColor: accent, store: store);
        settings.update(customIconColor: icon, store: store);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool hasAccess = Provider.of<PremiumProvider>(context)
        .hasScope(PremiumScopes.customColors);
    bool isBackgroundDifferent = Theme.of(context).colorScheme.background !=
        AppColors.of(context).background;

    ThemeMode currentTheme = Theme.of(context).brightness == Brightness.light
        ? ThemeMode.light
        : ThemeMode.dark;

    return WillPopScope(
      onWillPop: () async {
        Provider.of<ThemeModeObserver>(context, listen: false)
            .changeTheme(settings.theme, updateNavbarColor: true);
        return true;
      },
      child: AnimatedBuilder(
        animation: _openAnimController,
        builder: (context, child) {
          final backgroundGradientBottomColor = isBackgroundDifferent
              ? Theme.of(context).colorScheme.background
              : HSVColor.fromColor(Theme.of(context).colorScheme.background)
                  .withValue(currentTheme == ThemeMode.dark
                      ? 0.1 * _openAnimController.value
                      : 1.0 - (0.1 * _openAnimController.value))
                  .withAlpha(1.0)
                  .toColor();

          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            systemNavigationBarColor: backgroundGradientBottomColor,
          ));

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.75],
                colors: isBackgroundDifferent
                    ? [
                        Theme.of(context).colorScheme.background.withOpacity(1 -
                            ((currentTheme == ThemeMode.dark ? 0.65 : 0.45) *
                                backgroundAnimation.value)),
                        backgroundGradientBottomColor,
                      ]
                    : [
                        backgroundGradientBottomColor,
                        backgroundGradientBottomColor
                      ],
              ),
            ),
            child: Opacity(
              opacity: fullPageAnimation.value,
              child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
                  leading: BackButton(color: AppColors.of(context).text),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: IconButton(
                        focusColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onPressed: () async {
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   const SnackBar(
                          //     duration: Duration(milliseconds: 1000),
                          //     content: Text(
                          //       "Hamarosan...",
                          //     ),
                          //   ),
                          // );
                          showDialog(
                            context: context,
                            builder: (context) => WillPopScope(
                              onWillPop: () async => false,
                              child: AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0)),
                                title: Text("attention".i18n),
                                content: Text("share_disclaimer".i18n),
                                actions: [
                                  ActionButton(
                                    label: "understand".i18n,
                                    onTap: () async {
                                      Navigator.of(context).pop();

                                      SharedGradeColors gradeColors =
                                          await shareProvider
                                              .shareCurrentGradeColors(context);
                                      SharedTheme theme =
                                          await shareProvider.shareCurrentTheme(
                                        context,
                                        gradeColors: gradeColors,
                                      );

                                      Share.share(
                                        theme.id,
                                        subject: 'share_subj_theme'.i18n,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        icon: const Icon(
                          FeatherIcons.share2,
                          size: 22.0,
                        ),
                      ),
                    ),
                  ],
                  title: Text(
                    "theme_prev".i18n,
                    style: TextStyle(color: AppColors.of(context).text),
                  ),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
                body: Stack(
                  children: [
                    Opacity(
                      opacity: 1 - backContainerAnimation.value * (1 / 100),
                      child: Transform.translate(
                        offset: Offset(0, backContainerAnimation.value),
                        child: Container(
                          height: double.infinity,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            gradient: LinearGradient(
                                // https://discord.com/channels/1111649116020285532/1153619667848548452
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                stops: const [
                                  0.35,
                                  0.75
                                ],
                                colors: [
                                  settings.customBackgroundColor ??
                                      Theme.of(context).colorScheme.background,
                                  isBackgroundDifferent
                                      ? HSVColor.fromColor(Theme.of(context)
                                              .colorScheme
                                              .background)
                                          .withSaturation((HSVColor.fromColor(
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .background)
                                                      .saturation -
                                                  0.15)
                                              .clamp(0.0, 1.0))
                                          .toColor()
                                      : backgroundGradientBottomColor,
                                ]),
                          ),
                          margin: const EdgeInsets.symmetric(
                              vertical: 30, horizontal: 20),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: Opacity(
                            opacity: 1 - backContentAnimation.value * (1 / 100),
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Transform.translate(
                                offset:
                                    Offset(0, -24 + backContentAnimation.value),
                                child: Transform.scale(
                                  scale: backContentScaleAnimation.value,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 32.0, vertical: 6.0),
                                        child: FilterBar(
                                          items: const [
                                            Tab(text: "All"),
                                            Tab(text: "Grades"),
                                            Tab(text: "Messages"),
                                            Tab(text: "Absences"),
                                          ],
                                          controller: _testTabController,
                                          padding: EdgeInsets.zero,
                                          censored: true,
                                          disableFading: true,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 18.0, vertical: 8.0),
                                        child: NewGradesSurprise(
                                          [
                                            Grade.fromJson(
                                              {
                                                "Uid": "0,Ertekeles",
                                                "RogzitesDatuma":
                                                    "2022-01-01T23:00:00Z",
                                                "KeszitesDatuma":
                                                    "2022-01-01T23:00:00Z",
                                                "LattamozasDatuma": null,
                                                "Tantargy": {
                                                  "Uid": "0",
                                                  "Nev": "reFilc szakirodalom",
                                                  "Kategoria": {
                                                    "Uid": "0,_",
                                                    "Nev": "_",
                                                    "Leiras": "Nem mondom meg"
                                                  },
                                                  "SortIndex": 2
                                                },
                                                "Tema":
                                                    "Kupak csomag vásárlás vizsga",
                                                "Tipus": {
                                                  "Uid": "0,_",
                                                  "Nev": "_",
                                                  "Leiras":
                                                      "Évközi jegy/értékelés",
                                                },
                                                "Mod": {
                                                  "Uid": "0,_",
                                                  "Nev": "_",
                                                  "Leiras": "_ feladat",
                                                },
                                                "ErtekFajta": {
                                                  "Uid": "1,Osztalyzat",
                                                  "Nev": "Osztalyzat",
                                                  "Leiras":
                                                      "Elégtelen (1) és Jeles (5) között az öt alapértelmezett érték"
                                                },
                                                "ErtekeloTanarNeve": "Premium",
                                                "Jelleg": "Ertekeles",
                                                "SzamErtek": 5,
                                                "SzovegesErtek": "Jeles(5)",
                                                "SulySzazalekErteke": 100,
                                                "SzovegesErtekelesRovidNev":
                                                    null,
                                                "OsztalyCsoport": {"Uid": "0"},
                                                "SortIndex": 2
                                              },
                                            ),
                                          ],
                                          censored: true,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 24.0, vertical: 6.0),
                                        child: Panel(
                                          child: GradeTile(
                                            Grade.fromJson(
                                              {
                                                "Uid": "0,Ertekeles",
                                                "RogzitesDatuma":
                                                    "2022-01-01T23:00:00Z",
                                                "KeszitesDatuma":
                                                    "2022-01-01T23:00:00Z",
                                                "LattamozasDatuma": null,
                                                "Tantargy": {
                                                  "Uid": "0",
                                                  "Nev": "reFilc szakosztály",
                                                  "Kategoria": {
                                                    "Uid": "0,_",
                                                    "Nev": "_",
                                                    "Leiras": "Nem mondom meg"
                                                  },
                                                  "SortIndex": 2
                                                },
                                                "Tema":
                                                    "Kupak csomag vásárlás vizsga",
                                                "Tipus": {
                                                  "Uid": "0,_",
                                                  "Nev": "_",
                                                  "Leiras":
                                                      "Évközi jegy/értékelés",
                                                },
                                                "Mod": {
                                                  "Uid": "0,_",
                                                  "Nev": "_",
                                                  "Leiras": "_ feladat",
                                                },
                                                "ErtekFajta": {
                                                  "Uid": "1,Osztalyzat",
                                                  "Nev": "Osztalyzat",
                                                  "Leiras":
                                                      "Elégtelen (1) és Jeles (5) között az öt alapértelmezett érték"
                                                },
                                                "ErtekeloTanarNeve": "Premium",
                                                "Jelleg": "Ertekeles",
                                                "SzamErtek": 5,
                                                "SzovegesErtek": "Jeles(5)",
                                                "SulySzazalekErteke": 100,
                                                "SzovegesErtekelesRovidNev":
                                                    null,
                                                "OsztalyCsoport": {"Uid": "0"},
                                                "SortIndex": 2
                                              },
                                            ),
                                            padding: EdgeInsets.zero,
                                            censored: true,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 24.0, vertical: 6.0),
                                        child: Panel(
                                          child: HomeworkTile(
                                            Homework.fromJson(
                                              {
                                                "Uid": "0",
                                                "Tantargy": {
                                                  "Uid": "0",
                                                  "Nev":
                                                      "reFilc premium előnyei",
                                                  "Kategoria": {
                                                    "Uid": "0,_",
                                                    "Nev": "_",
                                                    "Leiras":
                                                        "reFilc premium előnyei",
                                                  },
                                                  "SortIndex": 0
                                                },
                                                "TantargyNeve":
                                                    "reFilc premium előnyei",
                                                "RogzitoTanarNeve":
                                                    "Kupak János",
                                                "Szoveg":
                                                    "45 perc filctollal való rajzolás",
                                                "FeladasDatuma":
                                                    "2022-01-01T23:00:00Z",
                                                "HataridoDatuma":
                                                    "2022-01-01T23:00:00Z",
                                                "RogzitesIdopontja":
                                                    "2022-01-01T23:00:00Z",
                                                "IsTanarRogzitette": true,
                                                "IsTanuloHaziFeladatEnabled":
                                                    false,
                                                "IsMegoldva": false,
                                                "IsBeadhato": false,
                                                "OsztalyCsoport": {"Uid": "0"},
                                                "IsCsatolasEngedelyezes": false
                                              },
                                            ),
                                            padding: EdgeInsets.zero,
                                            censored: true,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 24.0, vertical: 6.0),
                                        child: Panel(
                                          child: MessageTile(
                                            Message.fromJson(
                                              {
                                                "azonosito": 0,
                                                "isElolvasva": true,
                                                "isToroltElem": false,
                                                "tipus": {
                                                  "azonosito": 1,
                                                  "kod": "BEERKEZETT",
                                                  "rovidNev":
                                                      "Beérkezett üzenet",
                                                  "nev": "Beérkezett üzenet",
                                                  "leiras": "Beérkezett üzenet"
                                                },
                                                "uzenet": {
                                                  "azonosito": 0,
                                                  "kuldesDatum":
                                                      "2022-01-01T23:00:00",
                                                  "feladoNev": "reFilc",
                                                  "feladoTitulus":
                                                      "Nagyon magas szintű személy",
                                                  "szoveg":
                                                      "<p>Kedves Felhasználó!</p><p><br></p><p>A prémium vásárlásakor kapott filctollal 90%-al több esély van jó jegyek szerzésére.</p>",
                                                  "targy":
                                                      "Filctoll használati útmutató",
                                                  "statusz": {
                                                    "azonosito": 2,
                                                    "kod": "KIKULDVE",
                                                    "rovidNev": "Kiküldve",
                                                    "nev": "Kiküldve",
                                                    "leiras": "Kiküldve"
                                                  },
                                                  "cimzettLista": [
                                                    {
                                                      "azonosito": 0,
                                                      "kretaAzonosito": 0,
                                                      "nev": "Tinta Józsi",
                                                      "tipus": {
                                                        "azonosito": 0,
                                                        "kod": "TANULO",
                                                        "rovidNev": "Tanuló",
                                                        "nev": "Tanuló",
                                                        "leiras": "Tanuló"
                                                      }
                                                    },
                                                  ],
                                                  "csatolmanyok": [
                                                    {
                                                      "azonosito": 0,
                                                      "fajlNev": "Filctoll.doc"
                                                    }
                                                  ]
                                                }
                                              },
                                            ),
                                            censored: true,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Wrap(
                        children: [
                          Opacity(
                            opacity: pickerContainerAnimation.value,
                            child: SizedBox(
                              width: double.infinity,
                              child: Container(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: backgroundGradientBottomColor,
                                      offset: const Offset(0, -8),
                                      blurRadius: 16,
                                      spreadRadius: 18,
                                    ),
                                  ],
                                  gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      stops: const [
                                        0.0,
                                        0.175
                                      ],
                                      colors: [
                                        backgroundGradientBottomColor,
                                        backgroundGradientBottomColor,
                                      ]),
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: FilterBar(
                                        items: [
                                          ColorTab(
                                              color: accentColorMap[
                                                      settings.accentColor] ??
                                                  unknownColor,
                                              tab: Tab(
                                                  text: "colorpicker_presets"
                                                      .i18n)),
                                          ColorTab(
                                              color: unknownColor,
                                              tab: Tab(text: "enter_id".i18n)),
                                          /*ColorTab(
                                              color:
                                                  settings.customAccentColor ??
                                                      unknownColor,
                                              tab: Tab(
                                                  text: "colorpicker_saved"
                                                      .i18n)),*/
                                          ColorTab(
                                              unlocked: hasAccess,
                                              color: settings
                                                      .customBackgroundColor ??
                                                  unknownColor,
                                              tab: Tab(
                                                  text: "colorpicker_background"
                                                      .i18n)),
                                          ColorTab(
                                              unlocked: hasAccess,
                                              color: settings
                                                      .customHighlightColor ??
                                                  unknownColor,
                                              tab: Tab(
                                                  text: "colorpicker_panels"
                                                      .i18n)),
                                          ColorTab(
                                              unlocked: hasAccess,
                                              color:
                                                  settings.customAccentColor ??
                                                      unknownColor,
                                              tab: Tab(
                                                  text: "colorpicker_accent"
                                                      .i18n)),
                                          // ColorTab(
                                          //     unlocked: hasAccess,
                                          //     color: settings.customIconColor ??
                                          //         unknownColor,
                                          //     tab: Tab(
                                          //         text:
                                          //             "colorpicker_icon".i18n)),
                                        ],
                                        onTap: (index) {
                                          if (!hasAccess) {
                                            index = 0;
                                            _colorsTabController.animateTo(0,
                                                duration: Duration.zero);

                                            PremiumLockedFeatureUpsell.show(
                                                context: context,
                                                feature: PremiumFeature
                                                    .customcolors);
                                          }

                                          switch (index) {
                                            case 0:
                                              setState(() {
                                                colorMode =
                                                    CustomColorMode.theme;
                                              });
                                              break;
                                            case 1:
                                              setState(() {
                                                colorMode =
                                                    CustomColorMode.enterId;
                                              });
                                              break;
                                            /*case 1:
                                              setState(() {
                                                colorMode =
                                                    CustomColorMode.saved;
                                              });
                                              break;*/
                                            case 2:
                                              setState(() {
                                                colorMode =
                                                    CustomColorMode.background;
                                              });
                                              break;
                                            case 3:
                                              setState(() {
                                                colorMode =
                                                    CustomColorMode.highlight;
                                              });
                                              break;
                                            case 4:
                                              setState(() {
                                                colorMode =
                                                    CustomColorMode.accent;
                                              });
                                              break;
                                            case 5:
                                              setState(() {
                                                colorMode =
                                                    CustomColorMode.icon;
                                              });
                                              break;
                                          }
                                        },
                                        controller: _colorsTabController,
                                        padding: EdgeInsets.zero,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0),
                                      child: SafeArea(
                                        child: FilcColorPicker(
                                          colorMode: colorMode,
                                          pickerColor: colorMode ==
                                                  CustomColorMode.accent
                                              ? settings.customAccentColor ??
                                                  unknownColor
                                              : colorMode ==
                                                      CustomColorMode.background
                                                  ? settings
                                                          .customBackgroundColor ??
                                                      unknownColor
                                                  : colorMode ==
                                                          CustomColorMode.theme
                                                      ? (accentColorMap[settings
                                                              .accentColor] ??
                                                          AppColors.of(context)
                                                              .text) // idk what else
                                                      : colorMode ==
                                                              CustomColorMode
                                                                  .highlight
                                                          ? settings
                                                                  .customHighlightColor ??
                                                              unknownColor
                                                          : settings
                                                                  .customIconColor ??
                                                              unknownColor,
                                          onColorChanged: (c) {
                                            setState(() {
                                              updateCustomColor(c, false);
                                            });
                                            setTheme(settings.theme, false);
                                          },
                                          onColorChangeEnd: (c, {adaptive}) {
                                            setState(() {
                                              if (adaptive == true) {
                                                settings.update(
                                                    accentColor:
                                                        AccentColor.adaptive);
                                                settings.update(
                                                    customBackgroundColor:
                                                        AppColors.of(context)
                                                            .background,
                                                    store: true);
                                                settings.update(
                                                    customHighlightColor:
                                                        AppColors.of(context)
                                                            .highlight,
                                                    store: true);
                                                settings.update(
                                                    customIconColor:
                                                        const Color(0x00000000),
                                                    store: true);
                                              } else {
                                                updateCustomColor(c, true);
                                              }
                                            });
                                            setTheme(settings.theme, true);
                                          },
                                          onThemeIdProvided: (theme) {
                                            // changing grade colors
                                            List<Color> colors = [
                                              theme.gradeColors.oneColor,
                                              theme.gradeColors.twoColor,
                                              theme.gradeColors.threeColor,
                                              theme.gradeColors.fourColor,
                                              theme.gradeColors.fiveColor,
                                            ];
                                            settings.update(
                                                gradeColors: colors);

                                            // changing shadow effect
                                            settings.update(
                                                shadowEffect:
                                                    theme.shadowEffect);

                                            // changing theme
                                            setState(() {
                                              updateCustomColor(
                                                null,
                                                true,
                                                accent: theme.accentColor,
                                                background:
                                                    theme.backgroundColor,
                                                panels: theme.panelsColor,
                                                icon: theme.iconColor,
                                              );
                                            });
                                            setTheme(settings.theme, true);
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ColorTab extends StatelessWidget {
  const ColorTab(
      {Key? key, required this.tab, required this.color, this.unlocked = true})
      : super(key: key);

  final Tab tab;
  final Color color;
  final bool unlocked;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Transform.translate(
          offset: const Offset(-3, 1),
          child: unlocked
              ? Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                    border: Border.all(color: Colors.black, width: 2.0),
                  ),
                )
              : const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2),
                  child: Icon(Icons.lock,
                      color: Color.fromARGB(255, 82, 82, 82), size: 18),
                ),
        ),
        tab
      ],
    );
  }
}

class PremiumColorPickerItem extends StatelessWidget {
  const PremiumColorPickerItem(
      {Key? key, required this.label, this.onTap, required this.color})
      : super(key: key);

  final String label;
  final void Function()? onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                      color: AppColors.of(context).text,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                    color: color, shape: BoxShape.circle, border: Border.all()),
              ),
            ],
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
