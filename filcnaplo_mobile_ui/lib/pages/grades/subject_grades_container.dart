import 'package:flutter/material.dart';

class SubjectGradesContainer extends InheritedWidget {
  const SubjectGradesContainer({super.key, required super.child});

  static SubjectGradesContainer? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<SubjectGradesContainer>();

  @override
  bool updateShouldNotify(SubjectGradesContainer oldWidget) => false;
}
