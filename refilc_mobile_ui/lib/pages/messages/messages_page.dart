import 'dart:math';

import 'package:google_fonts/google_fonts.dart';
import 'package:refilc/api/providers/update_provider.dart';
import 'package:refilc/models/settings.dart';
import 'package:refilc/ui/date_widget.dart';
import 'package:refilc_kreta_api/providers/message_provider.dart';
import 'package:refilc/api/providers/user_provider.dart';
import 'package:refilc/theme/colors/colors.dart';
import 'package:refilc_kreta_api/models/message.dart';
import 'package:refilc_mobile_ui/common/bottom_sheet_menu/rounded_bottom_sheet.dart';
import 'package:refilc_mobile_ui/common/empty.dart';
import 'package:refilc_mobile_ui/common/filter_bar.dart';
import 'package:refilc_mobile_ui/common/profile_image/profile_button.dart';
import 'package:refilc_mobile_ui/common/profile_image/profile_image.dart';
import 'package:refilc/ui/filter/sort.dart';
// import 'package:refilc_mobile_ui/common/soon_alert/soon_alert.dart';
import 'package:refilc_mobile_ui/common/widgets/message/message_viewable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'messages_page.i18n.dart';
import 'send_message/send_message.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  MessagesPageState createState() => MessagesPageState();
}

class MessagesPageState extends State<MessagesPage>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
      key: _scaffoldKey,
      body: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: NestedScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          headerSliverBuilder: (context, _) => [
            SliverAppBar(
              pinned: true,
              floating: false,
              snap: false,
              centerTitle: false,
              surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 5.0),
                  child: IconButton(
                    splashRadius: 24.0,
                    onPressed: () async {
                      // Navigator.of(context, rootNavigator: true)
                      //     .push(PageRouteBuilder(
                      //   pageBuilder: (context, animation, secondaryAnimation) =>
                      //       PremiumFSTimetable(
                      //     controller: controller,
                      //   ),
                      // ))
                      //     .then((_) {
                      //   SystemChrome.setPreferredOrientations(
                      //       [DeviceOrientation.portraitUp]);
                      //   setSystemChrome(context);
                      // });
                      // SoonAlert.show(context: context);
                      await showSendMessageSheet(context);
                    },
                    icon: Icon(
                      FeatherIcons.send,
                      color: AppColors.of(context).text,
                    ),
                  ),
                ),

                // Profile Icon
                Padding(
                  padding: const EdgeInsets.only(right: 24.0),
                  child: ProfileButton(
                    child: ProfileImage(
                      heroTag: "profile",
                      name: firstName,
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .tertiary, //ColorUtils.stringToColor(user.displayName ?? "?"),
                      badge: updateProvider.available,
                      role: user.role,
                      profilePictureString: user.picture,
                      gradeStreak: (user.gradeStreak ?? 0) > 1,
                    ),
                  ),
                ),
              ],
              automaticallyImplyLeading: false,
              shadowColor: Theme.of(context).shadowColor,
              title: Padding(
                padding: const EdgeInsets.only(left: 0.0),
                child: Row(
                  children: [
                    BackButton(
                      style: ButtonStyle(
                        splashFactory: NoSplash.splashFactory,
                        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                            EdgeInsets.zero),
                      ),
                    ),
                    Text(
                      "Messages".i18n,
                      style: Provider.of<SettingsProvider>(context)
                                      .fontFamily !=
                                  '' &&
                              Provider.of<SettingsProvider>(context)
                                  .titleOnlyFont
                          ? GoogleFonts.getFont(
                              Provider.of<SettingsProvider>(context).fontFamily,
                              textStyle: TextStyle(
                                  color: AppColors.of(context).text,
                                  fontSize: 32.0,
                                  fontWeight: FontWeight.bold),
                            )
                          : TextStyle(
                              color: AppColors.of(context).text,
                              fontSize: 32.0,
                              fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              bottom: FilterBar(
                items: [
                  Tab(text: "Inbox".i18n),
                  Tab(text: "Sent".i18n),
                  Tab(text: "Trash".i18n),
                  Tab(text: "Draft".i18n),
                ],
                controller: tabController,
                disableFading: true,
              ),
            ),
          ],
          body: TabBarView(
              physics: const BouncingScrollPhysics(),
              controller: tabController,
              children: List.generate(
                  4, (index) => filterViewBuilder(context, index))),
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
    List<Widget> filterWidgets = sortDateWidgets(context,
        dateWidgets: getFilterWidgets(MessageType.values[activeData]),
        hasShadow: true);

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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 6.0),
                  child: filterWidgets[index],
                )
              : Empty(subtitle: "empty".i18n),
          itemCount: max(filterWidgets.length, 1),
        ),
      ),
    );
  }

  Future<void> showSendMessageSheet(BuildContext context) async {
    await messageProvider.fetchAllRecipients();

    List<SendRecipient> rs = [];

    List<int> add = [];
    for (var r in messageProvider.recipients) {
      if (!add.contains(r.id)) {
        rs.add(r);
        add.add(r.id ?? 0);
      }
    }

    _scaffoldKey.currentState?.showBottomSheet(
      (context) =>
          RoundedBottomSheet(borderRadius: 14.0, child: SendMessageSheet(rs)),
      backgroundColor: const Color(0x00000000),
      elevation: 12.0,
    );
  }
}
