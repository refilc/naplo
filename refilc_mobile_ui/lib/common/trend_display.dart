import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_widget.dart';

class TrendDisplay<T extends num> extends StatelessWidget {
  const TrendDisplay({Key? key, required this.current, required this.previous, this.padding}) : super(key: key);

  final T current;
  final T previous;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    const upIcon = "▲";
    const downIcon = "▼";
    final upColor = Colors.lightGreenAccent.shade700;
    const downColor = Colors.redAccent;

    Color color;
    String icon;

    double percentage;

    if (previous > 0) {
      percentage = (current - previous) * 100.0;
    } else {
      percentage = 0.0;
    }

    final String percentageText = percentage.abs().toStringAsFixed(1).replaceAll('.', I18n.of(context).locale.languageCode != 'en' ? ',' : '.');

    if (!percentage.isNegative) {
      color = upColor;
      icon = upIcon;
    } else {
      color = downColor;
      icon = downIcon;
    }

    if (percentage == 0) {
      return const SizedBox();
    }

    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 2.0),
            child: Text(
              icon,
              style: TextStyle(fontSize: 18.0, color: color),
            ),
          ),
          Text("$percentageText%", style: TextStyle(color: color)),
        ],
      ),
    );
  }
}
