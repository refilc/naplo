import 'package:refilc/ui/date_widget.dart';
import 'package:refilc_kreta_api/models/homework.dart';
import 'package:refilc_mobile_ui/common/widgets/homework/homework_viewable.dart'
    as mobile;
import 'package:flutter/material.dart';

List<DateWidget> getWidgets(
    List<Homework> providerHomework, BuildContext context) {
  List<DateWidget> items = [];

  for (var homework in providerHomework) {
    items.add(DateWidget(
      key: homework.id,
      date: homework.deadline.year != 0 ? homework.deadline : homework.date,
      widget: mobile.HomeworkViewable(
        homework,
      ),
    ));
  }
  return items;
}
