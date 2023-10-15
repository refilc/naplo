import 'package:filcnaplo_mobile_ui/common/action_button.dart';
import 'package:filcnaplo_mobile_ui/common/soon_alert/soon_alert.i18n.dart';
import 'package:flutter/material.dart';

class SoonAlert extends StatelessWidget {
  const SoonAlert({Key? key}) : super(key: key);

  static show({required BuildContext context}) =>
      showDialog(context: context, builder: (context) => const SoonAlert());

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      title: Text('soon'.i18n),
      content: Text('soon_body'.i18n),
      actions: [
        ActionButton(label: "Ok", onTap: () => Navigator.of(context).pop())
      ],
    );
  }
}
