import 'package:filcnaplo_mobile_ui/screens/navigation/navbar_item.dart';
import 'package:flutter/material.dart';

class Navbar extends StatelessWidget {
  const Navbar({Key? key, required this.selectedIndex, required this.onSelected, required this.items}) : super(key: key);

  final int selectedIndex;
  final void Function(int index) onSelected;
  final List<NavItem> items;

  @override
  Widget build(BuildContext context) {
    final List<Widget> buttons = List.generate(
      items.length,
      (index) => NavbarItem(
        item: items[index],
        active: index == selectedIndex,
        onTap: () => onSelected(index),
      ),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: buttons,
    );
  }
}
