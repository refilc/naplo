import 'package:refilc/models/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class GoalInput extends StatelessWidget {
  const GoalInput(
      {Key? key,
      required this.currentAverage,
      required this.value,
      required this.onChanged})
      : super(key: key);

  final double currentAverage;
  final double value;
  final void Function(double value) onChanged;

  void offsetToValue(Offset offset, Size size) {
    double v = ((offset.dx / size.width * 4 + 1) * 10).round() / 10;
    v = v.clamp(1.5, 5);
    v = v.clamp(((currentAverage * 10).round() / 10), 5);
    setValue(v);
  }

  void setValue(double v) {
    if (v != value) {
      HapticFeedback.lightImpact();
    }
    onChanged(v);
  }

  @override
  Widget build(BuildContext context) {
    SettingsProvider settings = Provider.of<SettingsProvider>(context);

    List<int> presets = [2, 3, 4, 5];
    presets = presets.where((e) => gradeToAvg(e) > currentAverage).toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LayoutBuilder(builder: (context, size) {
          return GestureDetector(
            onTapDown: (details) {
              offsetToValue(details.localPosition, size.biggest);
            },
            onHorizontalDragUpdate: (details) {
              offsetToValue(details.localPosition, size.biggest);
            },
            child: SizedBox(
              height: 32.0,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: CustomPaint(
                  painter: GoalSliderPainter(
                      value: (value - 1) / 4, settings: settings),
                ),
              ),
            ),
          );
        }),
        const SizedBox(height: 12.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: presets.map((e) {
            final pv = (value * 10).round() / 10;
            final selected = gradeToAvg(e) == pv;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(99.0),
                  color:
                      gradeColor(e, settings).withOpacity(selected ? 1.0 : 0.2),
                  border: Border.all(color: gradeColor(e, settings), width: 4),
                ),
                child: Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(99.0),
                    onTap: () => setValue(gradeToAvg(e)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2.0, horizontal: 24.0),
                      child: Text(
                        e.toString(),
                        style: TextStyle(
                          color:
                              selected ? Colors.white : gradeColor(e, settings),
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        )
      ],
    );
  }
}

class GoalSliderPainter extends CustomPainter {
  final double value;
  final SettingsProvider settings;

  GoalSliderPainter({required this.value, required this.settings});

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.height / 2;
    const cpadding = 4;
    final rect = Rect.fromLTWH(0, 0, size.width + radius, size.height);
    final vrect = Rect.fromLTWH(0, 0, size.width * value + radius, size.height);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        rect,
        const Radius.circular(99.0),
      ),
      Paint()..color = Colors.black.withOpacity(.1),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        vrect,
        const Radius.circular(99.0),
      ),
      Paint()
        ..shader = LinearGradient(colors: [
          settings.gradeColors[0],
          settings.gradeColors[1],
          settings.gradeColors[2],
          settings.gradeColors[3],
          settings.gradeColors[4],
        ]).createShader(rect),
    );
    canvas.drawOval(
      Rect.fromCircle(
          center: Offset(size.width * value, size.height / 2),
          radius: radius - cpadding),
      Paint()..color = Colors.white,
    );
    for (int i = 1; i < 4; i++) {
      canvas.drawOval(
        Rect.fromCircle(
            center: Offset(size.width / 4 * i, size.height / 2), radius: 4),
        Paint()..color = Colors.white.withOpacity(.5),
      );
    }
  }

  @override
  bool shouldRepaint(GoalSliderPainter oldDelegate) {
    return oldDelegate.value != value;
  }
}

double gradeToAvg(int grade) {
  return grade - 0.5;
}

Color gradeColor(int grade, SettingsProvider settings) {
  // return [
  //   const Color(0xffFF3B30),
  //   const Color(0xffFF9F0A),
  //   const Color(0xffFFD60A),
  //   const Color(0xff34C759),
  //   const Color(0xff247665),
  // ].elementAt(grade.clamp(1, 5) - 1);
  return [
    settings.gradeColors[0],
    settings.gradeColors[1],
    settings.gradeColors[2],
    settings.gradeColors[3],
    settings.gradeColors[4],
  ].elementAt(grade.clamp(1, 5) - 1);
}
