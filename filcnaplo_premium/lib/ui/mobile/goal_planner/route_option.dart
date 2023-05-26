import 'package:filcnaplo_premium/ui/mobile/goal_planner/goal_planner.dart';
import 'package:filcnaplo_premium/ui/mobile/goal_planner/grade_display.dart';
import 'package:flutter/material.dart';

enum RouteMark { recommended, fastest }

class RouteOption extends StatelessWidget {
  const RouteOption({Key? key, required this.plan, this.mark, this.selected = false, required this.onSelected}) : super(key: key);

  final Plan plan;
  final RouteMark? mark;
  final bool selected;
  final void Function() onSelected;

  Widget markLabel() {
    const style = TextStyle(fontWeight: FontWeight.bold);

    switch (mark!) {
      case RouteMark.recommended:
        return const Text("Recommended", style: style);
      case RouteMark.fastest:
        return const Text("Fastest", style: style);
    }
  }

  Color markColor() {
    switch (mark) {
      case RouteMark.recommended:
        return const Color(0xff6a63d4);
      case RouteMark.fastest:
        return const Color(0xffe9d524);
      default:
        return Colors.teal;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> gradeWidgets = [];

    for (int i = 5; i > 1; i--) {
      final count = plan.plan.where((e) => e == i).length;

      if (count > 4) {
        gradeWidgets.add(Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "${count}x",
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(.7),
              ),
            ),
            const SizedBox(width: 4.0),
            GradeDisplay(grade: i),
          ],
        ));
      } else {
        gradeWidgets.addAll(List.generate(count, (_) => GradeDisplay(grade: i)));
      }

      if (count > 0) {
        gradeWidgets.add(SizedBox(
          height: 36.0,
          width: 32.0,
          child: Center(child: Icon(Icons.add, color: Colors.black.withOpacity(.5))),
        ));
      }
    }

    gradeWidgets.removeLast();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: SizedBox(
        width: double.infinity,
        child: Card(
          surfaceTintColor: selected ? markColor().withOpacity(.2) : Colors.white,
          margin: EdgeInsets.zero,
          elevation: 5,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
            side: selected ? BorderSide(color: markColor(), width: 4.0) : BorderSide.none,
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16.0),
            onTap: onSelected,
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 16.0, left: 20.0, right: 12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (mark != null) ...[
                    Chip(
                      label: markLabel(),
                      visualDensity: VisualDensity.compact,
                      backgroundColor: selected ? markColor() : Colors.transparent,
                      labelPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                      labelStyle: TextStyle(color: selected ? Colors.white : null),
                      shape: StadiumBorder(
                        side: BorderSide(
                          color: markColor(),
                          width: 3.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6.0),
                  ],
                  Wrap(
                    spacing: 4.0,
                    runSpacing: 8.0,
                    children: gradeWidgets,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
