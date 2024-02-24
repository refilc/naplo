import 'package:refilc/models/settings.dart';
import 'package:refilc/theme/colors/colors.dart';
import 'package:refilc/utils/format.dart';
import 'package:refilc_kreta_api/models/absence.dart';
import 'package:refilc_mobile_ui/common/widgets/absence_group/absence_group_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'absence_tile.i18n.dart';

class AbsenceTile extends StatelessWidget {
  const AbsenceTile(this.absence,
      {super.key, this.onTap, this.elevation = 0.0, this.padding});

  final Absence absence;
  final void Function()? onTap;
  final double elevation;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    Color color = justificationColor(absence.state, context: context);
    bool group = AbsenceGroupContainer.of(context) != null;
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          if (elevation > 0)
            BoxShadow(
              offset: Offset(0, 21 * elevation),
              blurRadius: 23.0 * elevation,
              color: Theme.of(context).shadowColor,
            )
        ],
        borderRadius: BorderRadius.circular(14.0),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: Padding(
          // padding: padding ??
          //     (group
          //         ? EdgeInsets.zero
          //         : const EdgeInsets.symmetric(
          //             horizontal: 0.0,
          //           )),
          padding: padding ?? EdgeInsets.zero,
          child: ListTile(
            onTap: onTap,
            visualDensity: VisualDensity.compact,
            dense: group,
            contentPadding: const EdgeInsets.only(
                left: 15.5, right: 12.0, top: 2.0, bottom: 2.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(!group ? 14.0 : 12.0)),
            leading: Container(
              width: 39,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: !group ? color.withOpacity(.25) : null,
              ),
              child: Center(
                  child: Icon(justificationIcon(absence.state), color: color)),
            ),
            title: !group
                ? Text.rich(TextSpan(
                    text: "${absence.delay == 0 ? "" : absence.delay}",
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 15.5),
                    children: [
                      TextSpan(
                        text: absence.delay == 0
                            ? justificationName(absence.state)
                                .fill(["absence".i18n]).capital()
                            : 'minute'.plural(absence.delay) +
                                justificationName(absence.state)
                                    .fill(["delay".i18n]),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ))
                : Text(
                    (absence.lessonIndex != null
                            ? "${absence.lessonIndex}. "
                            : "") +
                        (absence.subject.renamedTo ??
                            absence.subject.name.capital()),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14.0,
                        fontStyle: absence.subject.isRenamed &&
                                settingsProvider.renamedSubjectsItalics
                            ? FontStyle.italic
                            : null),
                  ),
            subtitle: !group
                ? Text(
                    absence.subject.renamedTo ?? absence.subject.name.capital(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    // DateFormat("MM. dd. (EEEEE)", I18n.of(context).locale.toString()).format(absence.date),
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontStyle: absence.subject.isRenamed &&
                                settingsProvider.renamedSubjectsItalics
                            ? FontStyle.italic
                            : null),
                  )
                : null,
          ),
        ),
      ),
    );
  }

  static String justificationName(Justification state) {
    switch (state) {
      case Justification.excused:
        return "excused".i18n;
      case Justification.pending:
        return "pending".i18n;
      case Justification.unexcused:
        return "unexcused".i18n;
    }
  }

  static Color justificationColor(Justification state,
      {required BuildContext context}) {
    switch (state) {
      case Justification.excused:
        return AppColors.of(context).green;
      case Justification.pending:
        return AppColors.of(context).orange;
      case Justification.unexcused:
        return AppColors.of(context).red;
    }
  }

  static IconData justificationIcon(Justification state) {
    switch (state) {
      case Justification.excused:
        return FeatherIcons.check;
      case Justification.pending:
        return FeatherIcons.slash;
      case Justification.unexcused:
        return FeatherIcons.x;
    }
  }
}
