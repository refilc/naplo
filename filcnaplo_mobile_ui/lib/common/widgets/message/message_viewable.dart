import 'package:animations/animations.dart';
import 'package:filcnaplo_kreta_api/models/message.dart';
import 'package:filcnaplo/ui/widgets/message/message_tile.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/message/message_view.dart';
import 'package:flutter/material.dart';

class MessageViewable extends StatelessWidget {
  const MessageViewable(this.message, {Key? key}) : super(key: key);

  final Message message;

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      openBuilder: (context, _) {
        return MessageView([message]);
      },
      closedBuilder: (context, VoidCallback openContainer) {
        return MessageTile(message);
      },
      closedElevation: 0,
      openShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      closedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      middleColor: Theme.of(context).colorScheme.background,
      openColor: Theme.of(context).scaffoldBackgroundColor,
      closedColor: Theme.of(context).colorScheme.background,
      transitionType: ContainerTransitionType.fadeThrough,
      transitionDuration: const Duration(milliseconds: 400),
      useRootNavigator: true,
    );
  }
}
