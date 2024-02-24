import 'package:refilc/models/user.dart';
import 'package:refilc/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:refilc/theme/colors/colors.dart';

class ProfileImage extends StatelessWidget {
  const ProfileImage({
    Key? key,
    this.name,
    this.radius = 20.0,
    this.role = Role.student,
    this.backgroundColor,
  }) : super(key: key);

  final String? name;
  final double radius;
  final Role? role;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    Color color = ColorUtils.foregroundColor(
        backgroundColor ?? Theme.of(context).scaffoldBackgroundColor);
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
          color: backgroundColor ?? AppColors.of(context).text.withOpacity(.15),
          child: InkWell(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: radius * 2,
              width: radius * 2,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: name != null && (name?.trim().length ?? 0) > 0
                  ? Center(
                      child: Text(
                        (name?.trim().length ?? 0) > 0
                            ? (name ?? "?").trim()[0]
                            : "?",
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.w600,
                          fontSize: 18.0 * (radius / 20.0),
                        ),
                      ),
                    )
                  : Container(),
            ),
          ),
        ),

        // Role indicator
        if (role == Role.parent)
          SizedBox(
            height: radius * 2,
            width: radius * 2,
            child: Container(
              alignment: Alignment.bottomRight,
              child: Icon(Icons.shield, color: roleColor, size: radius / 1.3),
            ),
          ),
      ],
    );
  }
}
