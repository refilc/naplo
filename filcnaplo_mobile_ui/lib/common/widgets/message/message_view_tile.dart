import 'package:filcnaplo/api/providers/user_provider.dart';
import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:filcnaplo_kreta_api/models/message.dart';
import 'package:filcnaplo_mobile_ui/common/panel/panel.dart';
import 'package:filcnaplo_mobile_ui/common/profile_image/character_image.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/message/attachment_tile.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
// import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:provider/provider.dart';
import 'message_view_tile.i18n.dart';
import 'package:share_plus/share_plus.dart';

class MessageViewTile extends StatelessWidget {
  const MessageViewTile(this.message, {Key? key}) : super(key: key);

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
              message.date.format(context),
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
                color: Theme.of(context).colorScheme.outlineVariant,
                width: 1.0,
              ),
            ),
            child: ListTile(
              visualDensity: VisualDensity.compact,
              contentPadding: EdgeInsets.zero,
              leading: CharacterImage(
                name: message.author,
                backgroundColor: Theme.of(context).colorScheme.secondary,
                radius: 22.0,
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
                "to".i18n + " " + recipientLabel,
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
                    icon: Icon(FeatherIcons.share2,
                        color: AppColors.of(context).text),
                    splashRadius: 24.0,
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
                launch(link.url,
                    customTabsOption: CustomTabsOption(
                      toolbarColor: Theme.of(context).scaffoldBackgroundColor,
                      showPageTitle: true,
                    ));
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
