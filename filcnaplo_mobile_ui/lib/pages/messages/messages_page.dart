import 'dart:math';

import 'package:filcnaplo/api/providers/update_provider.dart';
import 'package:filcnaplo/ui/date_widget.dart';
import 'package:filcnaplo_kreta_api/providers/message_provider.dart';
import 'package:filcnaplo/api/providers/user_provider.dart';
import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:filcnaplo_kreta_api/models/message.dart';
import 'package:filcnaplo_mobile_ui/common/empty.dart';
import 'package:filcnaplo_mobile_ui/common/filter_bar.dart';
import 'package:filcnaplo_mobile_ui/common/profile_image/profile_button.dart';
import 'package:filcnaplo_mobile_ui/common/profile_image/profile_image.dart';
import 'package:filcnaplo/ui/filter/sort.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/message/message_viewable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:filcnaplo/utils/color.dart';
import 'messages_page.i18n.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> with TickerProviderStateMixin {
  late UserProvider user;
  late MessageProvider messageProvider;
  late UpdateProvider updateProvider;
  late String firstName;
  late TabController tabController;

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context);
    messageProvider = Provider.of<MessageProvider>(context);
    updateProvider = Provider.of<UpdateProvider>(context);

    List<String> nameParts = user.displayName?.split(" ") ?? ["?"];
    firstName = nameParts.length > 1 ? nameParts[1] : nameParts[0];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: NestedScrollView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          headerSliverBuilder: (context, _) => [
            SliverAppBar(
              pinned: true,
              floating: false,
              snap: false,
              centerTitle: false,
              surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
              actions: [
                // Profile Icon
                Padding(
                  padding: const EdgeInsets.only(right: 24.0),
                  child: ProfileButton(
                    child: ProfileImage(
                      heroTag: "profile",
                      name: firstName,
                      backgroundColor: ColorUtils.stringToColor(user.displayName ?? "?"),
                      badge: updateProvider.available,
                      role: user.role,
                      profilePictureString: user.picture,
                    ),
                  ),
                ),
              ],
              automaticallyImplyLeading: false,
              shadowColor: Theme.of(context).shadowColor,
              title: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "Messages".i18n,
                  style: TextStyle(color: AppColors.of(context).text, fontSize: 32.0, fontWeight: FontWeight.bold),
                ),
              ),
              bottom: FilterBar(items: [
                Tab(text: "Inbox".i18n),
                Tab(text: "Sent".i18n),
                Tab(text: "Trash".i18n),
                Tab(text: "Draft".i18n),
              ], controller: tabController),
            ),
          ],
          body: TabBarView(
              physics: const BouncingScrollPhysics(),
              controller: tabController,
              children: List.generate(4, (index) => filterViewBuilder(context, index))),
        ),
      ),
    );
  }

  List<DateWidget> getFilterWidgets(MessageType activeData) {
    List<DateWidget> items = [];
    switch (activeData) {
      case MessageType.inbox:
        for (var message in messageProvider.messages) {
          if (message.type == MessageType.inbox) {
            items.add(DateWidget(
              date: message.date,
              widget: MessageViewable(message),
            ));
          }
        }
        break;
      case MessageType.sent:
        for (var message in messageProvider.messages) {
          if (message.type == MessageType.sent) {
            items.add(DateWidget(
              date: message.date,
              widget: MessageViewable(message),
            ));
          }
        }
        break;
      case MessageType.trash:
        for (var message in messageProvider.messages) {
          if (message.type == MessageType.trash) {
            items.add(DateWidget(
              date: message.date,
              widget: MessageViewable(message),
            ));
          }
        }
        break;
      case MessageType.draft:
        for (var message in messageProvider.messages) {
          if (message.type == MessageType.draft) {
            items.add(DateWidget(
              date: message.date,
              widget: MessageViewable(message),
            ));
          }
        }
        break;
    }
    return items;
  }

  Widget filterViewBuilder(context, int activeData) {
    List<Widget> filterWidgets = sortDateWidgets(context, dateWidgets: getFilterWidgets(MessageType.values[activeData]), hasShadow: true);

    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: RefreshIndicator(
        color: Theme.of(context).colorScheme.secondary,
        onRefresh: () {
          return Future.wait([
            messageProvider.fetch(type: MessageType.inbox),
            messageProvider.fetch(type: MessageType.sent),
            messageProvider.fetch(type: MessageType.trash),
          ]);
        },
        child: ListView.builder(
          padding: EdgeInsets.zero,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) => filterWidgets.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 6.0),
                  child: filterWidgets[index],
                )
              : Empty(subtitle: "empty".i18n),
          itemCount: max(filterWidgets.length, 1),
        ),
      ),
    );
  }
}
