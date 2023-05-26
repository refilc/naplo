import 'package:filcnaplo_kreta_api/models/event.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:filcnaplo_mobile_ui/common/sliding_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter_linkify/flutter_linkify.dart';

class EventView extends StatelessWidget {
  const EventView(this.event, {Key? key}) : super(key: key);

  final Event event;

  static void show(Event event, {required BuildContext context}) => showSlidingBottomSheet(context: context, child: EventView(event));

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          ListTile(
            title: Text(
              event.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            trailing: Text(
              event.start.format(context),
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),

          // Details
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: SelectableLinkify(
              text: event.content.escapeHtml(),
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
        ],
      ),
    );
  }
}
