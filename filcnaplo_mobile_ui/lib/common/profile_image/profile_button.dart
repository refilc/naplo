import 'package:filcnaplo/models/settings.dart';
import 'package:filcnaplo_mobile_ui/common/profile_image/profile_image.dart';
import 'package:filcnaplo_mobile_ui/screens/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton({Key? key, required this.child}) : super(key: key);

  final ProfileImage child;

  @override
  Widget build(BuildContext context) {
    final bool pMode = Provider.of<SettingsProvider>(context, listen: false).presentationMode;

    return ProfileImage(
      backgroundColor: !pMode ? child.backgroundColor : Theme.of(context).colorScheme.secondary,
      heroTag: child.heroTag,
      key: child.key,
      name: !pMode ? child.name : "Béla",
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
    );
  }
}
