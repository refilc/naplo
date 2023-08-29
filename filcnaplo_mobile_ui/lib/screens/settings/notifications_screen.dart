import 'package:filcnaplo/models/settings.dart';
import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:filcnaplo/ui/widgets/grade/grade_tile.dart';
import 'package:filcnaplo_kreta_api/models/grade.dart';
import 'package:filcnaplo_mobile_ui/common/panel/panel.dart';
import 'package:filcnaplo_mobile_ui/common/panel/panel_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'notifications_screen.i18n.dart';

class MenuNotifications extends StatelessWidget {
  const MenuNotifications({Key? key, required this.settings}) : super(key: key);

  final SettingsProvider settings;

  @override
  Widget build(BuildContext context) {
    return PanelButton(
      padding: const EdgeInsets.only(left: 14.0),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).push(
          CupertinoPageRoute(builder: (context) => NotificationsScreen()),
        );
      },
      title: Text(
        "notifications_screen".i18n,
        style: TextStyle(
            color: AppColors.of(context)
                .text
                .withOpacity(settings.notificationsEnabled ? 1.0 : .5)),
      ),
      leading: settings.notificationsEnabled
          ? const Icon(FeatherIcons.messageSquare)
          : Icon(FeatherIcons.messageSquare,
              color: AppColors.of(context).text.withOpacity(.25)),
      trailingDivider: true,
      trailing: Switch(
        onChanged: (v) async {
          settings.update(notificationsEnabled: v);
        },
        value: settings.notificationsEnabled,
        activeColor: Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}

class NotificationsScreen extends StatelessWidget {
  NotificationsScreen({super.key});
  late SettingsProvider settings;

  @override
  Widget build(BuildContext context) {
    settings = Provider.of<SettingsProvider>(context);
    return Scaffold(
        appBar: AppBar(
          surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
          leading: BackButton(color: AppColors.of(context).text),
          title: Text(
            "notifications_screen".i18n,
            style: TextStyle(color: AppColors.of(context).text),
          ),
        ),
        body: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
            child: SingleChildScrollView(
                child: Panel(
              child: Column(children: [
                SwitchListTile(
                  value: settings.notificationsGradesEnabled,
                  onChanged: (v) => {settings.update(notificationsGradesEnabled: v)},
                  title: Row(
                          children: [
                            GradeValueWidget(GradeValue(5, "", "", 100), fill: true, size: 30, color: settings.gradeColors[4].withOpacity(
                                      settings.notificationsGradesEnabled ? 1.0 : .5)),
                            const SizedBox(width: 14.0),
                            Expanded(
                              child: Text(
                                "grades".i18n,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.0,
                                  color: AppColors.of(context).text.withOpacity(
                                      settings.notificationsGradesEnabled ? 1.0 : .5),
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
                SwitchListTile(
                  value: settings.notificationsAbsencesEnabled,
                  onChanged: (v) => {settings.update(notificationsAbsencesEnabled: v)},
                  title: Row(
                          children: [
                            const SizedBox(width: 8),
                            settings.notificationsAbsencesEnabled
                          ? const Icon(FeatherIcons.clock)
                          : Icon(FeatherIcons.clock,
                              color:
                                  AppColors.of(context).text.withOpacity(.25)),
                            const SizedBox(width: 23.0),
                            Expanded(
                              child: Text(
                                "absences".i18n,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.0,
                                  color: AppColors.of(context).text.withOpacity(
                                      settings.notificationsAbsencesEnabled ? 1.0 : .5),
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
                SwitchListTile(
                  value: settings.notificationsMessagesEnabled,
                  onChanged: (v) => {settings.update(notificationsMessagesEnabled: v)},
                  title: Row(
                          children: [
                            const SizedBox(width: 8),
                            settings.notificationsMessagesEnabled
                          ? const Icon(FeatherIcons.messageSquare)
                          : Icon(FeatherIcons.messageSquare,
                              color:
                                  AppColors.of(context).text.withOpacity(.25)),
                            const SizedBox(width: 23.0),
                            Expanded(
                              child: Text(
                                "messages".i18n,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.0,
                                  color: AppColors.of(context).text.withOpacity(
                                      settings.notificationsMessagesEnabled ? 1.0 : .5),
                                ),
                              ),
                            ),
                          ],
                        ),
                )
              ]),
            ))));
  }
}
