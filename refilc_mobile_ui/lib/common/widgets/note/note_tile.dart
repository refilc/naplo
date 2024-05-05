import 'package:refilc_kreta_api/models/note.dart';
import 'package:refilc_mobile_ui/common/profile_image/profile_image.dart';
import 'package:flutter/material.dart';

class NoteTile extends StatelessWidget {
  const NoteTile(this.note, {super.key, this.onTap, this.padding});

  final Note note;
  final void Function()? onTap;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Padding(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 8.0),
        child: Theme(
          data: Theme.of(context).copyWith(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
          ),
          child: ListTile(
            visualDensity: VisualDensity.compact,
            contentPadding: const EdgeInsets.only(left: 8.0, right: 12.0),
            onTap: onTap,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.0)),
            leading: ProfileImage(
              isNotePfp: true,
              name: (note.teacher.isRenamed
                      ? note.teacher.renamedTo
                      : note.teacher.name) ??
                  '',
              radius: 19.2,
              backgroundColor: Theme.of(context).colorScheme.secondary,
            ),
            title: Text(
              note.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              note.content.replaceAll('\n', ' '),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            minLeadingWidth: 0,
          ),
        ),
      ),
    );
  }
}
