import 'dart:ui';

import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:flutter/material.dart';

class PanelButton extends StatelessWidget {
  const PanelButton({
    Key? key,
    this.onPressed,
    this.padding = const EdgeInsets.symmetric(horizontal: 14.0),
    this.leading,
    this.title,
    this.trailing,
    this.background = false,
    this.trailingDivider = false,
  }) : super(key: key);

  final void Function()? onPressed;
  final EdgeInsetsGeometry padding;
  final Widget? leading;
  final Widget? title;
  final Widget? trailing;
  final bool background;
  final bool trailingDivider;

  @override
  Widget build(BuildContext context) {
    final button = RawMaterialButton(
      onPressed: onPressed,
      padding: padding,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      fillColor: background ? Colors.white.withOpacity(Theme.of(context).brightness == Brightness.light ? .35 : .2) : null,
      child: ListTile(
        leading: leading != null
            ? Theme(
                data: Theme.of(context).copyWith(iconTheme: IconThemeData(color: Theme.of(context).colorScheme.secondary)),
                child: leading!,
              )
            : null,
        trailing: trailingDivider
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 6.0),
                    width: 2.0,
                    height: 32.0,
                    decoration: BoxDecoration(
                      color: AppColors.of(context).text.withOpacity(.15),
                      borderRadius: BorderRadius.circular(45.0),
                    ),
                  ),
                  if (trailing != null) trailing!,
                ],
              )
            : trailing,
        title: title != null
            ? DefaultTextStyle(style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600, fontSize: 16.0), child: title!)
            : null,
        contentPadding: EdgeInsets.zero,
        visualDensity: VisualDensity.compact,
      ),
    );

    if (!background) return button;

    return BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 12.0,
          sigmaY: 12.0,
        ),
        child: button);
  }
}
