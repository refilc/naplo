import 'package:filcnaplo_mobile_ui/screens/navigation/navigation_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:quick_actions/quick_actions.dart';

const QuickActions quickActions = QuickActions();

void setupQuickActions() {
  quickActions.setShortcutItems(<ShortcutItem>[
    const ShortcutItem(
        type: 'action_home',
        localizedTitle: 'Home',
        icon: 'ic_home'),
    const ShortcutItem(
        type: 'action_grades',
        localizedTitle: 'Grades',
        icon: 'ic_grades'),
    const ShortcutItem(
        type: 'action_timetable',
        localizedTitle: 'Timetable',
        icon: 'ic_timetable'),
    const ShortcutItem(
        type: 'action_messages',
        localizedTitle: 'Messages',
        icon: 'ic_messages'),
    const ShortcutItem(
        type: 'action_absences',
        localizedTitle: 'Absences',
        icon: 'ic_absences')
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
