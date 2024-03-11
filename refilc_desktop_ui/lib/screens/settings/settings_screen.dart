// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:refilc/api/providers/update_provider.dart';
import 'package:refilc_kreta_api/providers/absence_provider.dart';
import 'package:refilc_kreta_api/providers/event_provider.dart';
import 'package:refilc_kreta_api/providers/exam_provider.dart';
import 'package:refilc_kreta_api/providers/grade_provider.dart';
import 'package:refilc_kreta_api/providers/homework_provider.dart';
import 'package:refilc_kreta_api/providers/message_provider.dart';
import 'package:refilc_kreta_api/providers/note_provider.dart';
import 'package:refilc_kreta_api/providers/timetable_provider.dart';
import 'package:refilc/api/providers/user_provider.dart';
import 'package:refilc/utils/format.dart';
import 'package:refilc/models/settings.dart';
import 'package:refilc/models/user.dart';
import 'package:refilc/theme/colors/colors.dart';
import 'package:refilc_kreta_api/client/client.dart';
import 'package:refilc_mobile_ui/common/action_button.dart';
import 'package:refilc_mobile_ui/common/bottom_sheet_menu/bottom_sheet_menu.dart';
import 'package:refilc_mobile_ui/common/bottom_sheet_menu/bottom_sheet_menu_item.dart';
import 'package:refilc_mobile_ui/common/panel/panel.dart';
import 'package:refilc_mobile_ui/common/panel/panel_button.dart';
import 'package:refilc_mobile_ui/common/profile_image/profile_image.dart';
import 'package:refilc_mobile_ui/common/widgets/update/updates_view.dart';
import 'package:refilc_mobile_ui/premium/premium_button.dart';
import 'package:refilc_mobile_ui/screens/news/news_screen.dart';
import 'package:refilc_mobile_ui/screens/settings/accounts/account_tile.dart';
import 'package:refilc_mobile_ui/screens/settings/accounts/account_view.dart';
import 'package:refilc_mobile_ui/screens/settings/debug/subject_icon_gallery.dart';
import 'package:refilc_mobile_ui/screens/settings/privacy_view.dart';
import 'package:refilc_mobile_ui/screens/settings/settings_helper.dart';
import 'package:refilc_plus/providers/premium_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart' as tabs;
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'settings_screen.i18n.dart';
import 'package:flutter/services.dart';
import 'package:refilc_mobile_ui/screens/settings/user/nickname.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  int devmodeCountdown = 3;
  final bool __ss = false; // secret settings

  late UserProvider user;
  late UpdateProvider updateProvider;
  late SettingsProvider settings;
  late KretaClient kretaClient;
  late String firstName;
  List<Widget> accountTiles = [];

  late AnimationController _hideContainersController;

  Future<void> restore() => Future.wait([
        Provider.of<GradeProvider>(context, listen: false).restore(),
        Provider.of<TimetableProvider>(context, listen: false).restoreUser(),
        Provider.of<ExamProvider>(context, listen: false).restore(),
        Provider.of<HomeworkProvider>(context, listen: false).restore(),
        Provider.of<MessageProvider>(context, listen: false).restore(),
        Provider.of<MessageProvider>(context, listen: false)
            .restoreRecipients(),
        Provider.of<NoteProvider>(context, listen: false).restore(),
        Provider.of<EventProvider>(context, listen: false).restore(),
        Provider.of<AbsenceProvider>(context, listen: false).restore(),
        Provider.of<KretaClient>(context, listen: false).refreshLogin(),
      ]);

  void buildAccountTiles() {
    accountTiles = [];
    user.getUsers().forEach((account) {
      if (account.id == user.id) return;

      String _firstName;

      List<String> _nameParts = user.displayName?.split(" ") ?? ["?"];
      if (!settings.presentationMode) {
        _firstName = _nameParts.length > 1 ? _nameParts[1] : _nameParts[0];
      } else {
        _firstName = "János";
      }

      accountTiles.add(AccountTile(
        name: Text(!settings.presentationMode ? account.name : "János",
            style: const TextStyle(fontWeight: FontWeight.w500)),
        username:
            Text(!settings.presentationMode ? account.username : "72469696969"),
        profileImage: ProfileImage(
          name: _firstName,
          backgroundColor: Theme.of(context)
              .colorScheme
              .secondary, //!settings.presentationMode
          //? ColorUtils.stringToColor(account.name)
          //: Theme.of(context).colorScheme.secondary,
          role: account.role,
        ),
        onTap: () {
          user.setUser(account.id);
          restore().then((_) => user.setUser(account.id));
          Navigator.of(context).pop();
        },
        onTapMenu: () => _showBottomSheet(account),
      ));
    });
  }

  void _showBottomSheet(User u) {
    showBottomSheetMenu(context, items: [
      BottomSheetMenuItem(
        onPressed: () => AccountView.show(u, context: context),
        icon: const Icon(FeatherIcons.user),
        title: Text("personal_details".i18n),
      ),
      BottomSheetMenuItem(
        onPressed: () => _openDKT(u),
        icon: Icon(FeatherIcons.grid, color: AppColors.of(context).teal),
        title: Text("open_dkt".i18n),
      ),
      UserMenuNickname(u),
      // BottomSheetMenuItem(
      //   onPressed: () {},
      //   icon: Icon(FeatherIcons.camera),
      //   title: Text("edit_profile_picture".i18n),
      // ),
      // BottomSheetMenuItem(
      //   onPressed: () {},
      //   icon: Icon(FeatherIcons.trash2, color: AppColors.of(context).red),
      //   title: Text("remove_profile_picture".i18n),
      // ),
    ]);
  }

  void _openDKT(User u) => tabs.launchUrl(
        Uri.parse(
            "https://dkttanulo.e-kreta.hu/sso?id_token=${kretaClient.idToken}"),
        customTabsOptions: tabs.CustomTabsOptions(
          showTitle: true,
          colorSchemes: tabs.CustomTabsColorSchemes(
            defaultPrams: tabs.CustomTabsColorSchemeParams(
              toolbarColor: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
        ),
      );

  @override
  void initState() {
    super.initState();
    _hideContainersController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context);
    settings = Provider.of<SettingsProvider>(context);
    updateProvider = Provider.of<UpdateProvider>(context);
    kretaClient = Provider.of<KretaClient>(context);

    List<String> nameParts = user.displayName?.split(" ") ?? ["?"];
    if (!settings.presentationMode) {
      firstName = nameParts.length > 1 ? nameParts[1] : nameParts[0];
    } else {
      firstName = "János";
    }

    String startPageTitle =
        SettingsHelper.localizedPageTitles()[settings.startPage] ?? "?";
    String themeModeText = {
          ThemeMode.light: "light".i18n,
          ThemeMode.dark: "dark".i18n,
          ThemeMode.system: "system".i18n
        }[settings.theme] ??
        "?";
    String languageText = SettingsHelper.langMap[settings.language] ?? "?";
    String vibrateTitle = {
          VibrationStrength.off: "voff".i18n,
          VibrationStrength.light: "vlight".i18n,
          VibrationStrength.medium: "vmedium".i18n,
          VibrationStrength.strong: "vstrong".i18n,
        }[settings.vibrate] ??
        "?";

    buildAccountTiles();

    if (settings.developerMode) devmodeCountdown = -1;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 11.5),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              floating: true,
              snap: false,
              centerTitle: false,
              title: const Text("Settings"),
              surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
            ),
            SliverToBoxAdapter(
              child: AnimatedBuilder(
                animation: _hideContainersController,
                builder: (context, child) => Opacity(
                  opacity: 1 - _hideContainersController.value,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StaggeredGrid.extent(
                        // direction: Axis.horizontal,
                        // crossAxisCount: 3,
                        maxCrossAxisExtent: 600,
                        children: [
                          const SizedBox(height: 32.0),

                          // Updates
                          if (updateProvider.available)
                            Container(
                              constraints: const BoxConstraints(maxWidth: 500),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 24.0),
                                child: Panel(
                                  child: PanelButton(
                                    onPressed: () => _openUpdates(context),
                                    title: Text("update_available".i18n),
                                    leading: const Icon(FeatherIcons.download),
                                    trailing: Text(
                                      updateProvider.releases.first.tag,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                          // const Padding(
                          //   padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                          //   child: PremiumBannerButton(),
                          // ),
                          if (!Provider.of<PremiumProvider>(context).hasPremium)
                            const ClipRect(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 12.0),
                                child: PremiumButton(),
                              ),
                            ),

                          // General Settings
                          Container(
                            constraints: const BoxConstraints(maxWidth: 500),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 24.0),
                              child: Panel(
                                title: Text("general".i18n),
                                child: Column(
                                  children: [
                                    PanelButton(
                                      onPressed: () {
                                        SettingsHelper.language(context);
                                        setState(() {});
                                      },
                                      title: Text("language".i18n),
                                      leading: const Icon(FeatherIcons.globe),
                                      trailing: Text(languageText),
                                    ),
                                    PanelButton(
                                      onPressed: () {
                                        SettingsHelper.startPage(context);
                                        setState(() {});
                                      },
                                      title: Text("startpage".i18n),
                                      leading: const Icon(FeatherIcons.play),
                                      trailing: Text(startPageTitle.capital()),
                                    ),
                                    PanelButton(
                                      onPressed: () {
                                        SettingsHelper.rounding(context);
                                        setState(() {});
                                      },
                                      title: Text("rounding".i18n),
                                      leading:
                                          const Icon(FeatherIcons.gitCommit),
                                      trailing: Text((settings.rounding / 10)
                                          .toStringAsFixed(1)),
                                    ),
                                    PanelButton(
                                      onPressed: () {
                                        SettingsHelper.vibrate(context);
                                        setState(() {});
                                      },
                                      title: Text("vibrate".i18n),
                                      leading: const Icon(FeatherIcons.radio),
                                      trailing: Text(vibrateTitle),
                                    ),
                                    PanelButton(
                                      padding:
                                          const EdgeInsets.only(left: 14.0),
                                      onPressed: () {
                                        SettingsHelper.bellDelay(context);
                                        setState(() {});
                                      },
                                      title: Text(
                                        "bell_delay".i18n,
                                        style: TextStyle(
                                            color: AppColors.of(context)
                                                .text
                                                .withOpacity(
                                                    settings.bellDelayEnabled
                                                        ? 1.0
                                                        : .5)),
                                      ),
                                      leading: settings.bellDelayEnabled
                                          ? const Icon(FeatherIcons.bell)
                                          : Icon(FeatherIcons.bellOff,
                                              color: AppColors.of(context)
                                                  .text
                                                  .withOpacity(.25)),
                                      trailingDivider: true,
                                      trailing: Switch(
                                        onChanged: (v) => settings.update(
                                            bellDelayEnabled: v),
                                        value: settings.bellDelayEnabled,
                                        activeColor: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          if (kDebugMode)
                            Container(
                              constraints: const BoxConstraints(maxWidth: 500),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 24.0),
                                child: Panel(
                                  title: const Text("Debug"),
                                  child: Column(
                                    children: [
                                      PanelButton(
                                        title:
                                            const Text("Subject Icon Gallery"),
                                        leading: const Icon(CupertinoIcons
                                            .rectangle_3_offgrid_fill),
                                        trailing:
                                            const Icon(Icons.arrow_forward),
                                        onPressed: () {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .push(
                                            CupertinoPageRoute(
                                                builder: (context) =>
                                                    const SubjectIconGallery()),
                                          );
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),

                          // Secret Settings
                          if (__ss)
                            Container(
                              constraints: const BoxConstraints(maxWidth: 500),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 24.0),
                                child: Panel(
                                  title: Text("secret".i18n),
                                  child: Column(
                                    children: [
                                      // Good student mode
                                      Material(
                                        type: MaterialType.transparency,
                                        child: SwitchListTile(
                                          contentPadding:
                                              const EdgeInsets.only(left: 12.0),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.0)),
                                          title: Text("goodstudent".i18n,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500)),
                                          onChanged: (v) {
                                            if (v) {
                                              showDialog(
                                                context: context,
                                                builder: (context) => PopScope(
                                                  onPopInvoked: (didPop) =>
                                                      false,
                                                  child: AlertDialog(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12.0)),
                                                    title:
                                                        Text("attention".i18n),
                                                    content: Text(
                                                        "goodstudent_disclaimer"
                                                            .i18n),
                                                    actions: [
                                                      ActionButton(
                                                          label:
                                                              "understand".i18n,
                                                          onTap: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            settings.update(
                                                                goodStudent: v);
                                                            Provider.of<GradeProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .fetch();
                                                          })
                                                    ],
                                                  ),
                                                ),
                                              );
                                            } else {
                                              settings.update(goodStudent: v);
                                              Provider.of<GradeProvider>(
                                                      context,
                                                      listen: false)
                                                  .fetch();
                                            }
                                          },
                                          value: settings.goodStudent,
                                          activeColor: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                      ),

                                      // Presentation mode
                                      Material(
                                        type: MaterialType.transparency,
                                        child: SwitchListTile(
                                          contentPadding:
                                              const EdgeInsets.only(left: 12.0),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.0)),
                                          title: const Text("Presentation Mode",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500)),
                                          onChanged: (v) => settings.update(
                                              presentationMode: v),
                                          value: settings.presentationMode,
                                          activeColor: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                          // Theme Settings
                          Container(
                            constraints: const BoxConstraints(maxWidth: 500),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 24.0),
                              child: Panel(
                                title: Text("appearance".i18n),
                                child: Column(
                                  children: [
                                    PanelButton(
                                      onPressed: () {
                                        SettingsHelper.theme(context);
                                        setState(() {});
                                      },
                                      title: Text("theme".i18n),
                                      leading: const Icon(FeatherIcons.sun),
                                      trailing: Text(themeModeText),
                                    ),
                                    PanelButton(
                                      onPressed: () async {
                                        await _hideContainersController
                                            .forward();
                                        // ignore: use_build_context_synchronously
                                        SettingsHelper.accentColor(context);
                                        setState(() {});
                                        _hideContainersController.reset();
                                      },
                                      title: Text("color".i18n),
                                      leading: const Icon(FeatherIcons.droplet),
                                      trailing: Container(
                                        width: 12.0,
                                        height: 12.0,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                    PanelButton(
                                      onPressed: () {
                                        SettingsHelper.gradeColors(context);
                                        setState(() {});
                                      },
                                      title: Text("grade_colors".i18n),
                                      leading: const Icon(FeatherIcons.star),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: List.generate(
                                          5,
                                          (i) => Container(
                                            margin: const EdgeInsets.only(
                                                left: 2.0),
                                            width: 12.0,
                                            height: 12.0,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: settings.gradeColors[i],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Material(
                                      type: MaterialType.transparency,
                                      child: SwitchListTile(
                                        contentPadding:
                                            const EdgeInsets.only(left: 12.0),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0)),
                                        title: Row(
                                          children: [
                                            Icon(
                                              FeatherIcons.barChart,
                                              color: settings.graphClassAvg
                                                  ? Theme.of(context)
                                                      .colorScheme
                                                      .secondary
                                                  : AppColors.of(context)
                                                      .text
                                                      .withOpacity(.25),
                                            ),
                                            const SizedBox(width: 24.0),
                                            Expanded(
                                              child: Text(
                                                "graph_class_avg".i18n,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16.0,
                                                  color: AppColors.of(context)
                                                      .text
                                                      .withOpacity(
                                                          settings.graphClassAvg
                                                              ? 1.0
                                                              : .5),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        onChanged: (v) =>
                                            settings.update(graphClassAvg: v),
                                        value: settings.graphClassAvg,
                                        activeColor: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
                                    // we need icon pack selector here
                                    // const PremiumIconPackSelector(),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // Notifications
                          Container(
                            constraints: const BoxConstraints(maxWidth: 500),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 24.0),
                              child: Panel(
                                title: Text("notifications".i18n),
                                child: Material(
                                  type: MaterialType.transparency,
                                  child: SwitchListTile(
                                    contentPadding:
                                        const EdgeInsets.only(left: 12.0),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0)),
                                    title: Row(
                                      children: [
                                        Icon(
                                          Icons.newspaper_outlined,
                                          color: settings.newsEnabled
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .secondary
                                              : AppColors.of(context)
                                                  .text
                                                  .withOpacity(.25),
                                        ),
                                        const SizedBox(width: 24.0),
                                        Expanded(
                                          child: Text(
                                            "news".i18n,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16.0,
                                              color: AppColors.of(context)
                                                  .text
                                                  .withOpacity(
                                                      settings.newsEnabled
                                                          ? 1.0
                                                          : .5),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    onChanged: (v) =>
                                        settings.update(newsEnabled: v),
                                    value: settings.newsEnabled,
                                    activeColor:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Extras
                          Container(
                            constraints: const BoxConstraints(maxWidth: 500),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 24.0),
                              child: Panel(
                                title: Text("extras".i18n),
                                child: Column(children: [
                                  Material(
                                    type: MaterialType.transparency,
                                    child: SwitchListTile(
                                      contentPadding:
                                          const EdgeInsets.only(left: 12.0),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0)),
                                      title: Row(
                                        children: [
                                          Icon(
                                            FeatherIcons.gift,
                                            color: settings.gradeOpeningFun
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .secondary
                                                : AppColors.of(context)
                                                    .text
                                                    .withOpacity(.25),
                                          ),
                                          const SizedBox(width: 24.0),
                                          Expanded(
                                            child: Text(
                                              "surprise_grades".i18n,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16.0,
                                                color: AppColors.of(context)
                                                    .text
                                                    .withOpacity(
                                                        settings.gradeOpeningFun
                                                            ? 1.0
                                                            : .5),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      onChanged: (v) =>
                                          settings.update(gradeOpeningFun: v),
                                      value: settings.gradeOpeningFun,
                                      activeColor: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                                ]),
                              ),
                            ),
                          ),

                          // About
                          Container(
                            constraints: const BoxConstraints(maxWidth: 500),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 24.0),
                              child: Panel(
                                title: Text("about".i18n),
                                child: Column(children: [
                                  PanelButton(
                                    leading: const Icon(FeatherIcons.atSign),
                                    title: const Text("Discord"),
                                    onPressed: () => launchUrl(
                                        Uri.parse("https://refilc.hu/discord"),
                                        mode: LaunchMode.externalApplication),
                                  ),
                                  PanelButton(
                                    leading: const Icon(FeatherIcons.globe),
                                    title: const Text("www.refilc.hu"),
                                    onPressed: () => launchUrl(
                                        Uri.parse("https://refilc.hu"),
                                        mode: LaunchMode.externalApplication),
                                  ),
                                  PanelButton(
                                    leading: const Icon(FeatherIcons.github),
                                    title: const Text("Github"),
                                    onPressed: () => launchUrl(
                                        Uri.parse("https://github.com/filc"),
                                        mode: LaunchMode.externalApplication),
                                  ),
                                  PanelButton(
                                    leading: const Icon(FeatherIcons.mail),
                                    title: Text("news".i18n),
                                    onPressed: () => _openNews(context),
                                  ),
                                  PanelButton(
                                    leading: const Icon(FeatherIcons.lock),
                                    title: Text("privacy".i18n),
                                    onPressed: () => _openPrivacy(context),
                                  ),
                                  PanelButton(
                                    leading: const Icon(FeatherIcons.award),
                                    title: Text("licenses".i18n),
                                    onPressed: () =>
                                        showLicensePage(context: context),
                                  ),
                                  Tooltip(
                                    message: "data_collected".i18n,
                                    padding: const EdgeInsets.all(4.0),
                                    textStyle: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.of(context).text),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background),
                                    child: Material(
                                      type: MaterialType.transparency,
                                      child: SwitchListTile(
                                        contentPadding:
                                            const EdgeInsets.only(left: 12.0),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0)),
                                        secondary: Icon(
                                          FeatherIcons.barChart2,
                                          color: settings.xFilcId != "none"
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .secondary
                                              : AppColors.of(context)
                                                  .text
                                                  .withOpacity(.25),
                                        ),
                                        title: Text(
                                          "Analytics".i18n,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16.0,
                                            color: AppColors.of(context)
                                                .text
                                                .withOpacity(
                                                    settings.xFilcId != "none"
                                                        ? 1.0
                                                        : .5),
                                          ),
                                        ),
                                        subtitle: Text(
                                          "Anonymous Usage Analytics".i18n,
                                          style: TextStyle(
                                            color: AppColors.of(context)
                                                .text
                                                .withOpacity(
                                                    settings.xFilcId != "none"
                                                        ? .5
                                                        : .2),
                                          ),
                                        ),
                                        onChanged: (v) {
                                          String newId;
                                          if (v == false) {
                                            newId = "none";
                                          } else if (settings.xFilcId ==
                                              "none") {
                                            newId = SettingsProvider
                                                    .defaultSettings()
                                                .xFilcId;
                                          } else {
                                            newId = settings.xFilcId;
                                          }
                                          settings.update(xFilcId: newId);
                                        },
                                        value: settings.xFilcId != "none",
                                        activeColor: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
                                  ),
                                ]),
                              ),
                            ),
                          ),
                          if (settings.developerMode)
                            Container(
                              constraints: const BoxConstraints(maxWidth: 500),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 24.0),
                                child: Panel(
                                  title: const Text("Developer Settings"),
                                  child: Column(
                                    children: [
                                      Material(
                                        type: MaterialType.transparency,
                                        child: SwitchListTile(
                                          contentPadding:
                                              const EdgeInsets.only(left: 12.0),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.0)),
                                          title: const Text("Developer Mode",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500)),
                                          onChanged: (v) => settings.update(
                                              developerMode: false),
                                          value: settings.developerMode,
                                          activeColor: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                      ),
                                      PanelButton(
                                        leading: const Icon(FeatherIcons.copy),
                                        title: const Text("Copy JWT"),
                                        onPressed: () => Clipboard.setData(
                                            ClipboardData(
                                                text: Provider.of<KretaClient>(
                                                        context,
                                                        listen: false)
                                                    .accessToken!)),
                                      ),
                                      // if (Provider.of<PremiumProvider>(context,
                                      //         listen: false)
                                      //     .hasPremium)
                                      //   PanelButton(
                                      //     leading: const Icon(FeatherIcons.key),
                                      //     title: const Text("Remove Premium"),
                                      //     onPressed: () {
                                      //       Provider.of<PremiumProvider>(
                                      //               context,
                                      //               listen: false)
                                      //           .activate(removePremium: true);
                                      //       settings.update(
                                      //           accentColor: AccentColor.filc,
                                      //           store: true);
                                      //       Provider.of<ThemeModeObserver>(
                                      //               context,
                                      //               listen: false)
                                      //           .changeTheme(settings.theme);
                                      //     },
                                      //   ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      SafeArea(
                        top: false,
                        child: Center(
                          child: GestureDetector(
                            child: const Panel(
                                title: Text("v${const String.fromEnvironment("APPVER",
                                        defaultValue: "?")}")),
                            onTap: () {
                              if (devmodeCountdown > 0) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  duration: const Duration(milliseconds: 200),
                                  content: Text(
                                      "You are $devmodeCountdown taps away from Developer Mode."),
                                ));

                                setState(() => devmodeCountdown--);
                              } else if (devmodeCountdown == 0) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text(
                                      "Developer Mode successfully activated."),
                                ));

                                settings.update(developerMode: true);

                                setState(() => devmodeCountdown--);
                              }
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
    );
  }

  void _openNews(BuildContext context) =>
      Navigator.of(context, rootNavigator: true)
          .push(CupertinoPageRoute(builder: (context) => const NewsScreen()));
  void _openUpdates(BuildContext context) =>
      UpdateView.show(updateProvider.releases.first, context: context);
  void _openPrivacy(BuildContext context) => PrivacyView.show(context);
}
