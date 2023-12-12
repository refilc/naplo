import 'package:filcnaplo_kreta_api/models/message.dart';
import 'package:filcnaplo_kreta_api/providers/message_provider.dart';
// import 'package:filcnaplo_mobile_ui/common/custom_snack_bar.dart';
import 'package:filcnaplo_mobile_ui/common/material_action_button.dart';
import 'package:filcnaplo_mobile_ui/pages/messages/send_message/send_message.i18n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SendMessageSheet extends StatefulWidget {
  const SendMessageSheet(this.availableRecipients, {super.key});

  final List<SendRecipient> availableRecipients;

  @override
  SendMessageSheetState createState() => SendMessageSheetState();
}

class SendMessageSheetState extends State<SendMessageSheet> {
  late MessageProvider messageProvider;

  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  double newValue = 5.0;
  double newWeight = 100.0;

  List<Widget> buildRecipientTiles() {
    return [];
  }

  @override
  Widget build(BuildContext context) {
    messageProvider = Provider.of<MessageProvider>(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(6.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              "send_message".i18n,
              style:
                  const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
            ),
          ),

          // message recipients
          Row(children: buildRecipientTiles()),

          // message content
          Column(children: [
            Container(
              // width: 180.0,
              padding: const EdgeInsets.only(right: 12.0, left: 12.0),
              child: Center(
                child: TextField(
                  controller: _subjectController,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 18.0),
                  autocorrect: true,
                  textAlign: TextAlign.left,
                  keyboardType: TextInputType.text,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(100),
                  ],
                  decoration: InputDecoration(
                    // border: InputBorder.none,
                    // enabledBorder: InputBorder.none,
                    // focusedBorder: InputBorder.none,
                    hintText: "message_subject".i18n,
                    suffixStyle: const TextStyle(fontSize: 16.0),
                  ),
                ),
              ),
            ),
            Container(
              height: 200,
              padding: const EdgeInsets.only(right: 12.0, left: 12.0),
              child: TextField(
                controller: _messageController,
                style: const TextStyle(
                    fontWeight: FontWeight.w500, fontSize: 16.0),
                autocorrect: true,
                textAlign: TextAlign.left,
                keyboardType: TextInputType.multiline,
                maxLines: 10,
                minLines: 1,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(500),
                ],
                decoration: InputDecoration(
                  // border: InputBorder.none,
                  // enabledBorder: InputBorder.none,
                  // focusedBorder: InputBorder.none,
                  hintText: "message_text".i18n,
                  suffixStyle: const TextStyle(fontSize: 14.0),
                ),
              ),
            ),
          ]),
          Container(
            width: 120.0,
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: MaterialActionButton(
              child: Text("send".i18n),
              onPressed: () async {
                if (_messageController.text.replaceAll(' ', '') == '') {
                  return;
                }

                String subjectText =
                    _subjectController.text.replaceAll(' ', '') != ''
                        ? _subjectController.text
                        : 'Nincs tárgy';

                messageProvider.sendMessage(
                  recipients: [],
                  subject: subjectText,
                  messageText: _subjectController.text,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
