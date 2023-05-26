import 'package:auto_size_text/auto_size_text.dart';
import 'package:filcnaplo/ui/widgets/grade/grade_tile.dart';
import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_widget.dart';

class StatisticsTile extends StatelessWidget {
  const StatisticsTile({
    Key? key,
    required this.value,
    this.title,
    this.decimal = true,
    this.color,
    this.valueSuffix = '',
    this.fill = false,
    this.outline = false,
  }) : super(key: key);

  final double value;
  final Widget? title;
  final bool decimal;
  final Color? color;
  final String valueSuffix;
  final bool fill;
  final bool outline;

  @override
  Widget build(BuildContext context) {
    String valueText;
    if (decimal) {
      valueText = value.toStringAsFixed(2);
    } else {
      valueText = value.toStringAsFixed(0);
    }
    if (I18n.of(context).locale.languageCode != "en") valueText = valueText.replaceAll(".", ",");

    if (value.isNaN) {
      valueText = "?";
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Theme.of(context).colorScheme.background,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 21),
            blurRadius: 23.0,
            color: Theme.of(context).shadowColor,
          )
        ],
      ),
      constraints: const BoxConstraints(
        minHeight: 140.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (title != null)
            DefaultTextStyle(
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                  ),
              child: title!,
            ),
          if (title != null) const SizedBox(height: 4.0),
          Container(
            margin: const EdgeInsets.only(top: 4.0),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: fill ? (color ?? gradeColor(context: context, value: value)).withOpacity(.2) : null,
              border: outline || fill
                  ? Border.all(
                      color: (color ?? gradeColor(context: context, value: value)).withOpacity(outline ? 1.0 : 0.0),
                      width: fill ? 2.0 : 5.0,
                    )
                  : null,
              borderRadius: BorderRadius.circular(45.0),
            ),
            child: AutoSizeText.rich(
              TextSpan(
                text: valueText,
                children: [
                  if (valueSuffix != "")
                    TextSpan(
                      text: valueSuffix,
                      style: const TextStyle(fontSize: 24.0),
                    ),
                ],
              ),
              maxLines: 1,
              minFontSize: 5,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: color ?? gradeColor(context: context, value: value),
                fontWeight: FontWeight.w800,
                fontSize: 32.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
