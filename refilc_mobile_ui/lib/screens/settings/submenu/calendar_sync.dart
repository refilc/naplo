// ignore_for_file: use_build_context_synchronously

import 'package:collection/collection.dart';
import 'package:refilc/api/providers/user_provider.dart';
import 'package:refilc/models/linked_account.dart';
import 'package:refilc/models/settings.dart';
import 'package:refilc/models/shared_theme.dart';
import 'package:refilc/providers/third_party_provider.dart';
import 'package:refilc/theme/colors/accent.dart';
import 'package:refilc/theme/colors/colors.dart';
import 'package:refilc/theme/observer.dart';
import 'package:refilc_kreta_api/providers/share_provider.dart';
import 'package:refilc_mobile_ui/common/custom_snack_bar.dart';
import 'package:refilc_mobile_ui/common/panel/panel_button.dart';
import 'package:refilc_mobile_ui/common/splitted_panel/splitted_panel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:refilc_mobile_ui/screens/settings/settings_screen.i18n.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_any_logo/flutter_logo.dart';

class MenuCalendarSync extends StatelessWidget {
  const MenuCalendarSync({
    super.key,
    this.borderRadius = const BorderRadius.vertical(
        top: Radius.circular(4.0), bottom: Radius.circular(4.0)),
  });

  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return PanelButton(
      onPressed: () async {
        Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(
            builder: (context) => const CalendarSyncScreen()));
      },
      title: Text(
        "calendar_sync".i18n,
        style: TextStyle(
          color: AppColors.of(context).text.withOpacity(.95),
        ),
      ),
      leading: Icon(
        FeatherIcons.calendar,
        size: 22.0,
        color: AppColors.of(context).text.withOpacity(.95),
      ),
      trailing: Icon(
        FeatherIcons.chevronRight,
        size: 22.0,
        color: AppColors.of(context).text.withOpacity(0.95),
      ),
      borderRadius: borderRadius,
    );
  }
}

class CalendarSyncScreen extends StatefulWidget {
  const CalendarSyncScreen({super.key});

  @override
  CalendarSyncScreenState createState() => CalendarSyncScreenState();
}

class CalendarSyncScreenState extends State<CalendarSyncScreen>
    with SingleTickerProviderStateMixin {
  late SettingsProvider settingsProvider;
  late UserProvider user;
  late ShareProvider shareProvider;
  late ThirdPartyProvider thirdPartyProvider;

  late AnimationController _hideContainersController;

  @override
  void initState() {
    super.initState();

    shareProvider = Provider.of<ShareProvider>(context, listen: false);

    _hideContainersController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
  }

  @override
  Widget build(BuildContext context) {
    settingsProvider = Provider.of<SettingsProvider>(context);
    user = Provider.of<UserProvider>(context);
    thirdPartyProvider = Provider.of<ThirdPartyProvider>(context);

    return AnimatedBuilder(
      animation: _hideContainersController,
      builder: (context, child) => Opacity(
        opacity: 1 - _hideContainersController.value,
        child: Scaffold(
          appBar: AppBar(
            surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
            leading: BackButton(color: AppColors.of(context).text),
            title: Text(
              "calendar_sync".i18n,
              style: TextStyle(color: AppColors.of(context).text),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
              child: Column(
                children: [
                  // banner
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        image: const DecorationImage(
                          image: AssetImage(
                            'assets/images/banner_texture.png',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 40,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              height: 64,
                              width: 64,
                              child: const Icon(
                                Icons.calendar_month,
                                size: 38.0,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Icon(
                              Icons.sync_alt_outlined,
                              color:
                                  AppColors.of(context).text.withOpacity(0.2),
                              size: 20.0,
                            ),
                            const SizedBox(width: 10),
                            Image.asset(
                              'assets/icons/ic_rounded.png',
                              width: 64,
                              height: 64,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 18.0,
                  ),
                  // choose account if not logged in
                  if (thirdPartyProvider.linkedAccounts.isEmpty)
                    Column(
                      children: [
                        SplittedPanel(
                          title: Text('choose_account'.i18n),
                          padding: EdgeInsets.zero,
                          cardPadding: const EdgeInsets.all(4.0),
                          isSeparated: true,
                          children: [
                            PanelButton(
                              onPressed: () async {
                                await Provider.of<ThirdPartyProvider>(context,
                                        listen: false)
                                    .googleSignIn();

                                setState(() {});
                              },
                              title: Text(
                                'Google',
                                style: TextStyle(
                                  color: AppColors.of(context)
                                      .text
                                      .withOpacity(.95),
                                ),
                              ),
                              leading: Image.asset(
                                'assets/images/ext_logo/google.png',
                                width: 24.0,
                                height: 24.0,
                              ),
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12),
                                bottom: Radius.circular(12),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 9.0,
                        ),
                        SplittedPanel(
                          padding: EdgeInsets.zero,
                          cardPadding: const EdgeInsets.all(4.0),
                          isSeparated: true,
                          children: [
                            PanelButton(
                              onPressed: null,
                              title: Text(
                                'Apple',
                                style: TextStyle(
                                  color: AppColors.of(context)
                                      .text
                                      .withOpacity(.55),
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              leading: Image.asset(
                                'assets/images/ext_logo/apple.png',
                                width: 24.0,
                                height: 24.0,
                              ),
                              trailing: Text(
                                'Hamarosan'.i18n,
                                style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 14.0),
                              ),
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12),
                                bottom: Radius.circular(12),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                  // show options if logged in
                  if (thirdPartyProvider.linkedAccounts.isNotEmpty)
                    Column(
                      children: [
                        SplittedPanel(
                          title: Text('your_account'.i18n),
                          padding: EdgeInsets.zero,
                          cardPadding: const EdgeInsets.all(4.0),
                          children: [
                            PanelButton(
                              onPressed: null,
                              title: Text(
                                thirdPartyProvider
                                    .linkedAccounts.first.username,
                                style: TextStyle(
                                  color: AppColors.of(context)
                                      .text
                                      .withOpacity(.95),
                                ),
                              ),
                              leading: Image.asset(
                                'assets/images/ext_logo/${thirdPartyProvider.linkedAccounts.first.type == AccountType.google ? "google" : "apple"}.png',
                                width: 24.0,
                                height: 24.0,
                              ),
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12),
                                bottom: Radius.circular(12),
                              ),
                            ),
                            PanelButton(
                              onPressed: () async {
                                await thirdPartyProvider.signOutAll();
                                setState(() {});
                              },
                              title: Text(
                                'change_account'.i18n,
                                style: TextStyle(
                                  color: AppColors.of(context)
                                      .text
                                      .withOpacity(.95),
                                ),
                              ),
                              trailing: Icon(
                                FeatherIcons.chevronRight,
                                size: 22.0,
                                color: AppColors.of(context)
                                    .text
                                    .withOpacity(0.95),
                              ),
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12),
                                bottom: Radius.circular(12),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 18.0,
                        ),
                        SplittedPanel(
                          title: Text('choose_calendar'.i18n),
                          padding: EdgeInsets.zero,
                          cardPadding: const EdgeInsets.all(4.0),
                          children: [
                            PanelButton(
                              onPressed: null,
                              title: Text(
                                thirdPartyProvider
                                    .linkedAccounts.first.username,
                                style: TextStyle(
                                  color: AppColors.of(context)
                                      .text
                                      .withOpacity(.95),
                                ),
                              ),
                              leading: Image.asset(
                                'assets/images/ext_logo/${thirdPartyProvider.linkedAccounts.first.type == AccountType.google ? "google" : "apple"}.png',
                                width: 24.0,
                                height: 24.0,
                              ),
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12),
                                bottom: Radius.circular(12),
                              ),
                            ),
                            PanelButton(
                              onPressed: () async {
                                await thirdPartyProvider.signOutAll();
                                setState(() {});
                              },
                              title: Text(
                                'change_account'.i18n,
                                style: TextStyle(
                                  color: AppColors.of(context)
                                      .text
                                      .withOpacity(.95),
                                ),
                              ),
                              trailing: Icon(
                                FeatherIcons.chevronRight,
                                size: 22.0,
                                color: AppColors.of(context)
                                    .text
                                    .withOpacity(0.95),
                              ),
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12),
                                bottom: Radius.circular(12),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
