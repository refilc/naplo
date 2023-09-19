import 'package:flutter/material.dart';

class SubjectGradesContainer extends InheritedWidget {
  const SubjectGradesContainer({Key? key, required Widget child}) : super(key: key, child: child);

  static SubjectGradesContainer? of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<SubjectGradesContainer>();

  @override
  bool updateShouldNotify(SubjectGradesContainer oldWidget) => false;
}
