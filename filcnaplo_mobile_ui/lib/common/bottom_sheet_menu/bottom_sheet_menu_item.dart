import 'package:filcnaplo_mobile_ui/common/panel/panel_button.dart';
import 'package:flutter/material.dart';

class BottomSheetMenuItem extends StatelessWidget {
  const BottomSheetMenuItem({Key? key, required this.onPressed, required this.title, this.icon}) : super(key: key);

  final void Function()? onPressed;
  final Widget? title;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return PanelButton(
      onPressed: onPressed,
      leading: icon,
      title: title,
    );
  }
}
