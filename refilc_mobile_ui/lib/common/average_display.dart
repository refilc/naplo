import 'package:dotted_border/dotted_border.dart';
import 'package:refilc/theme/colors/colors.dart';
import 'package:refilc/ui/widgets/grade/grade_tile.dart';
import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_extension.dart';

class AverageDisplay extends StatelessWidget {
  const AverageDisplay({
    super.key,
    this.average = 0.0,
    this.border = false,
    this.dashed = false,
    this.scale = 1.0,
  });

  final double average;
  final bool border;
  final bool dashed;
  final double scale;

  @override
  Widget build(BuildContext context) {
    Color color = average == 0.0
        ? AppColors.of(context).text.withOpacity(.8)
        : gradeColor(context: context, value: average);

    String averageText = average.toStringAsFixed(2);
    if (I18n.of(context).locale.languageCode != "en") {
      averageText = averageText.replaceAll(".", ",");
    }

    Widget txtWidget = Text(
      average == 0.0 ? "-" : averageText,
      textAlign: TextAlign.center,
      style: TextStyle(
          color: color, fontWeight: FontWeight.w600, fontSize: scale * 15.0),
      maxLines: 1,
    );

    return Container(
      width: (border ? 57.0 : 54.0) * scale,
      padding: (border && dashed)
          ? null
          : EdgeInsets.symmetric(
                  horizontal: (6.0 - (border ? 2 : 0)) * scale,
                  vertical: (5.0 - (border ? 2 : 0))) *
              scale,
      decoration: BoxDecoration(
        borderRadius:
            (border && dashed) ? null : BorderRadius.circular(45.0 * scale),
        border: border && !dashed
            ? Border.fromBorderSide(
                BorderSide(color: color.withOpacity(.5), width: 1.0 * scale))
            : null,
        color: !border ? color.withOpacity(average == 0.0 ? .15 : .25) : null,
      ),
      child: (border && dashed)
          ? DottedBorder(
              strokeWidth: 1.0 * scale,
              padding: EdgeInsets.all(4.0 * scale),
              color: color.withOpacity(.5),
              dashPattern: const [6, 6],
              radius: Radius.circular(45.0 * scale),
              borderType: BorderType.RRect,
              child: Center(
                child: txtWidget,
              ),
            )
          : txtWidget,
    );
  }
}
