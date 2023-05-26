import 'package:filcnaplo/models/settings.dart';
import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:filcnaplo_kreta_api/models/grade.dart';
import 'package:filcnaplo_kreta_api/providers/grade_provider.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/grade/surprise_grade.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

import 'new_grades.i18n.dart';

class NewGradesSurprise extends StatelessWidget {
  const NewGradesSurprise(this.grades, {Key? key, this.censored = false}) : super(key: key);

  final List<Grade> grades;
  final bool censored;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListTile(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Theme.of(context).colorScheme.secondary,
              width: 3.0,
            ),
            borderRadius: BorderRadius.circular(14.0),
          ),
          visualDensity: VisualDensity.compact,
          contentPadding: const EdgeInsets.only(left: 8.0, right: 12.0),
          onTap: () => openingFun(context),
          minLeadingWidth: 54,
          leading: SizedBox(
            width: 44,
            height: 44,
            child: Center(
              child: Container(
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.secondary.withOpacity(.5),
                    blurRadius: 18.0,
                  )
                ]),
                child: const RiveAnimation.asset("assets/animations/backpack-2.riv"),
              ),
            ),
          ),
          title: censored
              ? Wrap(
                  children: [
                    Container(
                      width: 85,
                      height: 15,
                      decoration: BoxDecoration(
                        color: AppColors.of(context).text.withOpacity(.85),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ],
                )
              : Text(
                  "new_grades".i18n,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
          subtitle: censored
              ? Wrap(
                  children: [
                    Container(
                      width: 125,
                      height: 10,
                      decoration: BoxDecoration(
                        color: AppColors.of(context).text.withOpacity(.45),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ],
                )
              : Text(
                  "tap_to_open".i18n,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
          trailing: censored
              ? Wrap(
                  children: [
                    Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        color: AppColors.of(context).text.withOpacity(.45),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                  ],
                )
              : Text.rich(
                  TextSpan(children: [
                    TextSpan(
                        text: "${grades.length}",
                        style: TextStyle(
                          shadows: [
                            Shadow(
                              color: AppColors.of(context).text.withOpacity(.2),
                              offset: const Offset(2, 2),
                            )
                          ],
                        )),
                    TextSpan(
                      text: "x",
                      style: TextStyle(
                        fontSize: 20.0,
                        color: AppColors.of(context).text.withOpacity(.5),
                        fontWeight: FontWeight.w800,
                      ),
                    )
                  ]),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 28.0,
                    color: AppColors.of(context).text.withOpacity(.75),
                  ),
                ),
        ),
      ),
    );
  }

  void openingFun(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    if (!settings.gradeOpeningFun) return;

    final gradeProvider = Provider.of<GradeProvider>(context, listen: false);

    final newGrades = gradeProvider.grades.where((element) => element.date.isAfter(gradeProvider.lastSeenDate)).toList();
    newGrades.sort((a, b) => a.date.compareTo(b.date));
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 100));
      for (final grade in newGrades) {
        await showDialog(
          context: context,
          builder: (context) => SurpriseGrade(grade),
          useRootNavigator: true,
          barrierDismissible: false,
          barrierColor: Colors.transparent,
          useSafeArea: false,
        );
        await Future.delayed(const Duration(milliseconds: 300));
      }
      await gradeProvider.seenAll();
    });
  }
}
