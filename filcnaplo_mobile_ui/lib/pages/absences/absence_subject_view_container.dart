import 'package:flutter/material.dart';

class AbsenceSubjectViewContainer extends InheritedWidget {
  const AbsenceSubjectViewContainer({super.key, required super.child});

  static AbsenceSubjectViewContainer? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AbsenceSubjectViewContainer>();

  @override
  bool updateShouldNotify(AbsenceSubjectViewContainer oldWidget) => false;
}
