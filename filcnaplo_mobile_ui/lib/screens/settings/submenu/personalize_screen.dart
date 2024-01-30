// ignore_for_file: use_build_context_synchronously

import 'package:filcnaplo/helpers/subject.dart';
import 'package:filcnaplo/models/settings.dart';
import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:filcnaplo_kreta_api/models/subject.dart';
import 'package:filcnaplo_kreta_api/providers/grade_provider.dart';
import 'package:filcnaplo_mobile_ui/common/panel/panel_button.dart';
import 'package:filcnaplo_mobile_ui/common/splitted_panel/splitted_panel.dart';
import 'package:filcnaplo_mobile_ui/screens/settings/settings_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:filcnaplo_mobile_ui/screens/settings/settings_screen.i18n.dart';

class MenuPersonalizeSettings extends StatelessWidget {
  const MenuPersonalizeSettings({
    super.key,
    this.borderRadius = const BorderRadius.vertical(
        top: Radius.circular(4.0), bottom: Radius.circular(4.0)),
  });

  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return PanelButton(
      onPressed: () => Navigator.of(context, rootNavigator: true).push(
        CupertinoPageRoute(
            builder: (context) => const PersonalizeSettingsScreen()),
      ),
      title: Text("personalization".i18n),
      leading: Icon(
        FeatherIcons.droplet,
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

class PersonalizeSettingsScreen extends StatefulWidget {
  const PersonalizeSettingsScreen({super.key});

  @override
  PersonalizeSettingsScreenState createState() =>
      PersonalizeSettingsScreenState();
}

class PersonalizeSettingsScreenState extends State<PersonalizeSettingsScreen>
    with SingleTickerProviderStateMixin {
  late SettingsProvider settingsProvider;

  late AnimationController _hideContainersController;

  late List<GradeSubject> subjects;
  late List<Widget> tiles;

  @override
  void initState() {
    super.initState();

    subjects = Provider.of<GradeProvider>(context, listen: false)
        .grades
        .map((e) => e.subject)
        .toSet()
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));

    _hideContainersController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
  }

  void buildSubjectTiles() {
    List<Widget> subjectTiles = [];

    var i = 0;

    for (var s in subjects) {
      Widget widget = PanelButton(
        onPressed: () {
          // TODO: open subject's config page
        },
        title: Text(
          (s.isRenamed ? s.renamedTo : s.name.capital()) ?? '',
          style: TextStyle(
            color: AppColors.of(context).text.withOpacity(.95),
          ),
        ),
        leading: Icon(
          SubjectIcon.resolveVariant(context: context, subject: s),
          size: 22.0,
          color: AppColors.of(context).text.withOpacity(.95),
        ),
        trailing: Icon(
          FeatherIcons.chevronRight,
          size: 22.0,
          color: AppColors.of(context).text.withOpacity(0.95),
        ),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(i == 0 ? 12.0 : 4.0),
          bottom: Radius.circular(i + 1 == subjects.length ? 12.0 : 4.0),
        ),
      );

      i += 1;
      subjectTiles.add(widget);
    }

    tiles = subjectTiles;
  }

  @override
  Widget build(BuildContext context) {
    settingsProvider = Provider.of<SettingsProvider>(context);

    String themeModeText = {
          ThemeMode.light: "light".i18n,
          ThemeMode.dark: "dark".i18n,
          ThemeMode.system: "system".i18n
        }[settingsProvider.theme] ??
        "?";

    buildSubjectTiles();

    return AnimatedBuilder(
      animation: _hideContainersController,
      builder: (context, child) => Opacity(
        opacity: 1 - _hideContainersController.value,
        child: Scaffold(
          appBar: AppBar(
            surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
            leading: BackButton(color: AppColors.of(context).text),
            title: Text(
              "personalization".i18n,
              style: TextStyle(color: AppColors.of(context).text),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
              child: Column(
                children: [
                  SplittedPanel(
                    padding: const EdgeInsets.only(top: 8.0),
                    cardPadding: const EdgeInsets.all(4.0),
                    isSeparated: true,
                    children: [
                      PanelButton(
                        onPressed: () {
                          SettingsHelper.theme(context);
                          setState(() {});
                        },
                        title: Text("theme".i18n),
                        leading: Icon(
                          FeatherIcons.sun,
                          size: 22.0,
                          color: AppColors.of(context).text.withOpacity(0.95),
                        ),
                        trailing: Text(
                          themeModeText,
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
                        padding: const EdgeInsets.only(left: 14.0, right: 14.0),
                        onPressed: () async {
                          await _hideContainersController.forward();
                          SettingsHelper.accentColor(context);
                          setState(() {});
                          _hideContainersController.reset();
                        },
                        title: Text(
                          "color".i18n,
                          style: TextStyle(
                            color: AppColors.of(context).text.withOpacity(.95),
                          ),
                        ),
                        leading: Icon(
                          FeatherIcons.droplet,
                          size: 22.0,
                          color: AppColors.of(context).text.withOpacity(.95),
                        ),
                        trailing: Container(
                          width: 12.0,
                          height: 12.0,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            shape: BoxShape.circle,
                          ),
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
                          SettingsHelper.iconPack(context);
                        },
                        title: Text(
                          "icon_pack".i18n,
                          style: TextStyle(
                            color: AppColors.of(context).text.withOpacity(.95),
                          ),
                        ),
                        leading: Icon(
                          FeatherIcons.grid,
                          size: 22.0,
                          color: AppColors.of(context).text.withOpacity(.95),
                        ),
                        trailing: Text(
                          settingsProvider.iconPack.name.capital(),
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
                          SettingsHelper.gradeColors(context);
                          setState(() {});
                        },
                        title: Text(
                          "grade_colors".i18n,
                          style: TextStyle(
                            color: AppColors.of(context).text.withOpacity(.95),
                          ),
                        ),
                        leading: Icon(
                          FeatherIcons.star,
                          size: 22.0,
                          color: AppColors.of(context).text.withOpacity(.95),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(
                            5,
                            (i) => Container(
                              margin: const EdgeInsets.only(left: 2.0),
                              width: 12.0,
                              height: 12.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: settingsProvider.gradeColors[i],
                              ),
                            ),
                          ),
                        ),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12.0),
                          bottom: Radius.circular(12.0),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 18.0,
                  ),
                  SplittedPanel(
                    title: Text('subjects'.i18n),
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
