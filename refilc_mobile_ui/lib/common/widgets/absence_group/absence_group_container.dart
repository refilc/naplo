import 'package:flutter/material.dart';

class AbsenceGroupContainer extends InheritedWidget {
  const AbsenceGroupContainer({Key? key, required Widget child}) : super(key: key, child: child);

  static AbsenceGroupContainer? of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<AbsenceGroupContainer>();

  @override
  bool updateShouldNotify(AbsenceGroupContainer oldWidget) => false;
}
