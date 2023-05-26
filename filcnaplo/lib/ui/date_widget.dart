import 'package:flutter/widgets.dart';

class DateWidget {
  final DateTime date;
  final Widget widget;
  final String? key;
  const DateWidget({required this.date, required this.widget, this.key});
}
