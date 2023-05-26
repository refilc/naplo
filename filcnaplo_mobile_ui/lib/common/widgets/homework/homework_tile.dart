import 'package:filcnaplo/helpers/subject.dart';
import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:filcnaplo_kreta_api/models/homework.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class HomeworkTile extends StatelessWidget {
  const HomeworkTile(this.homework, {Key? key, this.onTap, this.padding, this.censored = false}) : super(key: key);

  final Homework homework;
  final void Function()? onTap;
  final EdgeInsetsGeometry? padding;
  final bool censored;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.background,
      borderRadius: BorderRadius.circular(8.0),
      child: Padding(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListTile(
          visualDensity: VisualDensity.compact,
          contentPadding: const EdgeInsets.only(left: 8.0, right: 12.0),
          onTap: onTap,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          leading: SizedBox(
            width: 44,
            height: 44,
            child: censored
                ? Container(
                    decoration: BoxDecoration(
                      color: AppColors.of(context).text.withOpacity(.55),
                      borderRadius: BorderRadius.circular(60.0),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Icon(
                      SubjectIcon.resolveVariant(subjectName: homework.subjectName, context: context),
                      size: 28.0,
                      color: AppColors.of(context).text.withOpacity(.75),
                    ),
                  ),
          ),
          title: censored
              ? Wrap(
                  children: [
                    Container(
                      width: 160,
                      height: 15,
                      decoration: BoxDecoration(
                        color: AppColors.of(context).text.withOpacity(.85),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ],
                )
              : Text(
                  homework.subjectName.capital(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
          subtitle: censored
              ? Wrap(
                  children: [
                    Container(
                      width: 100,
                      height: 10,
                      decoration: BoxDecoration(
                        color: AppColors.of(context).text.withOpacity(.45),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ],
                )
              : Text(
                  homework.content.escapeHtml().replaceAll('\n', ' '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
          trailing: censored
              ? Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    color: AppColors.of(context).text.withOpacity(.45),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                )
              : Icon(
                  FeatherIcons.home,
                  color: AppColors.of(context).text.withOpacity(.75),
                ),
          minLeadingWidth: 0,
        ),
      ),
    );
  }
}
