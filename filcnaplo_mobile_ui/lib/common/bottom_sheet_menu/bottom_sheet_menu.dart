import 'package:filcnaplo_mobile_ui/common/bottom_sheet_menu/rounded_bottom_sheet.dart';
import 'package:flutter/material.dart';

class BottomSheetMenu extends StatelessWidget {
  const BottomSheetMenu({Key? key, this.items = const []}) : super(key: key);

  final List<Widget> items;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: items,
      ),
    );
  }
}

void showBottomSheetMenu(BuildContext context, {List<Widget> items = const []}) =>
    showRoundedModalBottomSheet(context, child: BottomSheetMenu(items: items));
