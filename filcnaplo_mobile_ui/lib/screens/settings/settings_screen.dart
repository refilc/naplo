// ignore_for_file: no_leading_underscores_for_local_identifiers, use_build_context_synchronously, deprecated_member_use

import 'package:filcnaplo/api/providers/update_provider.dart';
import 'package:filcnaplo/theme/colors/accent.dart';
import 'package:filcnaplo/theme/observer.dart';
import 'package:filcnaplo_kreta_api/providers/absence_provider.dart';
import 'package:filcnaplo_kreta_api/providers/event_provider.dart';
import 'package:filcnaplo_kreta_api/providers/exam_provider.dart';
import 'package:filcnaplo_kreta_api/providers/grade_provider.dart';
import 'package:filcnaplo_kreta_api/providers/homework_provider.dart';
import 'package:filcnaplo_kreta_api/providers/message_provider.dart';
import 'package:filcnaplo_kreta_api/providers/note_provider.dart';
import 'package:filcnaplo_kreta_api/providers/timetable_provider.dart';
import 'package:filcnaplo/api/providers/user_provider.dart';
import 'package:filcnaplo/api/providers/database_provider.dart';
// import 'package:filcnaplo/utils/format.dart';
import 'package:filcnaplo/models/settings.dart';
import 'package:filcnaplo/models/user.dart';
import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:filcnaplo_kreta_api/client/client.dart';
import 'package:filcnaplo_mobile_ui/common/action_button.dart';
import 'package:filcnaplo_mobile_ui/common/bottom_sheet_menu/bottom_sheet_menu.dart';
// import 'package:filcnaplo_mobile_ui/common/bottom_sheet_menu/bottom_sheet_menu_item.dart';
import 'package:filcnaplo_mobile_ui/common/panel/panel.dart';
import 'package:filcnaplo_mobile_ui/common/panel/panel_button.dart';
import 'package:filcnaplo_mobile_ui/common/profile_image/profile_image.dart';
// import 'package:filcnaplo_mobile_ui/common/soon_alert/soon_alert.dart';
import 'package:filcnaplo_mobile_ui/common/splitted_panel/splitted_panel.dart';
// import 'package:filcnaplo_mobile_ui/common/system_chrome.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/update/updates_view.dart';
import 'package:filcnaplo_mobile_ui/screens/news/news_screen.dart';
import 'package:filcnaplo_mobile_ui/screens/notes/notes_screen.dart';
import 'package:filcnaplo_mobile_ui/screens/settings/accounts/account_tile.dart';
import 'package:filcnaplo_mobile_ui/screens/settings/accounts/account_view.dart';
// import 'package:filcnaplo_mobile_ui/screens/settings/debug/subject_icon_gallery.dart';
// import 'package:filcnaplo_mobile_ui/screens/settings/modify_subject_names.dart';
import 'package:filcnaplo_mobile_ui/screens/settings/notifications_screen.dart';
import 'package:filcnaplo_mobile_ui/screens/settings/privacy_view.dart';
import 'package:filcnaplo_mobile_ui/screens/settings/settings_helper.dart';
import 'package:filcnaplo_mobile_ui/screens/settings/submenu/extras_screen.dart';
import 'package:filcnaplo_mobile_ui/screens/settings/submenu/personalize_screen.dart';
// import 'package:refilc_plus/models/premium_scopes.dart';
import 'package:refilc_plus/providers/premium_provider.dart';
// import 'package:refilc_plus/ui/mobile/premium/upsell.dart';
// import 'package:refilc_plus/ui/mobile/settings/app_icon_screen.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart' as tabs;
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'settings_screen.i18n.dart';
import 'package:flutter/services.dart';
import 'package:filcnaplo_mobile_ui/screens/settings/user/nickname.dart';
import 'package:filcnaplo_mobile_ui/screens/settings/user/profile_pic.dart';
// import 'package:refilc_plus/ui/mobile/settings/modify_teacher_names.dart';
// import 'package:refilc_plus/ui/mobile/settings/welcome_message.dart';

import 'submenu/general_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  int devmodeCountdown = 5;
  bool __ss = false; // secret settings

  Future<Map>? futureRelease;

  late UserProvider user;
  late UpdateProvider updateProvider;
  late SettingsProvider settings;
  late DatabaseProvider databaseProvider;
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

      List<String> _nameParts =
          (account.nickname != '' ? account.nickname : account.displayName)
              .split(" ");
      if (!settings.presentationMode) {
        _firstName = _nameParts.length > 1 ? _nameParts[1] : _nameParts[0];
      } else {
        _firstName = "János";
      }

      accountTiles.add(
        AccountTile(
          name: Text(
              !settings.presentationMode
                  ? (account.nickname != '' ? account.nickname : account.name)
                  : "János",
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
      // BottomSheetMenuItem(
      //   onPressed: () => AccountView.show(u, context: context),
      //   icon: const Icon(FeatherIcons.user),
      //   title: Text("personal_details".i18n),
      // ),
      // BottomSheetMenuItem(
      //   onPressed: () => _openDKT(u),
      //   icon: Icon(FeatherIcons.grid, color: AppColors.of(context).teal),
      //   title: Text("open_dkt".i18n),
      // ),
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
    databaseProvider = Provider.of<DatabaseProvider>(context);
    kretaClient = Provider.of<KretaClient>(context);

    List<String> nameParts = user.displayName?.split(" ") ?? ["?"];
    if (!settings.presentationMode) {
      firstName = nameParts.length > 1 ? nameParts[1] : nameParts[0];
    } else {
      firstName = "János";
    }

    // String startPageTitle =
    //     SettingsHelper.localizedPageTitles()[settings.startPage] ?? "?";
    String themeModeText = {
          ThemeMode.light: "light".i18n,
          ThemeMode.dark: "dark".i18n,
          ThemeMode.system: "system".i18n
        }[settings.theme] ??
        "?";
    // String languageText = SettingsHelper.langMap[settings.language] ?? "?";
    // String vibrateTitle = {
    //       VibrationStrength.off: "voff".i18n,
    //       VibrationStrength.light: "vlight".i18n,
    //       VibrationStrength.medium: "vmedium".i18n,
    //       VibrationStrength.strong: "vstrong".i18n,
    //     }[settings.vibrate] ??
    //     "?";

    buildAccountTiles();

    if (settings.developerMode) devmodeCountdown = -1;

    return AnimatedBuilder(
      animation: _hideContainersController,
      builder: (context, child) => Opacity(
        opacity: 1 - _hideContainersController.value,
        child: Column(
          children: [
            const SizedBox(height: 45.0),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      splashRadius: 32.0,
                      onPressed: () =>
                          _showBottomSheet(user.getUser(user.id ?? "")),
                      icon: Icon(FeatherIcons.moreVertical,
                          color: AppColors.of(context).text.withOpacity(0.8)),
                    ),
                    // const SizedBox(
                    //   width: 5,
                    // ),
                    IconButton(
                      splashRadius: 32.0,
                      // onPressed: () async => await databaseProvider.userStore
                      //     .storeSelfNotes([], userId: user.id!),
                      onPressed: () async => _openNotes(
                        context,
                        await databaseProvider.userQuery
                            .toDoItems(userId: user.id!),
                      ),
                      // _showBottomSheet(user.getUser(user.id ?? "")),
                      icon: Icon(FeatherIcons.fileText,
                          color: AppColors.of(context).text.withOpacity(0.8)),
                    ),
                  ],
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
                radius: 48.42069,
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
                      fontSize: 22.0,
                      fontWeight: FontWeight.w600,
                      color: AppColors.of(context).text),
                ),
              ),
            ),

            const SizedBox(
              height: 18.0,
            ),

            // user options
            SplittedPanel(
              cardPadding: const EdgeInsets.all(4.0),
              children: [
                // personal details
                PanelButton(
                  onPressed: () =>
                      AccountView.show(user.user!, context: context),
                  title: Text("personal_details".i18n),
                  leading: Icon(
                    FeatherIcons.info,
                    size: 22.0,
                    color: AppColors.of(context).text.withOpacity(0.95),
                  ),
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12.0), bottom: Radius.circular(4.0)),
                ),
                // open dcs (digital collaboration space)
                PanelButton(
                  onPressed: () => _openDKT(user.user!),
                  title: Text("open_dkt".i18n),
                  leading: Icon(
                    FeatherIcons.grid,
                    size: 22.0,
                    color: AppColors.of(context).text.withOpacity(0.95),
                  ),
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(4.0), bottom: Radius.circular(4.0)),
                ),
                // edit user
                PanelButton(
                  onPressed: () =>
                      _showBottomSheet(user.getUser(user.id ?? "")),
                  title: Text("edit".i18n),
                  leading: Icon(
                    FeatherIcons.edit3,
                    size: 22.0,
                    color: AppColors.of(context).text.withOpacity(0.95),
                  ),
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(4.0), bottom: Radius.circular(4.0)),
                ),
                // switch account
                PanelButton(
                  // onPressed: () => SoonAlert.show(context: context),
                  onPressed: () {
                    SettingsHelper.changeCurrentUser(
                        context, accountTiles, (accountTiles.length + 2));
                  },
                  title: Text("switch_account".i18n),
                  leading: Icon(
                    FeatherIcons.users,
                    size: 22.0,
                    color: AppColors.of(context).text.withOpacity(0.95),
                  ),
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(4.0), bottom: Radius.circular(4.0)),
                ),
                // log user out
                PanelButton(
                  onPressed: () async {
                    String? userId = user.id;
                    if (userId == null) return;

                    // delete user
                    user.removeUser(userId);
                    await Provider.of<DatabaseProvider>(context, listen: false)
                        .store
                        .removeUser(userId);

                    // if no users, show login
                    if (user.getUsers().isNotEmpty) {
                      user.setUser(user.getUsers().first.id);
                      restore()
                          .then((_) => user.setUser(user.getUsers().first.id));
                    } else {
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil("login", (_) => false);
                    }
                  },
                  title: Text("log_out".i18n),
                  leading: Icon(
                    FeatherIcons.logOut,
                    color: AppColors.of(context).red,
                    size: 22.0,
                  ),
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(4.0), bottom: Radius.circular(12.0)),
                ),
                // SplittedMenuOption(
                //   padding: const EdgeInsets.all(8.0),
                //   text: 'edit'.i18n,
                //   trailing: const Icon(
                //     FeatherIcons.edit2,
                //     size: 22.0,
                //   ),
                //   onTap: () {
                //     print('object');
                //   },
                // ),
              ],
            ),

            // Padding(
            //   padding:
            //       const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
            //   child: Panel(
            //     child: Column(
            //       children: [
            //         // account list
            //         ...accountTiles,

            //         if (accountTiles.isNotEmpty)
            //           Center(
            //             child: Container(
            //               margin: const EdgeInsets.only(top: 12.0, bottom: 4.0),
            //               height: 3.0,
            //               width: 75.0,
            //               decoration: BoxDecoration(
            //                 borderRadius: BorderRadius.circular(12.0),
            //                 color: AppColors.of(context).text.withOpacity(.25),
            //               ),
            //             ),
            //           ),

            //         // add account panel
            //         PanelButton(
            //           onPressed: () {
            //             if (!Provider.of<PremiumProvider>(context,
            //                     listen: false)
            //                 .hasScope(PremiumScopes.maxTwoAccounts)) {
            //               PremiumLockedFeatureUpsell.show(
            //                   context: context,
            //                   feature: PremiumFeature.moreAccounts);
            //               return;
            //             }

            //             Navigator.of(context)
            //                 .pushNamed("login_back")
            //                 .then((value) {
            //               setSystemChrome(context);
            //             });
            //           },
            //           title: Text("add_user".i18n),
            //           leading: const Icon(FeatherIcons.userPlus),
            //         ),
            //         // PanelButton(
            //         //   onPressed: () async {
            //         //     String? userId = user.id;
            //         //     if (userId == null) return;

            //         //     // Delete User
            //         //     user.removeUser(userId);
            //         //     await Provider.of<DatabaseProvider>(context,
            //         //             listen: false)
            //         //         .store
            //         //         .removeUser(userId);

            //         //     // If no other Users left, go back to LoginScreen
            //         //     if (user.getUsers().isNotEmpty) {
            //         //       user.setUser(user.getUsers().first.id);
            //         //       restore().then(
            //         //           (_) => user.setUser(user.getUsers().first.id));
            //         //     } else {
            //         //       Navigator.of(context)
            //         //           .pushNamedAndRemoveUntil("login", (_) => false);
            //         //     }
            //         //   },
            //         //   title: Text("log_out".i18n),
            //         //   leading: Icon(FeatherIcons.logOut,
            //         //       color: AppColors.of(context).red),
            //         // ),
            //       ],
            //     ),
            //   ),
            // ),

            // updates
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

            // secret settings
            if (__ss)
              SplittedPanel(
                isSeparated: true,
                isTransparent: true,
                hasShadow: false,
                children: [
                  SplittedPanel(
                    title: Text("secret".i18n),
                    cardPadding: const EdgeInsets.all(4.0),
                    padding: EdgeInsets.zero,
                    children: [
                      // good student mode
                      Material(
                        type: MaterialType.transparency,
                        child: SwitchListTile(
                          contentPadding:
                              const EdgeInsets.only(left: 12.0, right: 6.0),
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
                    ],
                  ),
                  SplittedPanel(
                    cardPadding: const EdgeInsets.all(4.0),
                    padding: EdgeInsets.zero,
                    children: [
                      // presentation mode
                      Material(
                        type: MaterialType.transparency,
                        child: SwitchListTile(
                          contentPadding:
                              const EdgeInsets.only(left: 12.0, right: 6.0),
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
                ],
              ),

            // settings submenus
            const SizedBox(
              height: 16.0,
            ),
            Panel(
              hasShadow: false,
              padding:
                  const EdgeInsets.only(bottom: 20.0, left: 24.0, right: 24.0),
              title: Padding(
                padding: const EdgeInsets.only(left: 24.0),
                child: Text('settings'.i18n),
              ),
              isTransparent: true,
              child: Column(
                children: [
                  // general settings
                  const SplittedPanel(
                    padding: EdgeInsets.zero,
                    cardPadding: EdgeInsets.all(4.0),
                    children: [
                      MenuGeneralSettings(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(12.0),
                          bottom: Radius.circular(12.0),
                        ),
                      ),
                    ],
                  ),

                  // theme settings
                  SplittedPanel(
                    padding: const EdgeInsets.only(top: 8.0),
                    cardPadding: const EdgeInsets.all(4.0),
                    children: [
                      const MenuPersonalizeSettings(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(12.0),
                          bottom: Radius.circular(4.0),
                        ),
                      ),
                      PanelButton(
                        onPressed: () {
                          SettingsHelper.theme(context);
                          setState(() {});
                        },
                        title: Text("theme".i18n),
                        leading: Icon(
                          FeatherIcons.sun,
                          size: 22.0,
                          color: AppColors.of(context).text.withOpacity(0.95),
                        ),
                        trailing: Text(
                          themeModeText,
                          style: const TextStyle(fontSize: 14.0),
                        ),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(4.0),
                          bottom: Radius.circular(12.0),
                        ),
                      ),
                    ],
                  ),

                  // notifications
                  const SplittedPanel(
                    padding: EdgeInsets.only(top: 8.0),
                    cardPadding: EdgeInsets.all(4.0),
                    children: [
                      MenuNotifications(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(12.0),
                          bottom: Radius.circular(12.0),
                        ),
                      ),
                    ],
                  ),

                  // extras
                  const SplittedPanel(
                    padding: EdgeInsets.only(top: 8.0),
                    cardPadding: EdgeInsets.all(4.0),
                    children: [
                      MenuExtrasSettings(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(12.0),
                          bottom: Radius.circular(12.0),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // SplittedMenuOption(
              //   padding: const EdgeInsets.all(8.0),
              //   text: 'edit'.i18n,
              //   trailing: const Icon(
              //     FeatherIcons.edit2,
              //     size: 22.0,
              //   ),
              //   onTap: () {
              //     print('object');
              //   },
              // ),
            ),
            // // general things
            // Padding(
            //   padding:
            //       const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
            //   child: Panel(
            //     title: Text("general".i18n),
            //     child: Column(
            //       children: [
            //         WelcomeMessagePanelButton(settings, user),
            //       ],
            //     ),
            //   ),
            // ),

            // // icon gallery (debug mode)
            // if (kDebugMode)
            //   Padding(
            //     padding: const EdgeInsets.symmetric(
            //         vertical: 12.0, horizontal: 24.0),
            //     child: Panel(
            //       title: const Text("Debug"),
            //       child: Column(
            //         children: [
            //           PanelButton(
            //             title: const Text("Subject Icon Gallery"),
            //             leading:
            //                 const Icon(CupertinoIcons.rectangle_3_offgrid_fill),
            //             trailing: const Icon(Icons.arrow_forward),
            //             onPressed: () {
            //               Navigator.of(context, rootNavigator: true).push(
            //                 CupertinoPageRoute(
            //                     builder: (context) =>
            //                         const SubjectIconGallery()),
            //               );
            //             },
            //           )
            //         ],
            //       ),
            //     ),
            //   ),

            // // appearance things
            // Padding(
            //   padding:
            //       const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
            //   child: Panel(
            //     title: Text("appearance".i18n),
            //     child: Column(
            //       children: [

            //         // if ios show live activity color option
            //         if (defaultTargetPlatform == TargetPlatform.iOS)
            //           PanelButton(
            //             onPressed: () {
            //               if (!Provider.of<PremiumProvider>(context,
            //                       listen: false)
            //                   .hasScope(PremiumScopes.liveActivityColor)) {
            //                 PremiumLockedFeatureUpsell.show(
            //                     context: context,
            //                     feature: PremiumFeature.liveActivity);
            //                 return;
            //               }

            //               SettingsHelper.liveActivityColor(context);
            //               setState(() {});
            //             },
            //             title: Text("live_activity_color".i18n),
            //             leading: const Icon(FeatherIcons.activity),
            //             trailing: Container(
            //               width: 12.0,
            //               height: 12.0,
            //               decoration: BoxDecoration(
            //                 color: settings.liveActivityColor,
            //                 shape: BoxShape.circle,
            //               ),
            //             ),
            //           ),

            //         Material(
            //           type: MaterialType.transparency,
            //           child: SwitchListTile(
            //             contentPadding: const EdgeInsets.only(left: 14.0),
            //             shape: RoundedRectangleBorder(
            //                 borderRadius: BorderRadius.circular(12.0)),
            //             title: Row(
            //               children: [
            //                 Icon(
            //                   FeatherIcons.moon,
            //                   color: settings.shadowEffect
            //                       ? Theme.of(context).colorScheme.secondary
            //                       : AppColors.of(context).text.withOpacity(.25),
            //                 ),
            //                 const SizedBox(width: 14.0),
            //                 Expanded(
            //                   child: Text(
            //                     "shadow_effect".i18n,
            //                     style: TextStyle(
            //                       fontWeight: FontWeight.w600,
            //                       fontSize: 16.0,
            //                       color: AppColors.of(context).text.withOpacity(
            //                           settings.shadowEffect ? 1.0 : .5),
            //                     ),
            //                   ),
            //                 ),
            //               ],
            //             ),
            //             onChanged: (v) => settings.update(shadowEffect: v),
            //             value: settings.shadowEffect,
            //             activeColor: Theme.of(context).colorScheme.secondary,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),

            // // popup alerts
            // Padding(
            //   padding:
            //       const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
            //   child: Panel(
            //     title: Text("popups".i18n),
            //     child: Material(
            //       type: MaterialType.transparency,
            //       child: SwitchListTile(
            //         contentPadding: const EdgeInsets.only(left: 12.0),
            //         shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(12.0)),
            //         title: Row(
            //           children: [
            //             Icon(
            //               Icons.newspaper_outlined,
            //               color: settings.newsEnabled
            //                   ? Theme.of(context).colorScheme.secondary
            //                   : AppColors.of(context).text.withOpacity(.25),
            //             ),
            //             const SizedBox(width: 14.0),
            //             Expanded(
            //               child: Text(
            //                 "news".i18n,
            //                 style: TextStyle(
            //                   fontWeight: FontWeight.w600,
            //                   fontSize: 16.0,
            //                   color: AppColors.of(context)
            //                       .text
            //                       .withOpacity(settings.newsEnabled ? 1.0 : .5),
            //                 ),
            //               ),
            //             ),
            //           ],
            //         ),
            //         onChanged: (v) => settings.update(newsEnabled: v),
            //         value: settings.newsEnabled,
            //         activeColor: Theme.of(context).colorScheme.secondary,
            //       ),
            //     ),
            //   ),
            // ),

            // // extra settings
            // Padding(
            //   padding:
            //       const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
            //   child: Panel(
            //     title: Text("extras".i18n),
            //     child: Column(
            //       children: [
            //         Material(
            //           type: MaterialType.transparency,
            //           child: SwitchListTile(
            //             contentPadding: const EdgeInsets.only(left: 12.0),
            //             shape: RoundedRectangleBorder(
            //                 borderRadius: BorderRadius.circular(12.0)),
            //             title: Row(
            //               children: [
            //                 Icon(
            //                   FeatherIcons.gift,
            //                   color: settings.gradeOpeningFun
            //                       ? Theme.of(context).colorScheme.secondary
            //                       : AppColors.of(context).text.withOpacity(.25),
            //                 ),
            //                 const SizedBox(width: 14.0),
            //                 Expanded(
            //                   child: Text(
            //                     "surprise_grades".i18n,
            //                     style: TextStyle(
            //                       fontWeight: FontWeight.w600,
            //                       fontSize: 16.0,
            //                       color: AppColors.of(context).text.withOpacity(
            //                           settings.gradeOpeningFun ? 1.0 : .5),
            //                     ),
            //                   ),
            //                 ),
            //               ],
            //             ),
            //             onChanged: (v) => settings.update(gradeOpeningFun: v),
            //             value: settings.gradeOpeningFun,
            //             activeColor: Theme.of(context).colorScheme.secondary,
            //           ),
            //         ),
            //         MenuRenamedSubjects(
            //           settings: settings,
            //         ),
            //         MenuRenamedTeachers(
            //           settings: settings,
            //         ),
            //         PremiumCustomAppIconMenu(
            //           settings: settings,
            //         ),
            //         // PanelButton(
            //         //   onPressed: () {
            //         //     SoonAlert.show(context: context);
            //         //   },
            //         //   title: Text('app_icon'.i18n),
            //         //   leading: const Icon(FeatherIcons.edit),
            //         //   // trailing: Text(
            //         //   //   'default'.i18n,
            //         //   //   style: const TextStyle(fontSize: 14.0),
            //         //   // ),
            //         // ),
            //       ],
            //     ),
            //   ),
            // ),

            // about sweetie
            SplittedPanel(
              title: Text("about".i18n),
              cardPadding: const EdgeInsets.all(4.0),
              children: [
                PanelButton(
                  leading: Icon(
                    FeatherIcons.mail,
                    size: 22.0,
                    color: AppColors.of(context).text.withOpacity(0.95),
                  ),
                  title: Text("news".i18n),
                  onPressed: () => _openNews(context),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12.0),
                    bottom: Radius.circular(4.0),
                  ),
                ),
                PanelButton(
                  leading: Icon(
                    FeatherIcons.lock,
                    size: 22.0,
                    color: AppColors.of(context).text.withOpacity(0.95),
                  ),
                  title: Text("privacy".i18n),
                  // onPressed: () => launchUrl(
                  //     Uri.parse("https://refilc.hu/privacy-policy"),
                  //     mode: LaunchMode.inAppWebView),
                  onPressed: () => _openPrivacy(context),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(4.0),
                    bottom: Radius.circular(4.0),
                  ),
                ),
                PanelButton(
                  leading: Icon(
                    FeatherIcons.atSign,
                    size: 22.0,
                    color: AppColors.of(context).text.withOpacity(0.95),
                  ),
                  title: const Text("Discord"),
                  onPressed: () => launchUrl(Uri.parse("https://dc.refilc.hu"),
                      mode: LaunchMode.externalApplication),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(4.0),
                    bottom: Radius.circular(4.0),
                  ),
                ),
                PanelButton(
                  leading: Icon(
                    FeatherIcons.globe,
                    size: 22.0,
                    color: AppColors.of(context).text.withOpacity(0.95),
                  ),
                  title: const Text("www.refilc.hu"),
                  onPressed: () => launchUrl(Uri.parse("https://www.refilc.hu"),
                      mode: LaunchMode.externalApplication),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(4.0),
                    bottom: Radius.circular(4.0),
                  ),
                ),
                PanelButton(
                  leading: Icon(
                    FeatherIcons.github,
                    size: 22.0,
                    color: AppColors.of(context).text.withOpacity(0.95),
                  ),
                  title: const Text("Github"),
                  onPressed: () => launchUrl(
                      Uri.parse("https://github.com/refilc"),
                      mode: LaunchMode.externalApplication),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(4.0),
                    bottom: Radius.circular(4.0),
                  ),
                ),
                PanelButton(
                  leading: Icon(
                    FeatherIcons.award,
                    size: 22.0,
                    color: AppColors.of(context).text.withOpacity(0.95),
                  ),
                  title: Text("licenses".i18n),
                  onPressed: () => showLicensePage(context: context),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(4.0),
                    bottom: Radius.circular(4.0),
                  ),
                ),
                Tooltip(
                  message: "data_collected".i18n,
                  padding: const EdgeInsets.all(4.0),
                  margin: const EdgeInsets.all(10.0),
                  textStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: AppColors.of(context).text),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 40.0,
                      )
                    ],
                  ),
                  child: Material(
                    type: MaterialType.transparency,
                    child: SwitchListTile(
                      contentPadding:
                          const EdgeInsets.only(left: 14.0, right: 4.0),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(4.0),
                          bottom: Radius.circular(12.0),
                        ),
                      ),
                      secondary: Icon(
                        FeatherIcons.barChart2,
                        size: 22.0,
                        color: settings.xFilcId != "none"
                            ? AppColors.of(context).text.withOpacity(0.95)
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
              ],
            ),

            // Padding(
            //   padding:
            //       const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
            //   child: Panel(
            //     title: Text("about".i18n),
            //     child: Column(children: [
            //       PanelButton(
            //         leading: const Icon(FeatherIcons.mail),
            //         title: Text("news".i18n),
            //         onPressed: () => _openNews(context),
            //       ),
            //       PanelButton(
            //         leading: const Icon(FeatherIcons.lock),
            //         title: Text("privacy".i18n),
            //         // onPressed: () => launchUrl(
            //         //     Uri.parse("https://refilc.hu/privacy-policy"),
            //         //     mode: LaunchMode.inAppWebView),
            //         onPressed: () => _openPrivacy(context),
            //       ),
            //       PanelButton(
            //         leading: const Icon(FeatherIcons.atSign),
            //         title: const Text("Discord"),
            //         onPressed: () => launchUrl(
            //             Uri.parse("https://dc.refilc.hu"),
            //             mode: LaunchMode.externalApplication),
            //       ),
            //       PanelButton(
            //         leading: const Icon(FeatherIcons.globe),
            //         title: const Text("www.refilc.hu"),
            //         onPressed: () => launchUrl(
            //             Uri.parse("https://www.refilc.hu"),
            //             mode: LaunchMode.externalApplication),
            //       ),
            //       PanelButton(
            //         leading: const Icon(FeatherIcons.github),
            //         title: const Text("Github"),
            //         onPressed: () => launchUrl(
            //             Uri.parse("https://github.com/refilc"),
            //             mode: LaunchMode.externalApplication),
            //       ),
            //       PanelButton(
            //         leading: const Icon(FeatherIcons.award),
            //         title: Text("licenses".i18n),
            //         onPressed: () => showLicensePage(context: context),
            //       ),
            //       Tooltip(
            //         message: "data_collected".i18n,
            //         padding: const EdgeInsets.all(4.0),
            //         textStyle: TextStyle(
            //             fontWeight: FontWeight.w500,
            //             color: AppColors.of(context).text),
            //         decoration: BoxDecoration(
            //             color: Theme.of(context).colorScheme.background),
            //         child: Material(
            //           type: MaterialType.transparency,
            //           child: SwitchListTile(
            //             contentPadding: const EdgeInsets.only(left: 12.0),
            //             shape: RoundedRectangleBorder(
            //                 borderRadius: BorderRadius.circular(12.0)),
            //             secondary: Icon(
            //               FeatherIcons.barChart2,
            //               color: settings.xFilcId != "none"
            //                   ? Theme.of(context).colorScheme.secondary
            //                   : AppColors.of(context).text.withOpacity(.25),
            //             ),
            //             title: Text(
            //               "Analytics".i18n,
            //               style: TextStyle(
            //                 fontWeight: FontWeight.w600,
            //                 fontSize: 16.0,
            //                 color: AppColors.of(context).text.withOpacity(
            //                     settings.xFilcId != "none" ? 1.0 : .5),
            //               ),
            //             ),
            //             subtitle: Text(
            //               "Anonymous Usage Analytics".i18n,
            //               style: TextStyle(
            //                 color: AppColors.of(context).text.withOpacity(
            //                     settings.xFilcId != "none" ? .5 : .2),
            //               ),
            //             ),
            //             onChanged: (v) {
            //               String newId;
            //               if (v == false) {
            //                 newId = "none";
            //               } else if (settings.xFilcId == "none") {
            //                 newId = SettingsProvider.defaultSettings().xFilcId;
            //               } else {
            //                 newId = settings.xFilcId;
            //               }
            //               settings.update(xFilcId: newId);
            //             },
            //             value: settings.xFilcId != "none",
            //             activeColor: Theme.of(context).colorScheme.secondary,
            //           ),
            //         ),
            //       ),
            //     ]),
            //   ),
            // ),

            // developer options
            if (settings.developerMode)
              SplittedPanel(
                title: Text("devsettings".i18n),
                cardPadding: const EdgeInsets.all(4.0),
                children: [
                  Material(
                    type: MaterialType.transparency,
                    child: SwitchListTile(
                      contentPadding:
                          const EdgeInsets.only(left: 12.0, right: 4.0),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(12.0),
                              bottom: Radius.circular(4.0))),
                      title: Text("devmode".i18n,
                          style: const TextStyle(fontWeight: FontWeight.w500)),
                      onChanged: (v) => settings.update(developerMode: false),
                      value: settings.developerMode,
                      activeColor: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  PanelButton(
                    borderRadius: BorderRadius.vertical(
                      top: const Radius.circular(4.0),
                      bottom:
                          Provider.of<PremiumProvider>(context, listen: false)
                                  .hasPremium
                              ? const Radius.circular(4.0)
                              : const Radius.circular(12.0),
                    ),
                    leading: Icon(
                      FeatherIcons.copy,
                      size: 22.0,
                      color: AppColors.of(context).text.withOpacity(.95),
                    ),
                    title: Text("copy_jwt".i18n),
                    onPressed: () => Clipboard.setData(ClipboardData(
                        text: Provider.of<KretaClient>(context, listen: false)
                            .accessToken!)),
                  ),
                  if (Provider.of<PremiumProvider>(context, listen: false)
                      .hasPremium)
                    PanelButton(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(4.0),
                        bottom: Radius.circular(12.0),
                      ),
                      leading: Icon(
                        FeatherIcons.key,
                        size: 22.0,
                        color: AppColors.of(context).text.withOpacity(.95),
                      ),
                      title: const Text("Remove Premium"),
                      onPressed: () {
                        Provider.of<PremiumProvider>(context, listen: false)
                            .activate(removePremium: true);
                        settings.update(
                            accentColor: AccentColor.filc, store: true);
                        Provider.of<ThemeModeObserver>(context, listen: false)
                            .changeTheme(settings.theme);
                      },
                    ),
                ],
              ),

            // version info
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
  void _openNotes(BuildContext context, Map<String, bool> doneItems) async =>
      Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(
          builder: (context) => NotesScreen(
                doneItems: doneItems,
              )));

  // open submenu
  void openSubMenu(BuildContext context, StatefulWidget screen) =>
      Navigator.of(context)
          .push(CupertinoPageRoute(builder: (context) => screen));
}
