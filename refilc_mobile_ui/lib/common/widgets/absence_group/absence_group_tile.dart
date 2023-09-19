import 'package:refilc/theme/colors/colors.dart';
import 'package:refilc_kreta_api/models/absence.dart';
import 'package:refilc_mobile_ui/common/widgets/absence/absence_viewable.dart';
import 'package:refilc_mobile_ui/common/widgets/absence_group/absence_group_container.dart';
import 'package:refilc_mobile_ui/common/widgets/absence/absence_tile.dart';
import 'package:refilc/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:rounded_expansion_tile/rounded_expansion_tile.dart';
import 'absence_group_tile.i18n.dart';

class AbsenceGroupTile extends StatelessWidget {
  const AbsenceGroupTile(this.absences,
      {Key? key, this.showDate = false, this.padding})
      : super(key: key);

  final List<AbsenceViewable> absences;
  final bool showDate;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    Justification state =
        getState(absences.map((e) => e.absence.state).toList());
    Color color = AbsenceTile.justificationColor(state, context: context);

    absences.sort((a, b) =>
        a.absence.lessonIndex?.compareTo(b.absence.lessonIndex ?? 0) ?? -1);

    return ClipRRect(
      borderRadius: BorderRadius.circular(14.0),
      child: Material(
        type: MaterialType.transparency,
        child: Padding(
          padding: padding ??
              const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
          child: AbsenceGroupContainer(
            child: RoundedExpansionTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              childrenPadding: const EdgeInsets.symmetric(horizontal: 8.0),
              tileColor: Colors.transparent,
              duration: const Duration(milliseconds: 250),
              trailingDuration: 0.5,
              trailing: const Icon(FeatherIcons.chevronDown),
              leading: Container(
                width: 44.0,
                height: 44.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withOpacity(.25),
                ),
                child: Center(
                    child: Icon(AbsenceTile.justificationIcon(state),
                        color: color)),
              ),
              title: Text.rich(TextSpan(
                text:
                    "${absences.where((a) => a.absence.state == state).length} ",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.of(context).text),
                children: [
                  TextSpan(
                    text: AbsenceTile.justificationName(state)
                        .fill(["absence".i18n]),
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.of(context).text),
                  ),
                ],
              )),
              subtitle: showDate
                  ? Text(
                      absences.first.absence.date
                          .format(context, weekday: true),
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: AppColors.of(context).text.withOpacity(0.8)),
                    )
                  : null,
              children: absences,
            ),
          ),
        ),
      ),
    );
  }

  static Justification getState(List<Justification> states) {
    Justification state;

    if (states.any((element) => element == Justification.unexcused)) {
      state = Justification.unexcused;
    } else if (states.any((element) => element == Justification.pending)) {
      state = Justification.pending;
    } else {
      state = Justification.excused;
    }

    return state;
  }
}
