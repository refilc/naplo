// import 'package:filcnaplo/models/settings.dart';
import 'package:filcnaplo/api/providers/user_provider.dart';
import 'package:filcnaplo/models/settings.dart';
import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:filcnaplo_mobile_ui/common/panel/panel_button.dart';
import 'package:filcnaplo_mobile_ui/common/splitted_panel/splitted_panel.dart';
import 'package:filcnaplo_mobile_ui/screens/settings/settings_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:refilc_plus/ui/mobile/settings/welcome_message.dart';
// import 'package:provider/provider.dart';
import 'submenu_screen.i18n.dart';

class MenuExtrasSettings extends StatelessWidget {
  const MenuExtrasSettings({
    super.key,
    this.borderRadius = const BorderRadius.vertical(
        top: Radius.circular(4.0), bottom: Radius.circular(4.0)),
  });

  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return PanelButton(
      onPressed: () => Navigator.of(context, rootNavigator: true).push(
        CupertinoPageRoute(builder: (context) => const ExtrasSettingsScreen()),
      ),
      title: Text("extras".i18n),
      leading: Icon(
        FeatherIcons.edit,
        size: 22.0,
        color: AppColors.of(context).text.withOpacity(0.95),
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

class ExtrasSettingsScreen extends StatefulWidget {
  const ExtrasSettingsScreen({super.key});

  @override
  ExtrasSettingsScreenState createState() => ExtrasSettingsScreenState();
}

class ExtrasSettingsScreenState extends State<ExtrasSettingsScreen> {
  late SettingsProvider settingsProvider;
  late UserProvider user;

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    UserProvider user = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
        leading: BackButton(color: AppColors.of(context).text),
        title: Text(
          "extras".i18n,
          style: TextStyle(color: AppColors.of(context).text),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          child: Column(
            children: [
              SplittedPanel(
                padding: const EdgeInsets.only(top: 8.0),
                cardPadding: const EdgeInsets.all(4.0),
                isSeparated: true,
                children: [
                  PanelButton(
                    padding: const EdgeInsets.only(left: 14.0, right: 6.0),
                    onPressed: () async {
                      // settingsProvider.update(
                      //     gradeOpeningFun: !settingsProvider.gradeOpeningFun);
                      SettingsHelper.surpriseGradeRarityText(context);
                      setState(() {});
                    },
                    trailingDivider: true,
                    title: Text(
                      "surprise_grades".i18n,
                      style: TextStyle(
                        color: AppColors.of(context).text.withOpacity(
                            settingsProvider.gradeOpeningFun ? .95 : .25),
                      ),
                    ),
                    leading: Icon(
                      FeatherIcons.gift,
                      size: 22.0,
                      color: AppColors.of(context).text.withOpacity(
                          settingsProvider.gradeOpeningFun ? .95 : .25),
                    ),
                    trailing: Switch(
                      onChanged: (v) async {
                        settingsProvider.update(gradeOpeningFun: v);

                        setState(() {});
                      },
                      value: settingsProvider.gradeOpeningFun,
                      activeColor: Theme.of(context).colorScheme.secondary,
                    ),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12.0),
                      bottom: Radius.circular(12.0),
                    ),
                  ),
                ],
              ),
              SplittedPanel(
                padding: const EdgeInsets.only(top: 9.0),
                cardPadding: const EdgeInsets.all(4.0),
                isSeparated: true,
                children: [
                  WelcomeMessagePanelButton(settingsProvider, user),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
