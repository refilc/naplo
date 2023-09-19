import 'package:flutter/material.dart';

Route loginRoute(Widget widget) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => widget,
    transitionDuration: const Duration(milliseconds: 650),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var curve = Curves.easeInOut;
      var curveTween = CurveTween(curve: curve);
      var begin = const Offset(1.0, 0.0);
      var end = Offset.zero;
      var tween = Tween(begin: begin, end: end).chain(curveTween);
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}
