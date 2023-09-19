import 'package:flutter/material.dart';

class RoundBorderIcon extends StatelessWidget {
  final Color color;
  final double width;
  final double padding;
  final Widget icon;

  const RoundBorderIcon(
      {Key? key,
      this.color = Colors.black,
      this.width = 1.5,
      this.padding = 5.0,
      required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: color, width: width),
        borderRadius: BorderRadius.circular(50.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: icon,
      ),
    );
  }
}
