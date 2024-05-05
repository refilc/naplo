import 'package:refilc/api/providers/user_provider.dart';
import 'package:refilc/theme/colors/colors.dart';
import 'package:refilc_kreta_api/models/message.dart';
import 'package:refilc_mobile_ui/common/panel/panel.dart';
import 'package:refilc_mobile_ui/common/profile_image/profile_image.dart';
import 'package:refilc_mobile_ui/common/widgets/message/attachment_tile.dart';
import 'package:flutter/material.dart';
import 'package:refilc/utils/format.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
// import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:i18n_extension/i18n_extension.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'message_view_tile.i18n.dart';

class MessageViewTile extends StatelessWidget {
  const MessageViewTile(this.message, {super.key});

  final Message message;

  @override
  Widget build(BuildContext context) {
    UserProvider user = Provider.of<UserProvider>(context, listen: false);
    String recipientLabel = "";

    if (message.recipients.any((r) => r.name == user.student?.name)) {
      recipientLabel = "me".i18n;
    }

    if (recipientLabel != "" && message.recipients.length > 1) {
      recipientLabel += " +";
      recipientLabel += message.recipients
          .where((r) => r.name != user.student?.name)
          .length
          .toString();
    }

    if (recipientLabel == "") {
      // note: convertint to set to remove duplicates
      recipientLabel +=
          message.recipients.map((r) => r.name).toSet().join(", ");
    }

    List<Widget> attachments = [];
    for (var a in message.attachments) {
      attachments.add(AttachmentTile(a));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // subject
          Center(
            child: Text(
              message.subject,
              softWrap: true,
              maxLines: 10,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 24.0,
                height: 1.2,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
          ),
          const SizedBox(height: 8.0),

          // date
          Center(
            child: Text(
              DateFormat("yyyy. MM. dd.", I18n.locale.languageCode)
                  .format(message.date),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
          ),
          const SizedBox(height: 28.0),

          // author
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(
                color: Theme.of(context).colorScheme.secondary.withOpacity(.25),
                width: 1.0,
              ),
            ),
            child: ListTile(
              visualDensity: VisualDensity.compact,
              contentPadding: EdgeInsets.zero,
              leading: ProfileImage(
                isNotePfp: true,
                name: message.author,
                backgroundColor: Theme.of(context).colorScheme.secondary,
                radius: 19.0,
              ),
              title: Text(
                message.author,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              subtitle: Text(
                "${"to".i18n} $recipientLabel",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                  color: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.color
                      ?.withOpacity(0.6),
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // IconButton(
                  //   onPressed: () {},
                  //   icon: Icon(FeatherIcons.cornerUpLeft,
                  //       color: AppColors.of(context).text),
                  //   splashRadius: 24.0,
                  //   highlightColor: Colors.transparent,
                  //   padding: EdgeInsets.zero,
                  //   visualDensity: VisualDensity.compact,
                  // ),
                  IconButton(
                    onPressed: () {
                      Share.share(
                        message.content.escapeHtml(),
                        subject: 'reFilc',
                      );
                    },
                    icon: Icon(
                      FeatherIcons.share2,
                      color: AppColors.of(context).text,
                      size: 20,
                    ),
                    splashRadius: 20.0,
                    highlightColor: Colors.transparent,
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10.0),

          // content
          Panel(
            padding: const EdgeInsets.all(12.0),
            child: SelectableLinkify(
              text: message.content.escapeHtml(),
              options: const LinkifyOptions(looseUrl: true, removeWww: true),
              onOpen: (link) {
                launchUrl(
                  Uri.parse(link.url),
                  customTabsOptions: CustomTabsOptions(
                    showTitle: true,
                    colorSchemes: CustomTabsColorSchemes(
                      defaultPrams: CustomTabsColorSchemeParams(
                        toolbarColor: Theme.of(context).scaffoldBackgroundColor,
                      ),
                    ),
                  ),
                );
              },
              style: const TextStyle(fontWeight: FontWeight.w400),
            ),
          ),

          // Attachments
          ...attachments,
        ],
      ),
    );
  }
}
