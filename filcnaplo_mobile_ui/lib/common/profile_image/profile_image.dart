import 'dart:convert';

import 'package:filcnaplo/models/user.dart';
import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:filcnaplo_mobile_ui/common/new_content_indicator.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/utils/color.dart';

class ProfileImage extends StatefulWidget {
  const ProfileImage({
    Key? key,
    this.onTap,
    this.name,
    this.backgroundColor,
    this.radius = 20.0,
    this.heroTag,
    this.badge = false,
    this.role = Role.student,
    this.censored = false,
    this.profilePictureString = "",
  }) : super(key: key);

  final void Function()? onTap;
  final String? name;
  final Color? backgroundColor;
  final double radius;
  final String? heroTag;
  final bool badge;
  final Role? role;
  final bool censored;
  final String profilePictureString;

  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  Image? profilePicture;
  String? profPicSaved;

  @override
  void initState() {
    super.initState();
    updatePic();
  }

  void updatePic() {
    profilePicture = widget.profilePictureString != ""
        ? Image.memory(const Base64Decoder().convert(widget.profilePictureString), fit: BoxFit.scaleDown, gaplessPlayback: true)
        : null;
    profPicSaved = widget.profilePictureString;
  }

  @override
  Widget build(BuildContext context) {
    if (profPicSaved != widget.profilePictureString) updatePic();

    if (widget.heroTag == null) {
      return buildWithoutHero(context);
    } else {
      return buildWithHero(context);
    }
  }

  Widget buildWithoutHero(BuildContext context) {
    Color color = ColorUtils.foregroundColor(widget.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor);
    Color roleColor;

    if (Theme.of(context).brightness == Brightness.light) {
      roleColor = const Color(0xFF444444);
    } else {
      roleColor = const Color(0xFF555555);
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        Material(
          clipBehavior: Clip.hardEdge,
          shape: const CircleBorder(),
          color: widget.backgroundColor ?? AppColors.of(context).text.withOpacity(.15),
          child: InkWell(
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: widget.radius * 2,
              width: widget.radius * 2,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: widget.name != null && (widget.name?.trim().length ?? 0) > 0
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
                          : profilePicture ??
                              Text(
                                (widget.name?.trim().length ?? 0) > 0 ? (widget.name ?? "?").trim()[0] : "?",
                                style: TextStyle(
                                  color: color,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18.0 * (widget.radius / 20.0),
                                ),
                              ),
                    )
                  : Container(),
            ),
          ),
        ),

        // Role indicator
        if (widget.role == Role.parent)
          SizedBox(
            height: widget.radius * 2,
            width: widget.radius * 2,
            child: Container(
              alignment: Alignment.bottomRight,
              child: Icon(Icons.shield, color: roleColor, size: widget.radius / 1.3),
            ),
          ),
      ],
    );
  }

  Widget buildWithHero(BuildContext context) {
    Color color = ColorUtils.foregroundColor(widget.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor);
    Color roleColor;

    if (Theme.of(context).brightness == Brightness.light) {
      roleColor = const Color(0xFF444444);
    } else {
      roleColor = const Color(0xFF555555);
    }

    Widget child = FittedBox(
      fit: BoxFit.fitHeight,
      child: Text(
        (widget.name?.trim().length ?? 0) > 0 ? (widget.name ?? "?").trim()[0] : "?",
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 18.0 * (widget.radius / 20.0),
        ),
      ),
    );

    return SizedBox(
      height: widget.radius * 2,
      width: widget.radius * 2,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (widget.name != null && (widget.name?.trim().length ?? 0) > 0)
            Hero(
              tag: widget.heroTag! + "background",
              transitionOnUserGestures: true,
              child: Material(
                clipBehavior: Clip.hardEdge,
                shape: const CircleBorder(),
                color: profilePicture != null ? Colors.transparent : widget.backgroundColor ?? AppColors.of(context).text.withOpacity(.15),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: widget.radius * 2,
                  width: widget.radius * 2,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: profilePicture,
                ),
              ),
            ),
          Hero(
            tag: widget.heroTag! + "child",
            transitionOnUserGestures: true,
            child: Material(
              clipBehavior: Clip.hardEdge,
              shape: profilePicture != null ? const CircleBorder() : null,
              child: profilePicture ?? child,
              type: MaterialType.transparency,
            ),
          ),

          // Badge
          if (widget.badge)
            Hero(
              tag: widget.heroTag! + "new_content_indicator",
              child: NewContentIndicator(size: widget.radius * 2),
            ),

          // Role indicator
          if (widget.role == Role.parent)
            Hero(
              tag: widget.heroTag! + "role_indicator",
              child: FittedBox(
                fit: BoxFit.fitHeight,
                child: SizedBox(
                  height: widget.radius * 2,
                  width: widget.radius * 2,
                  child: Container(
                    alignment: Alignment.bottomRight,
                    child: Icon(Icons.shield, color: roleColor, size: widget.radius / 1.3),
                  ),
                ),
              ),
            ),

          Material(
            color: Colors.transparent,
            clipBehavior: Clip.hardEdge,
            shape: const CircleBorder(),
            child: InkWell(
              onTap: widget.onTap,
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
