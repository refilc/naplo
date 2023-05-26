import 'package:flutter/material.dart';

class AbsenceSubjectViewContainer extends InheritedWidget {
  const AbsenceSubjectViewContainer({Key? key, required Widget child}) : super(key: key, child: child);

  static AbsenceSubjectViewContainer? of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<AbsenceSubjectViewContainer>();

  @override
  bool updateShouldNotify(AbsenceSubjectViewContainer oldWidget) => false;
}
