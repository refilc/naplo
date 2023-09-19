import 'package:flutter/material.dart';

class HeroDialogRoute<T> extends PageRoute<T> {
  HeroDialogRoute({required this.builder}) : super();

  final WidgetBuilder builder;

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => "livecard";

  @override
  Duration get transitionDuration => const Duration(milliseconds: 250);

  @override
  bool get maintainState => true;

  @override
  Color get barrierColor => Colors.black38;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut), child: child);
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return builder(context);
  }
}
