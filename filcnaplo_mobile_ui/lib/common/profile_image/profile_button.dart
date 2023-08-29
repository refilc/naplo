import 'package:filcnaplo/api/providers/user_provider.dart';
import 'package:filcnaplo/models/settings.dart';
import 'package:filcnaplo/models/user.dart';
import 'package:filcnaplo_kreta_api/client/client.dart';
import 'package:filcnaplo_kreta_api/providers/absence_provider.dart';
import 'package:filcnaplo_kreta_api/providers/event_provider.dart';
import 'package:filcnaplo_kreta_api/providers/exam_provider.dart';
import 'package:filcnaplo_kreta_api/providers/grade_provider.dart';
import 'package:filcnaplo_kreta_api/providers/homework_provider.dart';
import 'package:filcnaplo_kreta_api/providers/message_provider.dart';
import 'package:filcnaplo_kreta_api/providers/note_provider.dart';
import 'package:filcnaplo_kreta_api/providers/timetable_provider.dart';
import 'package:filcnaplo_mobile_ui/common/profile_image/profile_image.dart';
import 'package:filcnaplo_mobile_ui/screens/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wtf_sliding_sheet/wtf_sliding_sheet.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton({Key? key, required this.child}) : super(key: key);

  final ProfileImage child;

  @override
  Widget build(BuildContext context) {
    final bool pMode =
        Provider.of<SettingsProvider>(context, listen: false).presentationMode;

    late UserProvider user;
    late User? account;

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

    user = Provider.of<UserProvider>(context);
    try {
      user.getUsers().forEach((acc) {
        if (user.name!.toLowerCase().replaceAll(' ', '') !=
            acc.name.toLowerCase().replaceAll(' ', '')) {
          account = acc;
        }
      });
    } catch (err) {
      account = null;
    }

    return ProfileImage(
      backgroundColor: !pMode
          ? child.backgroundColor
          : Theme.of(context).colorScheme.secondary,
      heroTag: child.heroTag,
      key: child.key,
      name: !pMode ? child.name : "János",
      radius: child.radius,
      badge: child.badge,
      role: child.role,
      profilePictureString: child.profilePictureString,
      onTap: () {
        showSlidingBottomSheet(
          context,
          useRootNavigator: true,
          builder: (context) => SlidingSheetDialog(
            color: Theme.of(context).scaffoldBackgroundColor,
            duration: const Duration(milliseconds: 400),
            scrollSpec: const ScrollSpec.bouncingScroll(),
            snapSpec: const SnapSpec(
              snap: true,
              snappings: [1.0],
              initialSnap: 1.0,
              positioning: SnapPositioning.relativeToSheetHeight,
            ),
            cornerRadius: 16,
            cornerRadiusOnFullscreen: 0,
            builder: (context, state) => Material(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: const SettingsScreen(),
            ),
          ),
        );
      },
      onLongPress: () {
        if (account != null) {
          user.setUser(account!.id);
          restore().then((_) => user.setUser(account!.id));
        }
      },
    );
  }
}
