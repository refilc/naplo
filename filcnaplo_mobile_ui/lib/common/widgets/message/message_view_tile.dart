import 'package:filcnaplo/api/providers/user_provider.dart';
import 'package:filcnaplo/utils/color.dart';
import 'package:filcnaplo_kreta_api/models/message.dart';
import 'package:filcnaplo_mobile_ui/common/panel/panel.dart';
import 'package:filcnaplo_mobile_ui/common/profile_image/profile_image.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/message/attachment_tile.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
// import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:provider/provider.dart';
import 'message_view_tile.i18n.dart';

class MessageViewTile extends StatelessWidget {
  const MessageViewTile(this.message, {Key? key}) : super(key: key);

  final Message message;

  @override
  Widget build(BuildContext context) {
    UserProvider user = Provider.of<UserProvider>(context, listen: false);
    String recipientLabel = "";

    if (message.recipients.any((r) => r.name == user.student?.name)) recipientLabel = "me".i18n;

    if (recipientLabel != "" && message.recipients.length > 1) {
      recipientLabel += " +";
      recipientLabel += message.recipients.where((r) => r.name != user.student?.name).length.toString();
    }

    if (recipientLabel == "") {
      // note: convertint to set to remove duplicates
      recipientLabel += message.recipients.map((r) => r.name).toSet().join(", ");
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
          // Subject
          Text(
            message.subject,
            softWrap: true,
            maxLines: 10,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 24.0,
            ),
          ),

          // Author
          ListTile(
            visualDensity: VisualDensity.compact,
            contentPadding: EdgeInsets.zero,
            leading: ProfileImage(
              name: message.author,
              backgroundColor: ColorUtils.stringToColor(message.author),
            ),
            title: Text(
              message.author,
              style: const TextStyle(fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            subtitle: Text(
              "to".i18n + " " + recipientLabel,
              style: const TextStyle(fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                // IconButton(
                //   onPressed: () {},
                //   icon: Icon(FeatherIcons.cornerUpLeft, color: AppColors.of(context).text),
                //   splashRadius: 24.0,
                //   padding: EdgeInsets.zero,
                //   visualDensity: VisualDensity.compact,
                // ),
                // IconButton(
                //   onPressed: () {},
                //   icon: Icon(FeatherIcons.share2, color: AppColors.of(context).text),
                //   splashRadius: 24.0,
                //   padding: EdgeInsets.zero,
                //   visualDensity: VisualDensity.compact,
                // ),
              ],
            ),
          ),

          // Content
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
