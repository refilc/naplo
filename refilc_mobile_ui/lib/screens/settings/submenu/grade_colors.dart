import 'package:refilc/models/settings.dart';
import 'package:refilc/theme/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refilc/ui/flutter_colorpicker/colorpicker.dart';
import 'package:refilc/ui/widgets/grade/grade_tile.dart';
import 'package:refilc_kreta_api/models/grade.dart';
import 'package:refilc_mobile_ui/screens/settings/theme_screen.dart';
import 'submenu_screen.i18n.dart';

enum SelectedGrade { one, two, three, four, five }

class GradeColorsSettingsScreen extends StatefulWidget {
  const GradeColorsSettingsScreen({super.key});

  @override
  GradeColorsSettingsScreenState createState() =>
      GradeColorsSettingsScreenState();
}

class GradeColorsSettingsScreenState extends State<GradeColorsSettingsScreen> {
  late SettingsProvider settingsProvider;

  SelectedGrade currentEditGrade = SelectedGrade.one;

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
        leading: BackButton(
          color: AppColors.of(context).text,
          onPressed: () {
            setState(() {
              // made this cuz else it will be ugly
              currentEditGrade = SelectedGrade.one;
            });
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          "grade_colors".i18n,
          style: TextStyle(color: AppColors.of(context).text),
        ),
        actions: [
          IconButton(
            onPressed: () {
              List<Color> colors = List.castFrom(settingsProvider.gradeColors);
              var defaultColors =
                  SettingsProvider.defaultSettings().gradeColors;
              colors[currentEditGrade.index] =
                  defaultColors[currentEditGrade.index];
              settingsProvider.update(gradeColors: colors);
            },
            icon: const Icon(
              Icons.restore,
              size: 26.0,
            ),
          ),
          const SizedBox(
            width: 10.0,
          ),
        ],
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.14,
                ),
                Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        borderRadius: BorderRadius.circular(75.0),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context)
                                .colorScheme
                                .shadow
                                .withOpacity(.1),
                            blurRadius: 10.0,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(6.0),
                      child: GradeValueWidget(
                        GradeValue(currentEditGrade.index + 1, '', '', 100),
                        fill: true,
                        size: 75.0,
                        // color:
                        //     settingsProvider.gradeColors[currentEditGrade.index],
                      ),
                    ),
                    // before grades
                    if (currentEditGrade.index > 0)
                      Transform.translate(
                        offset: const Offset(-110, 16.5),
                        child: GradeValueWidget(
                          GradeValue(currentEditGrade.index, '', '', 100),
                          fill: true,
                          size: 60.0,
                          // color:
                          //     settingsProvider.gradeColors[currentEditGrade.index],
                        ),
                      ),
                    if (currentEditGrade.index > 1)
                      Transform.translate(
                        offset: const Offset(-200, 23),
                        child: GradeValueWidget(
                          GradeValue(currentEditGrade.index - 1, '', '', 100),
                          fill: true,
                          size: 50.0,
                          // color:
                          //     settingsProvider.gradeColors[currentEditGrade.index],
                        ),
                      ),
                    // after grades
                    if (currentEditGrade.index < 4)
                      Transform.translate(
                        offset: const Offset(142, 16.5),
                        child: GradeValueWidget(
                          GradeValue(currentEditGrade.index + 2, '', '', 100),
                          fill: true,
                          size: 60.0,
                          // color:
                          //     settingsProvider.gradeColors[currentEditGrade.index],
                        ),
                      ),
                    if (currentEditGrade.index < 3)
                      Transform.translate(
                        offset: const Offset(245, 23),
                        child: GradeValueWidget(
                          GradeValue(currentEditGrade.index + 3, '', '', 100),
                          fill: true,
                          size: 50.0,
                          // color:
                          //     settingsProvider.gradeColors[currentEditGrade.index],
                        ),
                      ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.14,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: SafeArea(
                    child: FilcColorPicker(
                      colorMode: CustomColorMode.grade,
                      pickerColor:
                          settingsProvider.gradeColors[currentEditGrade.index],
                      onColorChanged: (c) {
                        setState(() {
                          // update grade color
                          settingsProvider.update(
                              gradeColors: settingsProvider.gradeColors
                                ..[currentEditGrade.index] = c);
                        });
                      },
                      onColorChangeEnd: (c, {adaptive}) {
                        // update grade color
                      },
                      onThemeIdProvided: (t) {},
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0, top: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => setState(() {
                          currentEditGrade = SelectedGrade.one;
                        }),
                        child: Container(
                          width: 45.0,
                          height: 45.0,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: currentEditGrade == SelectedGrade.one
                                  ? Theme.of(context).colorScheme.secondary
                                  : Theme.of(context)
                                      .colorScheme
                                      .secondary
                                      .withOpacity(.2),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(50.0),
                            color: currentEditGrade == SelectedGrade.one
                                ? Theme.of(context).colorScheme.secondary
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              '1',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                                color: currentEditGrade == SelectedGrade.one
                                    ? Colors.white
                                    : null,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      GestureDetector(
                        onTap: () => setState(() {
                          currentEditGrade = SelectedGrade.two;
                        }),
                        child: Container(
                          width: 45.0,
                          height: 45.0,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: currentEditGrade == SelectedGrade.two
                                  ? Theme.of(context).colorScheme.secondary
                                  : Theme.of(context)
                                      .colorScheme
                                      .secondary
                                      .withOpacity(.2),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(50.0),
                            color: currentEditGrade == SelectedGrade.two
                                ? Theme.of(context).colorScheme.secondary
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              '2',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                                color: currentEditGrade == SelectedGrade.two
                                    ? Colors.white
                                    : null,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      GestureDetector(
                        onTap: () => setState(() {
                          currentEditGrade = SelectedGrade.three;
                        }),
                        child: Container(
                          width: 45.0,
                          height: 45.0,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: currentEditGrade == SelectedGrade.three
                                  ? Theme.of(context).colorScheme.secondary
                                  : Theme.of(context)
                                      .colorScheme
                                      .secondary
                                      .withOpacity(.2),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(50.0),
                            color: currentEditGrade == SelectedGrade.three
                                ? Theme.of(context).colorScheme.secondary
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              '3',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                                color: currentEditGrade == SelectedGrade.three
                                    ? Colors.white
                                    : null,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      GestureDetector(
                        onTap: () => setState(() {
                          currentEditGrade = SelectedGrade.four;
                        }),
                        child: Container(
                          width: 45.0,
                          height: 45.0,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: currentEditGrade == SelectedGrade.four
                                  ? Theme.of(context).colorScheme.secondary
                                  : Theme.of(context)
                                      .colorScheme
                                      .secondary
                                      .withOpacity(.2),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(50.0),
                            color: currentEditGrade == SelectedGrade.four
                                ? Theme.of(context).colorScheme.secondary
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              '4',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                                color: currentEditGrade == SelectedGrade.four
                                    ? Colors.white
                                    : null,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      GestureDetector(
                        onTap: () => setState(() {
                          currentEditGrade = SelectedGrade.five;
                        }),
                        child: Container(
                          width: 45.0,
                          height: 45.0,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: currentEditGrade == SelectedGrade.five
                                  ? Theme.of(context).colorScheme.secondary
                                  : Theme.of(context)
                                      .colorScheme
                                      .secondary
                                      .withOpacity(.2),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(50.0),
                            color: currentEditGrade == SelectedGrade.five
                                ? Theme.of(context).colorScheme.secondary
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              '5',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                                color: currentEditGrade == SelectedGrade.five
                                    ? Colors.white
                                    : null,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
