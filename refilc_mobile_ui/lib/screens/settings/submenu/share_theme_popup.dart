// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
// import 'package:refilc/models/settings.dart';
import 'package:refilc/theme/colors/colors.dart';
import 'package:refilc_kreta_api/providers/share_provider.dart';
import 'package:refilc_mobile_ui/common/action_button.dart';
import 'package:refilc_mobile_ui/common/custom_snack_bar.dart';
import 'package:refilc_mobile_ui/common/splitted_panel/splitted_panel.dart';
import 'package:share_plus/share_plus.dart';
import 'submenu_screen.i18n.dart';

class ShareThemeDialog extends StatefulWidget {
  const ShareThemeDialog({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        title: Text("attention".i18n),
        content: Text("share_disclaimer".i18n),
        actions: [
          ActionButton(
            label: "understand".i18n,
            onTap: () async {
              Navigator.of(context).pop();

              showDialog(
                  context: context,
                  builder: (context) => const ShareThemeDialog());
            },
          ),
        ],
      ),
    );
  }

  @override
  ShareThemeDialogState createState() => ShareThemeDialogState();
}

class ShareThemeDialogState extends State<ShareThemeDialog> {
  final _title = TextEditingController();
  bool isPublic = false;

  late ShareProvider shareProvider;

  @override
  void initState() {
    super.initState();
    shareProvider = Provider.of<ShareProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(14.0))),
      contentPadding: const EdgeInsets.only(top: 10.0),
      title: Text("share_theme".i18n),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
            child: TextField(
              controller: _title,
              onEditingComplete: () async {},
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 1.5),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 1.5),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
                hintText: 'paint_title'.i18n,
                suffixIcon: IconButton(
                  icon: const Icon(
                    FeatherIcons.x,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _title.text = '';
                    });
                  },
                ),
              ),
            ),
          ),
          SplittedPanel(
            children: [
              SwitchListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                value: isPublic,
                onChanged: (value) {
                  setState(() {
                    isPublic = value;
                  });
                },
                title: Text("is_public".i18n),
                contentPadding: const EdgeInsets.only(left: 15.0, right: 10.0),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          child: Text(
            "cancel".i18n,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          onPressed: () {
            Navigator.of(context).maybePop();
          },
        ),
        TextButton(
          child: Text(
            "share_it".i18n,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          onPressed: () async {
            // share the fucking theme
            var (gradeColors, gradeColorsStatus) =
                await shareProvider.shareCurrentGradeColors(context);

            if (gradeColorsStatus == 429) {
              ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(
                content: Text("theme_share_ratelimit".i18n,
                    style: const TextStyle(color: Colors.white)),
                backgroundColor: AppColors.of(context).red,
                context: context,
              ));

              return;
            } else if (gradeColorsStatus != 201) {
              ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(
                content: Text("theme_share_failed".i18n,
                    style: const TextStyle(color: Colors.white)),
                backgroundColor: AppColors.of(context).red,
                context: context,
              ));

              return;
            }

            var (theme, themeStatus) = await shareProvider.shareCurrentTheme(
              context,
              gradeColors: gradeColors!,
              isPublic: isPublic,
              displayName: _title.text,
            );

            if (themeStatus == 429) {
              ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(
                content: Text("theme_share_ratelimit".i18n,
                    style: const TextStyle(color: Colors.white)),
                backgroundColor: AppColors.of(context).red,
                context: context,
              ));

              return;
            } else if (themeStatus != 201) {
              ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(
                content: Text("theme_share_failed".i18n,
                    style: const TextStyle(color: Colors.white)),
                backgroundColor: AppColors.of(context).red,
                context: context,
              ));

              return;
            }

            print(theme);
            print(themeStatus);

            // save theme id in settings
            // Provider.of<SettingsProvider>(context, listen: false)
            //     .update(currentThemeId: theme.id);

            // close this popup shit
            Navigator.of(context).pop(true);

            // show the share popup
            Share.share(
              theme!.id,
              subject: 'share_subj_theme'.i18n,
            );
          },
        ),
      ],
    );
  }
}
