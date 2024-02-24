import 'package:refilc/theme/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class TickTile extends StatefulWidget {
  const TickTile({
    super.key,
    this.onTap,
    this.isTicked = false,
    required this.title,
    this.description,
    this.padding,
  });

  final Function(bool)? onTap;
  final bool isTicked;
  final String title;
  final String? description;
  final EdgeInsetsGeometry? padding;

  @override
  TickTileState createState() => TickTileState();
}

class TickTileState extends State<TickTile> {
  late bool isTicked;

  @override
  void initState() {
    isTicked = widget.isTicked;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Padding(
        padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListTile(
          onTap: () {
            widget.onTap!(!isTicked);

            setState(() {
              isTicked == true ? isTicked = false : isTicked = true;
            });
          },
          visualDensity: VisualDensity.compact,
          contentPadding: const EdgeInsets.only(left: 8.0, right: 4.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
          leading: !isTicked
              ? Padding(
                  padding: const EdgeInsets.only(top: 2.0, left: 0.8),
                  child: Container(
                    width: 20.5,
                    height: 20.5,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2.0,
                      ),
                    ),
                  ),
                )
              : Icon(
                  FeatherIcons.checkCircle,
                  size: 22.0,
                  color: Theme.of(context).colorScheme.primary,
                ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  widget.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15.5,
                    decoration: isTicked ? TextDecoration.lineThrough : null,
                    color: isTicked
                        ? AppColors.of(context).text.withOpacity(0.5)
                        : null,
                  ),
                ),
              ),
            ],
          ),
          subtitle: widget.description != null
              ? Text(
                  widget.description!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12.0,
                    color: isTicked
                        ? AppColors.of(context).text.withOpacity(0.5)
                        : null,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
