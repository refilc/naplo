import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class AbsenceDisplay extends StatelessWidget {
  const AbsenceDisplay(this.excused, this.unexcused, this.pending, {Key? key}) : super(key: key);

  final int excused;
  final int unexcused;
  final int pending;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 5.0),
      // padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
      // decoration: BoxDecoration(
      //   color: Theme.of(context).scaffoldBackgroundColor.withOpacity(.2),
      //   borderRadius: BorderRadius.circular(12.0),
      // ),
      child: Row(children: [
        if (excused > 0)
          Icon(
            FeatherIcons.check,
            size: 16.0,
            color: AppColors.of(context).green,
          ),
        if (excused > 0) const SizedBox(width: 2.0),
        if (excused > 0) Text(excused.toString(), style: const TextStyle(fontFamily: "monospace", fontSize: 14.0)),
        if (excused > 0 && pending > 0) const SizedBox(width: 6.0),
        if (pending > 0)
          Icon(
            FeatherIcons.slash,
            size: 14.0,
            color: AppColors.of(context).orange,
          ),
        if (pending > 0) const SizedBox(width: 3.0),
        if (pending > 0) Text(pending.toString(), style: const TextStyle(fontFamily: "monospace", fontSize: 14.0)),
        if (unexcused > 0 && pending > 0) const SizedBox(width: 3.0),
        if (unexcused > 0)
          Icon(
            FeatherIcons.x,
            size: 18.0,
            color: AppColors.of(context).red,
          ),
        if (unexcused > 0) Text(unexcused.toString(), style: const TextStyle(fontFamily: "monospace", fontSize: 14.0)),
      ]),
    );
  }
}
