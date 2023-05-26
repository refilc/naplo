import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
SnackBar CustomSnackBar({
  required Widget content,
  required BuildContext context,
  Brightness? brightness,
  Color? backgroundColor,
  Duration? duration,
}) {
  // backgroundColor > Brightness > Theme Background
  Color _backgroundColor = backgroundColor ?? (AppColors.fromBrightness(brightness ?? Theme.of(context).brightness).highlight);
  Color textColor = AppColors.fromBrightness(brightness ?? Theme.of(context).brightness).text;

  return SnackBar(
    duration: duration ?? const Duration(seconds: 4),
    content: Container(
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(6.0),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(.15), blurRadius: 4.0)],
      ),
      padding: const EdgeInsets.all(12.0),
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: textColor, fontWeight: FontWeight.w500),
        child: content,
      ),
    ),
    backgroundColor: const Color(0x00000000),
    elevation: 0,
    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
  );
}
