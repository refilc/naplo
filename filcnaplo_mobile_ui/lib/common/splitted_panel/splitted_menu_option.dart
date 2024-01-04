import 'package:flutter/material.dart';

class SplittedMenuOption extends StatelessWidget {
  const SplittedMenuOption({
    super.key,
    required this.text,
    this.leading,
    this.trailing,
    this.padding,
    this.onTap,
  });

  final String text;
  final Widget? leading;
  final Widget? trailing;
  final EdgeInsetsGeometry? padding;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(2.0)),
      child: InkWell(
        splashColor: Colors.grey,
        onLongPress: () {
          print('object');
        },
        onTap: onTap,
        child: Padding(
          padding: padding ?? EdgeInsets.zero,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (leading != null) leading!,
                  const SizedBox(
                    width: 16.0,
                  ),
                  Text(text),
                  const SizedBox(
                    width: 16.0,
                  ),
                ],
              ),
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}
