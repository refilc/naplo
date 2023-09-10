import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/utils/color.dart';

class CharacterImage extends StatefulWidget {
  const CharacterImage({
    Key? key,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
    this.name,
    this.backgroundColor,
    this.radius = 20.0,
    this.heroTag,
    this.censored = false,
  }) : super(key: key);

  final void Function()? onTap;
  final void Function()? onDoubleTap;
  final void Function()? onLongPress;
  final String? name;
  final Color? backgroundColor;
  final double radius;
  final String? heroTag;
  final bool censored;

  @override
  State<CharacterImage> createState() => _CharacterImageState();
}

class _CharacterImageState extends State<CharacterImage> {
  @override
  Widget build(BuildContext context) {
    if (widget.heroTag == null) {
      return buildWithoutHero(context);
    } else {
      return buildWithHero(context);
    }
  }

  Widget buildWithoutHero(BuildContext context) {
    Color color = ColorUtils.foregroundColor(
        widget.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor);

    return Stack(
      alignment: Alignment.center,
      children: [
        Material(
          clipBehavior: Clip.hardEdge,
          shape: const CircleBorder(),
          color: widget.backgroundColor ??
              AppColors.of(context).text.withOpacity(.15),
          child: InkWell(
            onTap: widget.onTap,
            onDoubleTap: widget.onDoubleTap,
            onLongPress: widget.onLongPress,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: widget.radius * 1.7,
              width: widget.radius * 1.7,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child:
                  widget.name != null && (widget.name?.trim().length ?? 0) > 0
                      ? Center(
                          child: widget.censored
                              ? Container(
                                  width: 15,
                                  height: 15,
                                  decoration: BoxDecoration(
                                    color: color.withOpacity(.5),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                )
                              : Text(
                                  (widget.name?.trim().length ?? 0) > 0
                                      ? (widget.name ?? "?").trim()[0]
                                      : "?",
                                  style: TextStyle(
                                    color: color,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20.0 * (widget.radius / 20.0),
                                  ),
                                ),
                        )
                      : Container(),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildWithHero(BuildContext context) {
    Color color = ColorUtils.foregroundColor(
        widget.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor);

    Widget child = FittedBox(
      fit: BoxFit.fitHeight,
      child: Text(
        (widget.name?.trim().length ?? 0) > 0
            ? (widget.name ?? "?").trim()[0]
            : "?",
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 20.0 * (widget.radius / 20.0),
        ),
      ),
    );

    return SizedBox(
      height: widget.radius * 2,
      width: widget.radius * 2,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Hero(
            tag: widget.heroTag! + "child",
            transitionOnUserGestures: true,
            child: Material(
              clipBehavior: Clip.hardEdge,
              shape: null,
              child: child,
              type: MaterialType.transparency,
            ),
          ),
          Material(
            color: Colors.transparent,
            clipBehavior: Clip.hardEdge,
            shape: const CircleBorder(),
            child: InkWell(
              onTap: widget.onTap,
              onDoubleTap: widget.onDoubleTap,
              onLongPress: widget.onLongPress,
              child: SizedBox(
                height: widget.radius * 2,
                width: widget.radius * 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
