import 'package:refilc_kreta_api/models/event.dart';
import 'package:refilc/utils/format.dart';
import 'package:refilc_mobile_ui/common/profile_image/profile_image.dart';
import 'package:flutter/material.dart';

class EventTile extends StatelessWidget {
  const EventTile(this.event, {super.key, this.onTap, this.padding});

  final Event event;
  final void Function()? onTap;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(14.0),
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
            leading: const ProfileImage(
              name: "!",
              radius: 19.2,
            ),
            title: Text(
              event.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              event.content.escapeHtml().replaceAll('\n', ' '),
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
