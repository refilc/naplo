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
import 'package:refilc/api/providers/database_provider.dart';
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
import 'package:refilc_mobile_ui/common/system_chrome.dart';
import 'package:refilc_mobile_ui/common/widgets/update/updates_view.dart';
import 'package:refilc_mobile_ui/screens/news/news_screen.dart';
import 'package:refilc_mobile_ui/screens/settings/accounts/account_tile.dart';
import 'package:refilc_mobile_ui/screens/settings/accounts/account_view.dart';
import 'package:refilc_mobile_ui/screens/settings/debug/subject_icon_gallery.dart';
import 'package:refilc_mobile_ui/screens/settings/notifications_screen.dart';
import 'package:refilc_mobile_ui/screens/settings/privacy_view.dart';
import 'package:refilc_mobile_ui/screens/settings/settings_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart' as tabs;
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'settings_screen.i18n.dart';
import 'package:flutter/services.dart';
import 'package:refilc_premium/ui/mobile/settings/nickname.dart';
import 'package:refilc_premium/ui/mobile/settings/profile_pic.dart';
import 'package:refilc_premium/ui/mobile/settings/icon_pack.dart';
import 'package:refilc_premium/ui/mobile/settings/modify_subject_names.dart';
import 'package:refilc_premium/ui/mobile/settings/modify_teacher_names.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  int devmodeCountdown = 5;
  bool __ss = false; // secret settings

  Future<Map>? futureRelease;

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

      List<String> _nameParts = account.displayName.split(" ");
      if (!settings.presentationMode) {
        _firstName = _nameParts.length > 1 ? _nameParts[1] : _nameParts[0];
      } else {
        _firstName = "János";
      }

      accountTiles.add(
        AccountTile(
          name: Text(!settings.presentationMode ? account.name : "János",
              style: const TextStyle(fontWeight: FontWeight.w500)),
          username: Text(
              !settings.presentationMode ? account.username : "01234567890"),
          profileImage: ProfileImage(
            name: _firstName,
            role: account.role,
            profilePictureString: account.picture,
            backgroundColor: Theme.of(context)
                .colorScheme
                .primary, //!settings.presentationMode
            //? ColorUtils.stringToColor(account.name)
            //: Theme.of(context).colorScheme.secondary,
          ),
          onTap: () {
            user.setUser(account.id);
            restore().then((_) => user.setUser(account.id));
            Navigator.of(context).pop();
          },
          onTapMenu: () => _showBottomSheet(account),
        ),
      );
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
      UserMenuProfilePic(u),
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

  void _openDKT(User u) => tabs.launch(
      "https://dkttanulo.e-kreta.hu/sso?id_token=${kretaClient.idToken}",
      customTabsOption: tabs.CustomTabsOption(
        toolbarColor: Theme.of(context).scaffoldBackgroundColor,
        showPageTitle: true,
      ));

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      futureRelease = Provider.of<UpdateProvider>(context, listen: false)
          .installedVersion();
    });
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

    return AnimatedBuilder(
      animation: _hideContainersController,
      builder: (context, child) => Opacity(
        opacity: 1 - _hideContainersController.value,
        child: Column(
          children: [
            const SizedBox(height: 32.0),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  splashRadius: 32.0,
                  onPressed: () =>
                      _showBottomSheet(user.getUser(user.id ?? "")),
                  icon: Icon(FeatherIcons.moreVertical,
                      color: AppColors.of(context).text.withOpacity(0.8)),
                ),
                IconButton(
                  splashRadius: 26.0,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(FeatherIcons.x,
                      color: AppColors.of(context).text.withOpacity(0.8)),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ProfileImage(
                heroTag: "profile",
                radius: 36.0,
                onTap: () => _showBottomSheet(user.getUser(user.id ?? "")),
                name: firstName,
                badge: updateProvider.available,
                role: user.role,
                profilePictureString: user.picture,
                backgroundColor: Theme.of(context)
                    .colorScheme
                    .primary, //!settings.presentationMode
                //? ColorUtils.stringToColor(user.displayName ?? "?")
                //: Theme.of(context).colorScheme.secondary,
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 12.0),
              child: GestureDetector(
                onTap: () => _showBottomSheet(user.getUser(user.id ?? "")),
                onDoubleTap: () => setState(() => __ss = true),
                child: Text(
                  !settings.presentationMode
                      ? (user.displayName ?? "?")
                      : "János",
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                      color: AppColors.of(context).text),
                ),
              ),
            ),

            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
              child: Panel(
                child: Column(
                  children: [
                    // Account list
                    ...accountTiles,

                    if (accountTiles.isNotEmpty)
                      Center(
                        child: Container(
                          margin: const EdgeInsets.only(top: 12.0, bottom: 4.0),
                          height: 3.0,
                          width: 75.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: AppColors.of(context).text.withOpacity(.25),
                          ),
                        ),
                      ),

                    // Account settings
                    PanelButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed("login_back")
                            .then((value) {
                          setSystemChrome(context);
                        });
                      },
                      title: Text("add_user".i18n),
                      leading: const Icon(FeatherIcons.userPlus),
                    ),
                    PanelButton(
                      onPressed: () async {
                        String? userId = user.id;
                        if (userId == null) return;

                        // Delete User
                        user.removeUser(userId);
                        await Provider.of<DatabaseProvider>(context,
                                listen: false)
                            .store
                            .removeUser(userId);

                        // If no other Users left, go back to LoginScreen
                        if (user.getUsers().isNotEmpty) {
                          user.setUser(user.getUsers().first.id);
                          restore().then(
                              (_) => user.setUser(user.getUsers().first.id));
                        } else {
                          Navigator.of(context)
                              .pushNamedAndRemoveUntil("login", (_) => false);
                        }
                      },
                      title: Text("log_out".i18n),
                      leading: Icon(FeatherIcons.logOut,
                          color: AppColors.of(context).red),
                    ),
                  ],
                ),
              ),
            ),

            // Updates
            if (updateProvider.available)
              Padding(
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
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                ),
              ),

            // const Padding(
            //   padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
            //   child: PremiumBannerButton(),
            // ),
            // if (!context.watch<PremiumProvider>().hasPremium)
            //   const ClipRect(
            //     child: Padding(
            //       padding: EdgeInsets.symmetric(vertical: 12.0),
            //       child: PremiumButton(),
            //     ),
            //   )
            // else
            //   const Padding(
            //     padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
            //     child: ActiveSponsorCard(),
            //   ),

            // General Settings
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
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
                      trailing: Text(
                        languageText,
                        style: const TextStyle(fontSize: 14.0),
                      ),
                    ),
                    PanelButton(
                      onPressed: () {
                        SettingsHelper.startPage(context);
                        setState(() {});
                      },
                      title: Text("startpage".i18n),
                      leading: const Icon(FeatherIcons.play),
                      trailing: Text(
                        startPageTitle.capital(),
                        style: const TextStyle(fontSize: 14.0),
                      ),
                    ),
                    PanelButton(
                      onPressed: () {
                        SettingsHelper.rounding(context);
                        setState(() {});
                      },
                      title: Text("rounding".i18n),
                      leading: const Icon(FeatherIcons.gitCommit),
                      trailing: Text(
                        (settings.rounding / 10).toStringAsFixed(1),
                        style: const TextStyle(fontSize: 14.0),
                      ),
                    ),
                    PanelButton(
                      onPressed: () {
                        SettingsHelper.vibrate(context);
                        setState(() {});
                      },
                      title: Text("vibrate".i18n),
                      leading: const Icon(FeatherIcons.radio),
                      trailing: Text(
                        vibrateTitle,
                        style: const TextStyle(fontSize: 14.0),
                      ),
                    ),
                    PanelButton(
                      padding: const EdgeInsets.only(left: 14.0),
                      onPressed: () {
                        SettingsHelper.bellDelay(context);
                        setState(() {});
                      },
                      title: Text(
                        "bell_delay".i18n,
                        style: TextStyle(
                            color: AppColors.of(context).text.withOpacity(
                                settings.bellDelayEnabled ? 1.0 : .5)),
                      ),
                      leading: settings.bellDelayEnabled
                          ? const Icon(FeatherIcons.bell)
                          : Icon(FeatherIcons.bellOff,
                              color:
                                  AppColors.of(context).text.withOpacity(.25)),
                      trailingDivider: true,
                      trailing: Switch(
                        onChanged: (v) => settings.update(bellDelayEnabled: v),
                        value: settings.bellDelayEnabled,
                        activeColor: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    Material(
                        type: MaterialType.transparency,
                        child: MenuNotifications(settings: settings)),
                  ],
                ),
              ),
            ),

            if (kDebugMode)
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 24.0),
                child: Panel(
                  title: const Text("Debug"),
                  child: Column(
                    children: [
                      PanelButton(
                        title: const Text("Subject Icon Gallery"),
                        leading:
                            const Icon(CupertinoIcons.rectangle_3_offgrid_fill),
                        trailing: const Icon(Icons.arrow_forward),
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).push(
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

            // Secret Settings
            if (__ss)
              Padding(
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
                          contentPadding: const EdgeInsets.only(left: 12.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0)),
                          title: Text("goodstudent".i18n,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500)),
                          onChanged: (v) {
                            if (v) {
                              showDialog(
                                context: context,
                                builder: (context) => WillPopScope(
                                  onWillPop: () async => false,
                                  child: AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0)),
                                    title: Text("attention".i18n),
                                    content:
                                        Text("goodstudent_disclaimer".i18n),
                                    actions: [
                                      ActionButton(
                                          label: "understand".i18n,
                                          onTap: () {
                                            Navigator.of(context).pop();
                                            settings.update(goodStudent: v);
                                            Provider.of<GradeProvider>(context,
                                                    listen: false)
                                                .convertBySettings();
                                          })
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              settings.update(goodStudent: v);
                              Provider.of<GradeProvider>(context, listen: false)
                                  .convertBySettings();
                            }
                          },
                          value: settings.goodStudent,
                          activeColor: Theme.of(context).colorScheme.secondary,
                        ),
                      ),

                      // Presentation mode
                      Material(
                        type: MaterialType.transparency,
                        child: SwitchListTile(
                          contentPadding: const EdgeInsets.only(left: 12.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0)),
                          title: Text("presentation".i18n,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500)),
                          onChanged: (v) =>
                              settings.update(presentationMode: v),
                          value: settings.presentationMode,
                          activeColor: Theme.of(context).colorScheme.secondary,
                        ),
                      ),

                      // UwU-fied mode (why????)
                      // Material(
                      //   type: MaterialType.transparency,
                      //   child: SwitchListTile(
                      //     contentPadding: const EdgeInsets.only(left: 12.0),
                      //     shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(12.0)),
                      //     title: Text("uwufymode".i18n,
                      //         style:
                      //             const TextStyle(fontWeight: FontWeight.w500)),
                      //     onChanged: (v) {
                      //       SettingsHelper.uwuMode(context, v);
                      //       setState(() {});
                      //     },
                      //     value: settings.presentationMode,
                      //     activeColor: Theme.of(context).colorScheme.secondary,
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),

            // Theme Settings
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
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
                      trailing: Text(
                        themeModeText,
                        style: const TextStyle(fontSize: 14.0),
                      ),
                    ),
                    PanelButton(
                      onPressed: () async {
                        await _hideContainersController.forward();
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
                          color: Theme.of(context).colorScheme.secondary,
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
                            margin: const EdgeInsets.only(left: 2.0),
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
                        contentPadding: const EdgeInsets.only(left: 12.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0)),
                        title: Row(
                          children: [
                            Icon(
                              FeatherIcons.barChart,
                              color: settings.graphClassAvg
                                  ? Theme.of(context).colorScheme.secondary
                                  : AppColors.of(context).text.withOpacity(.25),
                            ),
                            const SizedBox(width: 14.0),
                            Expanded(
                              child: Text(
                                "graph_class_avg".i18n,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.0,
                                  color: AppColors.of(context).text.withOpacity(
                                      settings.graphClassAvg ? 1.0 : .5),
                                ),
                              ),
                            ),
                          ],
                        ),
                        onChanged: (v) => settings.update(graphClassAvg: v),
                        value: settings.graphClassAvg,
                        activeColor: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    const PremiumIconPackSelector(),
                    // If iOS, show the iOS specific settings

                    if (defaultTargetPlatform == TargetPlatform.iOS)
                      PanelButton(
                        onPressed: () {
                          SettingsHelper.liveActivityColor(context);
                          setState(() {});
                        },
                        title: Text("live_activity_color".i18n),
                        leading: const Icon(FeatherIcons.activity),
                        trailing: Container(
                          width: 12.0,
                          height: 12.0,
                          decoration: BoxDecoration(
                            color: settings.liveActivityColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Notifications
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
              child: Panel(
                title: Text("popups".i18n),
                child: Material(
                  type: MaterialType.transparency,
                  child: SwitchListTile(
                    contentPadding: const EdgeInsets.only(left: 12.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                    title: Row(
                      children: [
                        Icon(
                          Icons.newspaper_outlined,
                          color: settings.newsEnabled
                              ? Theme.of(context).colorScheme.secondary
                              : AppColors.of(context).text.withOpacity(.25),
                        ),
                        const SizedBox(width: 14.0),
                        Expanded(
                          child: Text(
                            "news".i18n,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0,
                              color: AppColors.of(context)
                                  .text
                                  .withOpacity(settings.newsEnabled ? 1.0 : .5),
                            ),
                          ),
                        ),
                      ],
                    ),
                    onChanged: (v) => settings.update(newsEnabled: v),
                    value: settings.newsEnabled,
                    activeColor: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            ),

            // Extras
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
              child: Panel(
                title: Text("extras".i18n),
                child: Column(
                  children: [
                    Material(
                      type: MaterialType.transparency,
                      child: SwitchListTile(
                        contentPadding: const EdgeInsets.only(left: 12.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0)),
                        title: Row(
                          children: [
                            Icon(
                              FeatherIcons.gift,
                              color: settings.gradeOpeningFun
                                  ? Theme.of(context).colorScheme.secondary
                                  : AppColors.of(context).text.withOpacity(.25),
                            ),
                            const SizedBox(width: 14.0),
                            Expanded(
                              child: Text(
                                "surprise_grades".i18n,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.0,
                                  color: AppColors.of(context).text.withOpacity(
                                      settings.gradeOpeningFun ? 1.0 : .5),
                                ),
                              ),
                            ),
                          ],
                        ),
                        onChanged: (v) => settings.update(gradeOpeningFun: v),
                        value: settings.gradeOpeningFun,
                        activeColor: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    MenuRenamedSubjects(
                      settings: settings,
                    ),
                    MenuRenamedTeachers(
                      settings: settings,
                    ),
                  ],
                ),
              ),
            ),

            // About
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
              child: Panel(
                title: Text("about".i18n),
                child: Column(children: [
                  PanelButton(
                    leading: const Icon(FeatherIcons.mail),
                    title: Text("news".i18n),
                    onPressed: () => _openNews(context),
                  ),
                  PanelButton(
                    leading: const Icon(FeatherIcons.lock),
                    title: Text("privacy".i18n),
                    // onPressed: () => launchUrl(
                    //     Uri.parse("https://refilc.hu/privacy-policy"),
                    //     mode: LaunchMode.inAppWebView),
                    onPressed: () => _openPrivacy(context),
                  ),
                  PanelButton(
                    leading: const Icon(FeatherIcons.atSign),
                    title: const Text("Discord"),
                    onPressed: () => launchUrl(
                        Uri.parse("https://dc.refilc.hu"),
                        mode: LaunchMode.externalApplication),
                  ),
                  PanelButton(
                    leading: const Icon(FeatherIcons.globe),
                    title: const Text("www.refilc.hu"),
                    onPressed: () => launchUrl(
                        Uri.parse("https://www.refilc.hu"),
                        mode: LaunchMode.externalApplication),
                  ),
                  PanelButton(
                    leading: const Icon(FeatherIcons.github),
                    title: const Text("Github"),
                    onPressed: () => launchUrl(
                        Uri.parse("https://github.com/refilc"),
                        mode: LaunchMode.externalApplication),
                  ),
                  PanelButton(
                    leading: const Icon(FeatherIcons.award),
                    title: Text("licenses".i18n),
                    onPressed: () => showLicensePage(context: context),
                  ),
                  Tooltip(
                    message: "data_collected".i18n,
                    padding: const EdgeInsets.all(4.0),
                    textStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: AppColors.of(context).text),
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background),
                    child: Material(
                      type: MaterialType.transparency,
                      child: SwitchListTile(
                        contentPadding: const EdgeInsets.only(left: 12.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0)),
                        secondary: Icon(
                          FeatherIcons.barChart2,
                          color: settings.xFilcId != "none"
                              ? Theme.of(context).colorScheme.secondary
                              : AppColors.of(context).text.withOpacity(.25),
                        ),
                        title: Text(
                          "Analytics".i18n,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                            color: AppColors.of(context).text.withOpacity(
                                settings.xFilcId != "none" ? 1.0 : .5),
                          ),
                        ),
                        subtitle: Text(
                          "Anonymous Usage Analytics".i18n,
                          style: TextStyle(
                            color: AppColors.of(context).text.withOpacity(
                                settings.xFilcId != "none" ? .5 : .2),
                          ),
                        ),
                        onChanged: (v) {
                          String newId;
                          if (v == false) {
                            newId = "none";
                          } else if (settings.xFilcId == "none") {
                            newId = SettingsProvider.defaultSettings().xFilcId;
                          } else {
                            newId = settings.xFilcId;
                          }
                          settings.update(xFilcId: newId);
                        },
                        value: settings.xFilcId != "none",
                        activeColor: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                ]),
              ),
            ),
            if (settings.developerMode)
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 24.0),
                child: Panel(
                  title: Text("devsettings".i18n),
                  child: Column(
                    children: [
                      Material(
                        type: MaterialType.transparency,
                        child: SwitchListTile(
                          contentPadding: const EdgeInsets.only(left: 12.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0)),
                          title: Text("devmode".i18n,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500)),
                          onChanged: (v) =>
                              settings.update(developerMode: false),
                          value: settings.developerMode,
                          activeColor: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      PanelButton(
                        leading: const Icon(FeatherIcons.copy),
                        title: Text("copy_jwt".i18n),
                        onPressed: () => Clipboard.setData(ClipboardData(
                            text:
                                Provider.of<KretaClient>(context, listen: false)
                                    .accessToken!)),
                      ),
                      // if (Provider.of<PremiumProvider>(context, listen: false)
                      //     .hasPremium)
                      //   PanelButton(
                      //     leading: const Icon(FeatherIcons.key),
                      //     title: const Text("Remove Premium"),
                      //     onPressed: () {
                      //       Provider.of<PremiumProvider>(context, listen: false)
                      //           .activate(removePremium: true);
                      //       settings.update(
                      //           accentColor: AccentColor.filc, store: true);
                      //       Provider.of<ThemeModeObserver>(context,
                      //               listen: false)
                      //           .changeTheme(settings.theme);
                      //     },
                      //   ),
                    ],
                  ),
                ),
              ),
            SafeArea(
              top: false,
              child: Center(
                child: GestureDetector(
                  child: FutureBuilder<Map>(
                    future: futureRelease,
                    builder: (context, release) {
                      if (release.hasData) {
                        return DefaultTextStyle(
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.of(context)
                                      .text
                                      .withOpacity(0.65)),
                          child: Text("v${release.data!['version']}"),
                        );
                      } else {
                        String envAppVer = const String.fromEnvironment(
                            "APPVER",
                            defaultValue: "?");
                        return DefaultTextStyle(
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.of(context)
                                      .text
                                      .withOpacity(0.65)),
                          child: Text("v$envAppVer"),
                        );
                      }
                    },
                  ),
                  onTap: () {
                    if (devmodeCountdown > 0) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        duration: const Duration(milliseconds: 200),
                        content:
                            Text("devmoretaps".i18n.fill([devmodeCountdown])),
                      ));

                      setState(() => devmodeCountdown--);
                    } else if (devmodeCountdown == 0) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("devactivated".i18n),
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
    );
  }

  void _openNews(BuildContext context) =>
      Navigator.of(context, rootNavigator: true)
          .push(CupertinoPageRoute(builder: (context) => const NewsScreen()));
  void _openUpdates(BuildContext context) =>
      UpdateView.show(updateProvider.releases.first, context: context);
  void _openPrivacy(BuildContext context) => PrivacyView.show(context);
}
