// ignore_for_file: use_build_context_synchronously

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:filcnaplo_kreta_api/models/message.dart';
import 'package:filcnaplo_kreta_api/providers/message_provider.dart';
import 'package:filcnaplo_mobile_ui/common/custom_snack_bar.dart';
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

  List<SendRecipient> selectedRecipients = [];

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
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: DropdownButton2(
              items: widget.availableRecipients
                  .map((item) => DropdownMenuItem<String>(
                        value: item.kretaId.toString(),
                        child: Text(
                          "${item.name ?? (item.id ?? 'Nincs név').toString()}${item.type.code != 'TANAR' ? " (${item.type.shortName})" : ''}",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.of(context).text,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ))
                  .toList(),
              onChanged: (String? v) async {
                int kretaId = int.parse(v ?? '0');

                setState(() {
                  selectedRecipients.add(widget.availableRecipients
                      .firstWhere((e) => e.kretaId == kretaId));

                  widget.availableRecipients
                      .removeWhere((e) => e.kretaId == kretaId);
                });
              },
              iconSize: 14,
              iconEnabledColor: AppColors.of(context).text,
              iconDisabledColor: AppColors.of(context).text,
              underline: const SizedBox(),
              itemHeight: 40,
              itemPadding: const EdgeInsets.only(left: 14, right: 14),
              buttonWidth: 50,
              dropdownWidth: 300,
              dropdownPadding: null,
              buttonDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              dropdownDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
              ),
              dropdownElevation: 8,
              scrollbarRadius: const Radius.circular(40),
              scrollbarThickness: 6,
              scrollbarAlwaysShow: true,
              offset: const Offset(-10, -10),
              buttonSplashColor: Colors.transparent,
              customButton: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 2),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                child: Text(
                  selectedRecipients.isEmpty
                      ? "select_recipient".i18n
                      : selectedRecipients
                          .map((e) =>
                              '${e.name ?? (e.id ?? 'Nincs név').toString()}, ')
                          .join(),
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.of(context).text.withOpacity(0.75)),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          // Row(children: buildRecipientTiles()),

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

                var res = await messageProvider.sendMessage(
                  recipients: selectedRecipients,
                  subject: subjectText,
                  messageText: _messageController.text,
                );

                // do after send
                if (res == 'send_permission_error') {
                  ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(
                      content: Text('cant_send'.i18n), context: context));
                }

                if (res == 'successfully_sent') {
                  ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(
                      content: Text('sent'.i18n), context: context));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
