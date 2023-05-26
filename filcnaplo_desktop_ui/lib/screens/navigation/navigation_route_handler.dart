import 'package:animations/animations.dart';
import 'package:filcnaplo_desktop_ui/pages/absences/absences_page.dart';
import 'package:filcnaplo_desktop_ui/pages/grades/grades_page.dart';
import 'package:filcnaplo_desktop_ui/pages/home/home_page.dart';
import 'package:filcnaplo_desktop_ui/pages/messages/messages_page.dart';
import 'package:filcnaplo_desktop_ui/pages/timetable/timetable_page.dart';
import 'package:flutter/material.dart';

Route navigationRouteHandler(RouteSettings settings) {
  switch (settings.name) {
    case "grades":
      return navigationPageRoute((context) => const GradesPage());
    case "timetable":
      return navigationPageRoute((context) => const TimetablePage());
    case "messages":
      return navigationPageRoute((context) => const MessagesPage());
    case "absences":
      return navigationPageRoute((context) => const AbsencesPage());
    case "home":
    default:
      return navigationPageRoute((context) => const HomePage());
  }
}

Route navigationPageRoute(Widget Function(BuildContext) builder) {
  return PageRouteBuilder(
    pageBuilder: (context, _, __) => builder(context),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeThroughTransition(
        fillColor: Theme.of(context).scaffoldBackgroundColor,
        animation: animation,
        secondaryAnimation: secondaryAnimation,
        child: child,
      );
    },
  );
}
