import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:filcnaplo_kreta_api/models/message.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/message/message_view_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageView extends StatefulWidget {
  const MessageView(this.messages, {Key? key}) : super(key: key);

  final List<Message> messages;

  static show(List<Message> messages, {required BuildContext context}) =>
      Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(builder: (context) => MessageView(messages)));

  @override
  _MessageViewState createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 64.0,
        leading: BackButton(color: AppColors.of(context).text),
        elevation: 0,
        actions: const [
          // Padding(
          //   padding: EdgeInsets.only(right: 8.0),
          //   child: IconButton(
          //     onPressed: () {},
          //     icon: Icon(FeatherIcons.archive, color: AppColors.of(context).text),
          //     splashRadius: 32.0,
          //   ),
          // ),
        ],
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: EdgeInsets.zero,
          physics: const BouncingScrollPhysics(),
          itemCount: widget.messages.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: MessageViewTile(widget.messages[index]),
            );
          },
        ),
      ),
    );
  }
}
