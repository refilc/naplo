import 'package:flutter/widgets.dart';

class GradientStyles {
  static const tinta = LinearGradient(
    colors: [Color(0xffB816E0), Color(0xff17D1BB)],
  );
  static final tintaPaint = Paint()..shader = tinta.createShader(const Rect.fromLTWH(0, 0, 200, 70));

  static const kupak = LinearGradient(
    colors: [Color(0xffF0BD0C), Color(0xff0CD070)],
  );
  static final kupakPaint = Paint()..shader = kupak.createShader(const Rect.fromLTWH(0, 0, 200, 70));
}
