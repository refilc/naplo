import 'package:flutter/cupertino.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:filcnaplo_mobile_ui/common/screens.i18n.dart';

const QuickActions quickActions = QuickActions();

void setupQuickActions() {
  quickActions.setShortcutItems(<ShortcutItem>[
    ShortcutItem(type: 'action_grades', localizedTitle: 'grades'.i18n, icon: 'ic_grades'),
    ShortcutItem(type: 'action_timetable', localizedTitle: 'timetable'.i18n, icon: 'ic_timetable'),
    ShortcutItem(type: 'action_messages', localizedTitle: 'messages'.i18n, icon: 'ic_messages'),
    ShortcutItem(type: 'action_absences', localizedTitle: 'absences'.i18n, icon: 'ic_absences')
  ]);
}

void handleQuickActions(BuildContext context, void Function(String) callback) {
  quickActions.initialize((shortcutType) {
    switch (shortcutType) {
      case 'action_home':
        callback("home");
        break;
      case 'action_grades':
        callback("grades");
        break;
      case 'action_timetable':
        callback("timetable");
        break;
      case 'action_messages':
        callback("messages");
        break;
      case 'action_absences':
        callback("absences");
        break;
    }
  });
}
