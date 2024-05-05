import 'package:refilc/models/settings.dart';
import 'package:refilc/theme/colors/colors.dart';
import 'package:refilc/utils/format.dart';
import 'package:refilc_kreta_api/models/message.dart';
import 'package:refilc_mobile_ui/common/profile_image/profile_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';

class MessageTile extends StatelessWidget {
  const MessageTile(
    this.message, {
    super.key,
    this.messages,
    this.padding,
    this.onTap,
    this.censored = false,
  });

  final Message message;
  final List<Message>? messages;
  final EdgeInsetsGeometry? padding;
  final Function()? onTap;
  final bool censored;

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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
          leading: !Provider.of<SettingsProvider>(context, listen: false)
                  .presentationMode
              ? ProfileImage(
                  name: message.author,
                  radius: 19.2,
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  censored: censored,
                  isNotePfp: true,
                )
              : ProfileImage(
                  name: "Béla",
                  radius: 19.2,
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  censored: censored,
                  isNotePfp: true,
                ),
          title: censored
              ? Wrap(
                  children: [
                    Container(
                      width: 105,
                      height: 15,
                      decoration: BoxDecoration(
                        color: AppColors.of(context).text.withOpacity(.85),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: Text(
                        !Provider.of<SettingsProvider>(context, listen: false)
                                .presentationMode
                            ? message.author
                            : "Béla",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 15.5),
                      ),
                    ),
                    if (message.attachments.isNotEmpty)
                      const Icon(FeatherIcons.paperclip, size: 16.0)
                  ],
                ),
          subtitle: censored
              ? Wrap(
                  children: [
                    Container(
                      width: 150,
                      height: 10,
                      decoration: BoxDecoration(
                        color: AppColors.of(context).text.withOpacity(.45),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ],
                )
              : Text(
                  message.subject,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 14.0),
                ),
          trailing: censored
              ? Wrap(
                  children: [
                    Container(
                      width: 35,
                      height: 15,
                      decoration: BoxDecoration(
                        color: AppColors.of(context).text.withOpacity(.45),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ],
                )
              : Text(
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
