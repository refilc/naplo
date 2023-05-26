import 'package:flutter/material.dart';

class NavItem {
  final String title;
  final Widget icon;
  final Widget activeIcon;

  const NavItem({required this.title, required this.icon, required this.activeIcon});
}

class NavbarItem extends StatelessWidget {
  const NavbarItem({
    Key? key,
    required this.item,
    required this.active,
    required this.onTap,
  }) : super(key: key);

  final NavItem item;
  final bool active;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    final Widget icon = active ? item.activeIcon : item.icon;

    return SafeArea(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 6.0),
          child: Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: active ? Theme.of(context).colorScheme.secondary.withOpacity(.4) : null,
              borderRadius: BorderRadius.circular(14.0),
            ),
            child: Stack(
              children: [
                IconTheme(
                  data: IconThemeData(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  child: icon,
                ),
                IconTheme(
                  data: IconThemeData(
                    color: Theme.of(context).brightness == Brightness.light ? Colors.black.withOpacity(.5) : Colors.white.withOpacity(.3),
                  ),
                  child: icon,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
