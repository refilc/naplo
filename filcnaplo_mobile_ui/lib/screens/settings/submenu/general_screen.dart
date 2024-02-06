import 'package:filcnaplo/models/settings.dart';
import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:filcnaplo_mobile_ui/common/panel/panel_button.dart';
import 'package:filcnaplo_mobile_ui/common/splitted_panel/splitted_panel.dart';
import 'package:filcnaplo_mobile_ui/screens/settings/settings_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:filcnaplo_mobile_ui/screens/settings/settings_screen.i18n.dart';

class MenuGeneralSettings extends StatelessWidget {
  const MenuGeneralSettings({
    super.key,
    this.borderRadius = const BorderRadius.vertical(
        top: Radius.circular(4.0), bottom: Radius.circular(4.0)),
  });

  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return PanelButton(
      onPressed: () => Navigator.of(context, rootNavigator: true).push(
        CupertinoPageRoute(builder: (context) => const GeneralSettingsScreen()),
      ),
      title: Text("general".i18n),
      leading: Icon(
        FeatherIcons.settings,
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

class GeneralSettingsScreen extends StatefulWidget {
  const GeneralSettingsScreen({super.key});

  @override
  GeneralSettingsScreenState createState() => GeneralSettingsScreenState();
}

class GeneralSettingsScreenState extends State<GeneralSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);

    String startPageTitle =
        SettingsHelper.localizedPageTitles()[settingsProvider.startPage] ?? "?";
    String languageText =
        SettingsHelper.langMap[settingsProvider.language] ?? "?";
    String vibrateTitle = {
          VibrationStrength.off: "voff".i18n,
          VibrationStrength.light: "vlight".i18n,
          VibrationStrength.medium: "vmedium".i18n,
          VibrationStrength.strong: "vstrong".i18n,
        }[settingsProvider.vibrate] ??
        "?";

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
        leading: BackButton(color: AppColors.of(context).text),
        title: Text(
          "general".i18n,
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
                    onPressed: () {
                      SettingsHelper.bellDelay(context);
                      setState(() {});
                    },
                    title: Text(
                      "bell_delay".i18n,
                      style: TextStyle(
                        color: AppColors.of(context).text.withOpacity(
                            settingsProvider.bellDelayEnabled ? .95 : .25),
                      ),
                    ),
                    leading: Icon(
                      settingsProvider.bellDelayEnabled
                          ? FeatherIcons.bell
                          : FeatherIcons.bellOff,
                      size: 22.0,
                      color: AppColors.of(context).text.withOpacity(
                          settingsProvider.bellDelayEnabled ? .95 : .25),
                    ),
                    trailingDivider: true,
                    trailing: Switch(
                      onChanged: (v) =>
                          settingsProvider.update(bellDelayEnabled: v),
                      value: settingsProvider.bellDelayEnabled,
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
                  PanelButton(
                    onPressed: () {
                      SettingsHelper.rounding(context);
                      setState(() {});
                    },
                    title: Text(
                      "rounding".i18n,
                      style: TextStyle(
                        color: AppColors.of(context).text.withOpacity(.95),
                      ),
                    ),
                    leading: Icon(
                      FeatherIcons.gitCommit,
                      size: 22.0,
                      color: AppColors.of(context).text.withOpacity(.95),
                    ),
                    trailing: Text(
                      (settingsProvider.rounding / 10).toStringAsFixed(1),
                      style: const TextStyle(fontSize: 14.0),
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
                  PanelButton(
                    padding: const EdgeInsets.only(left: 14.0, right: 6.0),
                    onPressed: () {
                      settingsProvider.update(
                          graphClassAvg: !settingsProvider.graphClassAvg);
                      setState(() {});
                    },
                    title: Text(
                      "graph_class_avg".i18n,
                      style: TextStyle(
                        color: AppColors.of(context).text.withOpacity(
                            settingsProvider.graphClassAvg ? .95 : .25),
                      ),
                    ),
                    leading: Icon(
                      FeatherIcons.barChart,
                      size: 22.0,
                      color: AppColors.of(context).text.withOpacity(
                          settingsProvider.graphClassAvg ? .95 : .25),
                    ),
                    trailing: Switch(
                      onChanged: (v) =>
                          settingsProvider.update(graphClassAvg: v),
                      value: settingsProvider.graphClassAvg,
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
                  PanelButton(
                    onPressed: () {
                      SettingsHelper.startPage(context);
                      setState(() {});
                    },
                    title: Text(
                      "startpage".i18n,
                      style: TextStyle(
                        color: AppColors.of(context).text.withOpacity(.95),
                      ),
                    ),
                    leading: Icon(
                      FeatherIcons.play,
                      size: 22.0,
                      color: AppColors.of(context).text.withOpacity(.95),
                    ),
                    trailing: Text(
                      startPageTitle.capital(),
                      style: const TextStyle(fontSize: 14.0),
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
                  PanelButton(
                    onPressed: () {
                      SettingsHelper.language(context);
                      setState(() {});
                    },
                    title: Text(
                      "language".i18n,
                      style: TextStyle(
                        color: AppColors.of(context).text.withOpacity(.95),
                      ),
                    ),
                    leading: Icon(
                      FeatherIcons.globe,
                      size: 22.0,
                      color: AppColors.of(context).text.withOpacity(.95),
                    ),
                    trailing: Text(
                      languageText,
                      style: const TextStyle(fontSize: 14.0),
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
                  PanelButton(
                    onPressed: () {
                      SettingsHelper.vibrate(context);
                      setState(() {});
                    },
                    title: Text(
                      "vibrate".i18n,
                      style: TextStyle(
                        color: AppColors.of(context).text.withOpacity(.95),
                      ),
                    ),
                    leading: Icon(
                      FeatherIcons.radio,
                      size: 22.0,
                      color: AppColors.of(context).text.withOpacity(.95),
                    ),
                    trailing: Text(
                      vibrateTitle,
                      style: const TextStyle(fontSize: 14.0),
                    ),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12.0),
                      bottom: Radius.circular(12.0),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
