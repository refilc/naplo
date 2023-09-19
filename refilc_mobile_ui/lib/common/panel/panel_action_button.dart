import 'package:flutter/material.dart';

class PanelActionButton extends StatelessWidget {
  const PanelActionButton({
    Key? key,
    this.onPressed,
    this.padding = const EdgeInsets.symmetric(horizontal: 14.0),
    this.leading,
    this.title,
    this.trailing,
  }) : super(key: key);

  final void Function()? onPressed;
  final EdgeInsetsGeometry padding;
  final Widget? leading;
  final Widget? title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPressed,
      padding: padding,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(color: Theme.of(context).colorScheme.secondary.withOpacity(.6), width: 2),
      ),
      child: ListTile(
        leading: leading != null
            ? Theme(
                data: Theme.of(context).copyWith(iconTheme: IconThemeData(color: Theme.of(context).colorScheme.secondary)),
                child: leading!,
              )
            : null,
        trailing: trailing,
        title: title != null
            ? DefaultTextStyle(style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w500, fontSize: 15.0), child: title!)
            : null,
        contentPadding: EdgeInsets.zero,
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}
