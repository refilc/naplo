import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:filcnaplo/utils/color.dart';
import 'package:flutter/material.dart';

class MaterialActionButton extends StatelessWidget {
  const MaterialActionButton({
    super.key,
    required this.child,
    this.onPressed,
    this.backgroundColor,
  });

  final Widget child;
  final Function()? onPressed;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      shape: const StadiumBorder(),
      fillColor: backgroundColor ?? AppColors.of(context).text.withOpacity(.15),
      elevation: 0,
      highlightElevation: 0,
      onPressed: onPressed,
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w600,
              color: backgroundColor != null ? ColorUtils.foregroundColor(backgroundColor!) : null,
            ),
        child: child,
      ),
    );
  }
}
