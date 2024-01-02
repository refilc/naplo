import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:flutter/material.dart';

class RoundBorderIcon extends StatelessWidget {
  final Color? color;
  final double width;
  final double padding;
  final Widget icon;

  const RoundBorderIcon(
      {super.key,
      this.color,
      this.width = 1.5,
      this.padding = 5.0,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
            color: color ?? AppColors.of(context).text, width: width),
        borderRadius: BorderRadius.circular(50.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: icon,
      ),
    );
  }
}
