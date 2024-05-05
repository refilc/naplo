import 'package:flutter/material.dart';

class AbsenceGroupContainer extends InheritedWidget {
  const AbsenceGroupContainer({super.key, required super.child});

  static AbsenceGroupContainer? of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<AbsenceGroupContainer>();

  @override
  bool updateShouldNotify(AbsenceGroupContainer oldWidget) => false;
}
