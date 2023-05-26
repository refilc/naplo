import 'dart:math';

import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:flutter/material.dart';

List<String> faces = [
  "(·.·)",
  "(≥o≤)",
  "(·_·)",
  "(˚Δ˚)b",
  "(^-^*)",
  "(='X'=)",
  "(>_<)",
  "(;-;)",
  "\\(^Д^)/",
  "\\(o_o)/",
];

class Empty extends StatelessWidget {
  const Empty({Key? key, this.subtitle}) : super(key: key);

  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    // make the face randomness a bit more constant (to avoid strokes)
    int index = Random(DateTime.now().minute).nextInt(faces.length);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text.rich(
          TextSpan(
            text: faces[index],
            style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w500, color: AppColors.of(context).text.withOpacity(.75)),
            children: subtitle != null
                ? [TextSpan(text: "\n" + subtitle!, style: TextStyle(fontSize: 18.0, height: 2.0, color: AppColors.of(context).text.withOpacity(.5)))]
                : [],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
