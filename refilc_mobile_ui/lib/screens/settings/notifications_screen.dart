// import 'package:flutter/foundation.dart';
// import 'package:refilc/api/providers/database_provider.dart';
// import 'package:refilc/api/providers/user_provider.dart';
// import 'package:refilc/helpers/notification_helper.dart';
// import 'package:refilc/models/settings.dart';
// import 'package:refilc/models/user.dart';
// import 'package:refilc/theme/colors/colors.dart';
// // import 'package:refilc_mobile_ui/common/beta_chip.dart';
// import 'package:refilc_mobile_ui/common/panel/panel_button.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_feather_icons/flutter_feather_icons.dart';
// import 'package:provider/provider.dart';
// import 'package:refilc_mobile_ui/common/splitted_panel/splitted_panel.dart';
// import 'notifications_screen.i18n.dart';

// class MenuNotifications extends StatelessWidget {
//   const MenuNotifications({
//     super.key,
//     this.borderRadius = const BorderRadius.vertical(
//         top: Radius.circular(4.0), bottom: Radius.circular(4.0)),
//   });

//   final BorderRadius borderRadius;

//   @override
//   Widget build(BuildContext context) {
//     return PanelButton(
//       onPressed: () => Navigator.of(context, rootNavigator: true).push(
//         CupertinoPageRoute(builder: (context) => const NotificationsScreen()),
//       ),
//       title: Row(
//         children: [
//           Text(
//             "notifications_screen".i18n,
//           ),
//           // const SizedBox(width: 5.0),
//           // const BetaChip(
//           //   disabled: false,
//           // ),
//         ],
//       ),
//       leading: Icon(
//         FeatherIcons.messageCircle,
//         size: 22.0,
//         color: AppColors.of(context).text.withOpacity(0.95),
//       ),
//       trailing: Icon(
//         FeatherIcons.chevronRight,
//         size: 22.0,
//         color: AppColors.of(context).text.withOpacity(0.95),
//       ),
//       borderRadius: borderRadius,
//     );
//   }
// }

// class NotificationsScreen extends StatelessWidget {
//   const NotificationsScreen({super.key});

//   Set all notification categories as seen to avoid spamming the user with notifications when they turn on notifications
//   void setAll(BuildContext context, DateTime date) {
//     DatabaseProvider database =
//         Provider.of<DatabaseProvider>(context, listen: false);
//     User? user = Provider.of<UserProvider>(context, listen: false).user;
//     if (user != null) {
//       for (LastSeenCategory category in LastSeenCategory.values) {
//         database.userStore
//             .storeLastSeen(date, userId: user.id, category: category);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     SettingsProvider settings = Provider.of<SettingsProvider>(context);

//     return Scaffold(
//       appBar: AppBar(
//         surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
//         leading: BackButton(color: AppColors.of(context).text),
//         title: Text(
//           "notifications_screen".i18n,
//           style: TextStyle(color: AppColors.of(context).text),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
//           child: Column(
//             children: [
//               SplittedPanel(
//                 padding: const EdgeInsets.only(top: 8.0),
//                 cardPadding: const EdgeInsets.all(4.0),
//                 isSeparated: true,
//                 children: [
//                   PanelButton(
//                     padding: const EdgeInsets.only(left: 14.0, right: 6.0),
//                     onPressed: () {
//                       settings.update(
//                           notificationsGradesEnabled:
//                               !settings.notificationsGradesEnabled);
//                       setAll(context, DateTime.now());
//                     },
//                     title: Text(
//                       "grades".i18n,
//                       style: TextStyle(
//                         color: AppColors.of(context).text.withOpacity(
//                             settings.notificationsGradesEnabled ? .95 : .25),
//                       ),
//                     ),
//                     leading: Icon(
//                       FeatherIcons.bookmark,
//                       size: 22.0,
//                       color: AppColors.of(context).text.withOpacity(
//                           settings.notificationsGradesEnabled ? .95 : .25),
//                     ),
//                     trailing: Switch(
//                       onChanged: (v) =>
//                           settings.update(notificationsGradesEnabled: v),
//                       value: settings.notificationsGradesEnabled,
//                       activeColor: Theme.of(context).colorScheme.secondary,
//                     ),
//                     borderRadius: const BorderRadius.vertical(
//                       top: Radius.circular(12.0),
//                       bottom: Radius.circular(12.0),
//                     ),
//                   ),
//                 ],
//               ),
//               SplittedPanel(
//                 padding: const EdgeInsets.only(top: 8.0),
//                 cardPadding: const EdgeInsets.all(4.0),
//                 isSeparated: true,
//                 children: [
//                   PanelButton(
//                     padding: const EdgeInsets.only(left: 14.0, right: 6.0),
//                     onPressed: () {
//                       settings.update(
//                           notificationsAbsencesEnabled:
//                               !settings.notificationsAbsencesEnabled);
//                       setAll(context, DateTime.now());
//                     },
//                     title: Text(
//                       "absences".i18n,
//                       style: TextStyle(
//                         color: AppColors.of(context).text.withOpacity(
//                             settings.notificationsAbsencesEnabled ? .95 : .25),
//                       ),
//                     ),
//                     leading: Icon(
//                       FeatherIcons.clock,
//                       size: 22.0,
//                       color: AppColors.of(context).text.withOpacity(
//                           settings.notificationsAbsencesEnabled ? .95 : .25),
//                     ),
//                     trailing: Switch(
//                       onChanged: (v) =>
//                           settings.update(notificationsAbsencesEnabled: v),
//                       value: settings.notificationsAbsencesEnabled,
//                       activeColor: Theme.of(context).colorScheme.secondary,
//                     ),
//                     borderRadius: const BorderRadius.vertical(
//                       top: Radius.circular(12.0),
//                       bottom: Radius.circular(12.0),
//                     ),
//                   ),
//                 ],
//               ),
//               SplittedPanel(
//                 padding: const EdgeInsets.only(top: 8.0),
//                 cardPadding: const EdgeInsets.all(4.0),
//                 isSeparated: true,
//                 children: [
//                   PanelButton(
//                     padding: const EdgeInsets.only(left: 14.0, right: 6.0),
//                     onPressed: () {
//                       settings.update(
//                           notificationsMessagesEnabled:
//                               !settings.notificationsMessagesEnabled);
//                       setAll(context, DateTime.now());
//                     },
//                     title: Text(
//                       "messages".i18n,
//                       style: TextStyle(
//                         color: AppColors.of(context).text.withOpacity(
//                             settings.notificationsMessagesEnabled ? .95 : .25),
//                       ),
//                     ),
//                     leading: Icon(
//                       FeatherIcons.messageSquare,
//                       size: 22.0,
//                       color: AppColors.of(context).text.withOpacity(
//                           settings.notificationsMessagesEnabled ? .95 : .25),
//                     ),
//                     trailing: Switch(
//                       onChanged: (v) =>
//                           settings.update(notificationsMessagesEnabled: v),
//                       value: settings.notificationsMessagesEnabled,
//                       activeColor: Theme.of(context).colorScheme.secondary,
//                     ),
//                     borderRadius: const BorderRadius.vertical(
//                       top: Radius.circular(12.0),
//                       bottom: Radius.circular(12.0),
//                     ),
//                   ),
//                 ],
//               ),
//               SplittedPanel(
//                 padding: const EdgeInsets.only(top: 8.0),
//                 cardPadding: const EdgeInsets.all(4.0),
//                 isSeparated: true,
//                 children: [
//                   PanelButton(
//                     padding: const EdgeInsets.only(left: 14.0, right: 6.0),
//                     onPressed: () {
//                       settings.update(
//                           notificationsLessonsEnabled:
//                               !settings.notificationsLessonsEnabled);
//                       setAll(context, DateTime.now());
//                     },
//                     title: Text(
//                       "lessons".i18n,
//                       style: TextStyle(
//                         color: AppColors.of(context).text.withOpacity(
//                             settings.notificationsLessonsEnabled ? .95 : .25),
//                       ),
//                     ),
//                     leading: Icon(
//                       FeatherIcons.bookmark,
//                       size: 22.0,
//                       color: AppColors.of(context).text.withOpacity(
//                           settings.notificationsLessonsEnabled ? .95 : .25),
//                     ),
//                     trailing: Switch(
//                       onChanged: (v) =>
//                           settings.update(notificationsLessonsEnabled: v),
//                       value: settings.notificationsLessonsEnabled,
//                       activeColor: Theme.of(context).colorScheme.secondary,
//                     ),
//                     borderRadius: const BorderRadius.vertical(
//                       top: Radius.circular(12.0),
//                       bottom: Radius.circular(12.0),
//                     ),
//                   ),
//                 ],
//               ),
//               // only used for debugging, pressing **will** cause notification spam
//               kDebugMode
//                   ? SplittedPanel(
//                       padding: const EdgeInsets.only(top: 9.0),
//                       cardPadding: const EdgeInsets.all(4.0),
//                       isSeparated: true,
//                       children: [
//                         PanelButton(
//                           onPressed: () => setAll(
//                               context, DateTime(1970, 1, 1, 0, 0, 0, 0, 0)),
//                           title: Text("set_all_as_unseen".i18n),
//                           leading: Icon(
//                             FeatherIcons.mail,
//                             size: 22.0,
//                             color: AppColors.of(context).text.withOpacity(0.95),
//                           ),
//                           borderRadius: const BorderRadius.vertical(
//                               top: Radius.circular(12.0),
//                               bottom: Radius.circular(12.0)),
//                         )
//                       ],
//                     )
//                   : const SizedBox.shrink(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
