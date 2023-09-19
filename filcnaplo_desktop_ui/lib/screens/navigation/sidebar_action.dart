import 'package:flutter/material.dart';
import 'package:filcnaplo/theme/colors/colors.dart';

class SidebarAction extends StatelessWidget {
  const SidebarAction({Key? key, this.title, this.icon, this.onTap, this.selected = false}) : super(key: key);

  final bool selected;
  final Widget? icon;
  final Widget? title;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 12.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              if (icon != null)
                IconTheme(
                  data: IconThemeData(
                    color: AppColors.of(context).text.withOpacity(selected ? 1.0 : .3),
                  ),
                  child: icon!,
                ),
              if (title != null)
                Padding(
                  padding: const EdgeInsets.only(left: 24.0),
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 500),
                    style: TextStyle(
                      color: AppColors.of(context).text.withOpacity(selected ? 1.0 : .8),
                      fontWeight: FontWeight.w500,
                      fontFamily: "Montserrat",
                    ),
                    child: title!,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
