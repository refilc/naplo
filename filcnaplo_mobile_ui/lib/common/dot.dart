import 'package:flutter/material.dart';

class Dot extends StatelessWidget {
  final Color color;
  final double size;

  const Dot({Key? key, this.color = Colors.grey, this.size = 16.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      width: size,
      height: size,
    );
  }
}
