// ignore_for_file: use_build_context_synchronously

import 'package:filcnaplo/api/providers/user_provider.dart';
import 'package:filcnaplo/models/settings.dart';
import 'package:filcnaplo/models/shared_theme.dart';
import 'package:filcnaplo/theme/colors/accent.dart';
import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:filcnaplo_kreta_api/providers/share_provider.dart';
import 'package:filcnaplo_mobile_ui/common/empty.dart';
import 'package:filcnaplo_mobile_ui/common/panel/panel_button.dart';
import 'package:filcnaplo_mobile_ui/common/splitted_panel/splitted_panel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:filcnaplo_mobile_ui/screens/settings/settings_screen.i18n.dart';
import 'package:share_plus/share_plus.dart';

class MenuPaintList extends StatelessWidget {
  const MenuPaintList({
    super.key,
    this.borderRadius = const BorderRadius.vertical(
        top: Radius.circular(4.0), bottom: Radius.circular(4.0)),
  });

  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return PanelButton(
      onPressed: () async {
        List<SharedTheme> publicThemes =
            await Provider.of<ShareProvider>(context, listen: false)
                .getAllPublicThemes(context);

        Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(
            builder: (context) => PaintListScreen(publicThemes: publicThemes)));
      },
      title: Text(
        "own_paints".i18n,
        style: TextStyle(
          color: AppColors.of(context).text.withOpacity(.95),
        ),
      ),
      leading: Icon(
        FeatherIcons.list,
        size: 22.0,
        color: AppColors.of(context).text.withOpacity(.95),
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

class PaintListScreen extends StatefulWidget {
  const PaintListScreen({super.key, required this.publicThemes});

  final List<SharedTheme> publicThemes;

  @override
  PaintListScreenState createState() => PaintListScreenState();
}

class PaintListScreenState extends State<PaintListScreen>
    with SingleTickerProviderStateMixin {
  late SettingsProvider settingsProvider;
  late UserProvider user;
  late ShareProvider shareProvider;

  late AnimationController _hideContainersController;

  late List<Widget> tiles;

  @override
  void initState() {
    super.initState();

    shareProvider = Provider.of<ShareProvider>(context, listen: false);

    _hideContainersController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
  }

  void buildPublicPaintTiles() async {
    List<Widget> subjectTiles = [];

    var added = [];
    var i = 0;

    for (var t in widget.publicThemes) {
      if (added.contains(t.id)) continue;

      Widget w = PanelButton(
        onPressed: () => {
          // TODO: set theme
        },
        title: Column(
          children: [
            Text(
              t.displayName,
              style: TextStyle(
                color: AppColors.of(context).text.withOpacity(.95),
              ),
            ),
            Text(
              t.nickname,
              style: TextStyle(
                color: AppColors.of(context).text.withOpacity(.75),
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 2.0),
              width: 12.0,
              height: 12.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: t.backgroundColor,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 2.0),
              width: 12.0,
              height: 12.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: t.panelsColor,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 2.0),
              width: 12.0,
              height: 12.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: t.accentColor,
              ),
            ),
          ],
        ),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(i == 0 ? 12.0 : 4.0),
          bottom:
              Radius.circular(i + 1 == widget.publicThemes.length ? 12.0 : 4.0),
        ),
      );

      i += 1;
      subjectTiles.add(w);
      added.add(t.id);
    }

    if (widget.publicThemes.isEmpty) {
      subjectTiles.add(Empty(
        subtitle: 'no_pub_paint'.i18n,
      ));
    }

    tiles = subjectTiles;
  }

  @override
  Widget build(BuildContext context) {
    settingsProvider = Provider.of<SettingsProvider>(context);
    user = Provider.of<UserProvider>(context);

    buildPublicPaintTiles();

    return AnimatedBuilder(
      animation: _hideContainersController,
      builder: (context, child) => Opacity(
        opacity: 1 - _hideContainersController.value,
        child: Scaffold(
          appBar: AppBar(
            surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
            leading: BackButton(color: AppColors.of(context).text),
            title: Text(
              "own_paints".i18n,
              style: TextStyle(color: AppColors.of(context).text),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
              child: Column(
                children: [
                  // current paint
                  SplittedPanel(
                    title: Text('current_paint'.i18n),
                    padding: EdgeInsets.zero,
                    cardPadding: const EdgeInsets.all(4.0),
                    children: [
                      PanelButton(
                        onPressed: () async {
                          SharedGradeColors gradeColors = await shareProvider
                              .shareCurrentGradeColors(context);
                          SharedTheme theme =
                              await shareProvider.shareCurrentTheme(
                            context,
                            gradeColors: gradeColors,
                          );

                          Share.share(
                            theme.id,
                            subject: 'share_subj_theme'.i18n,
                          );
                        },
                        longPressInstead: true,
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              't.displayName',
                              style: TextStyle(
                                color:
                                    AppColors.of(context).text.withOpacity(.95),
                              ),
                            ),
                            Text(
                              user.nickname ?? 'Anonymous',
                              style: TextStyle(
                                color:
                                    AppColors.of(context).text.withOpacity(.65),
                                fontSize: 15.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        trailing: Transform.translate(
                          offset: const Offset(8.0, 0.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: 2.0),
                                width: 14.0,
                                height: 14.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      (settingsProvider.customBackgroundColor ??
                                          SettingsProvider.defaultSettings()
                                              .customBackgroundColor),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.of(context)
                                          .text
                                          .withOpacity(0.15),
                                      offset: const Offset(1, 2),
                                      blurRadius: 3,
                                    ),
                                  ],
                                ),
                              ),
                              Transform.translate(
                                offset: const Offset(-4.0, 0.0),
                                child: Container(
                                  margin: const EdgeInsets.only(left: 2.0),
                                  width: 14.0,
                                  height: 14.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: (settingsProvider
                                            .customHighlightColor ??
                                        SettingsProvider.defaultSettings()
                                            .customHighlightColor),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.of(context)
                                            .text
                                            .withOpacity(0.15),
                                        offset: const Offset(1, 2),
                                        blurRadius: 3,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Transform.translate(
                                offset: const Offset(-8.0, 0.0),
                                child: Container(
                                  margin: const EdgeInsets.only(left: 2.0),
                                  width: 14.0,
                                  height: 14.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: settingsProvider.customAccentColor ??
                                        accentColorMap[
                                            settingsProvider.accentColor],
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.of(context)
                                            .text
                                            .withOpacity(0.15),
                                        offset: const Offset(1, 2),
                                        blurRadius: 3,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                          bottom: Radius.circular(12),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 18.0,
                  ),
                  // own paints
                  SplittedPanel(
                    title: Text('public_paint'.i18n),
                    padding: EdgeInsets.zero,
                    cardPadding: const EdgeInsets.all(4.0),
                    children: tiles,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
