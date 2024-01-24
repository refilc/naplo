import 'package:filcnaplo/models/settings.dart';
import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:filcnaplo_mobile_ui/common/beta_chip.dart';
import 'package:filcnaplo_mobile_ui/common/panel/panel.dart';
import 'package:filcnaplo_mobile_ui/common/panel/panel_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'notifications_screen.i18n.dart';

class MenuNotifications extends StatelessWidget {
  const MenuNotifications({
    super.key,
    this.borderRadius = const BorderRadius.vertical(
        top: Radius.circular(4.0), bottom: Radius.circular(4.0)),
  });

  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return PanelButton(
      onPressed: () => Navigator.of(context, rootNavigator: true).push(
        CupertinoPageRoute(builder: (context) => const NotificationsScreen()),
      ),
      title: Row(
        children: [
          Text(
            "notifications_screen".i18n,
          ),
          const SizedBox(width: 5.0),
          const BetaChip(
            disabled: false,
          ),
        ],
      ),
      leading: Icon(
        FeatherIcons.messageSquare,
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

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SettingsProvider settings = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
        leading: BackButton(color: AppColors.of(context).text),
        title: Text(
          "notifications_screen".i18n,
          style: TextStyle(color: AppColors.of(context).text),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          child: Panel(
            child: Column(
              children: [
                Material(
                  type: MaterialType.transparency,
                  child: SwitchListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                    value: settings.notificationsGradesEnabled,
                    onChanged: (v) =>
                        settings.update(notificationsGradesEnabled: v),
                    title: Row(
                      children: [
                        Icon(
                          FeatherIcons.bookmark,
                          color: settings.notificationsGradesEnabled
                              ? Theme.of(context).colorScheme.secondary
                              : AppColors.of(context).text.withOpacity(.25),
                        ),
                        const SizedBox(width: 14.0),
                        Expanded(
                          child: Text(
                            "grades".i18n,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0,
                              color: AppColors.of(context).text.withOpacity(
                                    settings.notificationsGradesEnabled
                                        ? 1.0
                                        : .5,
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Material(
                  type: MaterialType.transparency,
                  child: SwitchListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                    value: settings.notificationsAbsencesEnabled,
                    onChanged: (v) =>
                        settings.update(notificationsAbsencesEnabled: v),
                    title: Row(
                      children: [
                        Icon(
                          FeatherIcons.clock,
                          color: settings.notificationsAbsencesEnabled
                              ? Theme.of(context).colorScheme.secondary
                              : AppColors.of(context).text.withOpacity(.25),
                        ),
                        const SizedBox(width: 14.0),
                        Expanded(
                          child: Text(
                            "absences".i18n,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0,
                              color: AppColors.of(context).text.withOpacity(
                                    settings.notificationsAbsencesEnabled
                                        ? 1.0
                                        : .5,
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Material(
                  type: MaterialType.transparency,
                  child: SwitchListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                    value: settings.notificationsMessagesEnabled,
                    onChanged: (v) =>
                        settings.update(notificationsMessagesEnabled: v),
                    title: Row(
                      children: [
                        Icon(
                          FeatherIcons.messageSquare,
                          color: settings.notificationsMessagesEnabled
                              ? Theme.of(context).colorScheme.secondary
                              : AppColors.of(context).text.withOpacity(.25),
                        ),
                        const SizedBox(width: 14.0),
                        Expanded(
                          child: Text(
                            "messages".i18n,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0,
                              color: AppColors.of(context).text.withOpacity(
                                    settings.notificationsMessagesEnabled
                                        ? 1.0
                                        : .5,
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Material(
                  type: MaterialType.transparency,
                  child: SwitchListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                    value: settings.notificationsLessonsEnabled,
                    onChanged: (v) =>
                        settings.update(notificationsLessonsEnabled: v),
                    title: Row(
                      children: [
                        Icon(
                          FeatherIcons.calendar,
                          color: settings.notificationsLessonsEnabled
                              ? Theme.of(context).colorScheme.secondary
                              : AppColors.of(context).text.withOpacity(.25),
                        ),
                        const SizedBox(width: 14.0),
                        Expanded(
                          child: Text(
                            "lessons".i18n,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0,
                              color: AppColors.of(context).text.withOpacity(
                                    settings.notificationsLessonsEnabled
                                        ? 1.0
                                        : .5,
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
