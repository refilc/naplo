import 'package:filcnaplo_kreta_api/models/homework.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/homework/homework_tile.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/homework/homework_view.dart';
import 'package:flutter/material.dart';

class HomeworkViewable extends StatelessWidget {
  const HomeworkViewable(this.homework, {Key? key}) : super(key: key);

  final Homework homework;

  @override
  Widget build(BuildContext context) {
    return HomeworkTile(
      homework,
      onTap: () => HomeworkView.show(homework, context: context),
    );
  }
}
