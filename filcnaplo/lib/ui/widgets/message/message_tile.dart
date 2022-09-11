import 'package:animations/animations.dart';
import 'package:filcnaplo/models/settings.dart';
import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:filcnaplo/utils/color.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:filcnaplo_kreta_api/models/message.dart';
import 'package:filcnaplo_mobile_ui/common/profile_image/profile_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';

class MessageTile extends StatelessWidget {
  const MessageTile(
    this.message, {
    Key? key,
    this.messages,
    this.padding,
    this.onTap,
  }) : super(key: key);

  final Message message;
  final List<Message>? messages;
  final EdgeInsetsGeometry? padding;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Padding(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListTile(
          onTap: onTap,
          visualDensity: VisualDensity.compact,
          contentPadding: const EdgeInsets.only(left: 8.0, right: 4.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
          leading: !Provider.of<SettingsProvider>(context, listen: false).presentationMode
              ? ProfileImage(
                  name: message.author,
                  radius: 22.0,
                  backgroundColor: ColorUtils.stringToColor(message.author),
                )
              : ProfileImage(
                  name: "Béla",
                  radius: 22.0,
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  !Provider.of<SettingsProvider>(context, listen: false).presentationMode ? message.author : "Béla",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15.5),
                ),
              ),
              if (message.attachments.isNotEmpty) const Icon(FeatherIcons.paperclip, size: 16.0)
            ],
          ),
          subtitle: Text(
            message.subject,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0),
          ),
          trailing: Text(
            message.date.format(context),
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14.0,
              color: AppColors.of(context).text.withOpacity(.75),
            ),
          ),
        ),
      ),
    );
  }
}
