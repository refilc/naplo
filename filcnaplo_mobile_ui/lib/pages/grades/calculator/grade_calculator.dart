import 'dart:math';

import 'package:filcnaplo_kreta_api/models/category.dart';
import 'package:filcnaplo_kreta_api/models/grade.dart';
import 'package:filcnaplo_kreta_api/models/subject.dart';
import 'package:filcnaplo_mobile_ui/common/custom_snack_bar.dart';
import 'package:filcnaplo_mobile_ui/common/material_action_button.dart';
import 'package:filcnaplo/ui/widgets/grade/grade_tile.dart';
import 'package:filcnaplo_mobile_ui/pages/grades/calculator/grade_calculator_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'grade_calculator.i18n.dart';

class GradeCalculator extends StatefulWidget {
  const GradeCalculator(this.subject, {Key? key}) : super(key: key);

  final Subject subject;

  @override
  _GradeCalculatorState createState() => _GradeCalculatorState();
}

class _GradeCalculatorState extends State<GradeCalculator> {
  late GradeCalculatorProvider calculatorProvider;

  final _weightController = TextEditingController(text: "100");

  double newValue = 5.0;
  double newWeight = 100.0;

  @override
  Widget build(BuildContext context) {
    calculatorProvider = Provider.of<GradeCalculatorProvider>(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(6.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              "Grade Calculator".i18n,
              style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
            ),
          ),

          // Grade value
          Row(children: [
            Expanded(
              child: Slider(
                thumbColor: Theme.of(context).colorScheme.secondary,
                activeColor: Theme.of(context).colorScheme.secondary,
                value: newValue,
                min: 1.0,
                max: 5.0,
                divisions: 4,
                label: "${newValue.toInt()}",
                onChanged: (value) => setState(() => newValue = value),
              ),
            ),
            Container(
              width: 80.0,
              padding: const EdgeInsets.only(right: 12.0),
              child: Center(child: GradeValueWidget(GradeValue(newValue.toInt(), "", "", 0))),
            ),
          ]),

          // Grade weight
          Row(children: [
            Expanded(
              child: Slider(
                thumbColor: Theme.of(context).colorScheme.secondary,
                activeColor: Theme.of(context).colorScheme.secondary,
                value: newWeight.clamp(50, 400),
                min: 50.0,
                max: 400.0,
                divisions: 7,
                label: "${newWeight.toInt()}%",
                onChanged: (value) => setState(() {
                  newWeight = value;
                  _weightController.text = newWeight.toInt().toString();
                }),
              ),
            ),
            Container(
              width: 80.0,
              padding: const EdgeInsets.only(right: 12.0),
              child: Center(
                child: TextField(
                  controller: _weightController,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 22.0),
                  autocorrect: false,
                  textAlign: TextAlign.right,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    LengthLimitingTextInputFormatter(3),
                  ],
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: "100",
                    suffixText: "%",
                    suffixStyle: TextStyle(fontSize: 18.0),
                  ),
                  onChanged: (value) {
                    setState(() {
                      newWeight = double.tryParse(value) ?? 100.0;
                    });
                  },
                ),
              ),
            ),
          ]),
          Container(
            width: 120.0,
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: MaterialActionButton(
              child: Text("Add Grade".i18n),
              onPressed: () {
                if (calculatorProvider.ghosts.length >= 30) {
                  ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(content: Text("limit_reached".i18n), context: context));
                  return;
                }

                DateTime date;

                if (calculatorProvider.ghosts.isNotEmpty) {
                  List<Grade> grades = calculatorProvider.ghosts;
                  grades.sort((a, b) => -a.writeDate.compareTo(b.writeDate));
                  date = grades.first.date.add(const Duration(days: 7));
                } else {
                  List<Grade> grades = calculatorProvider.grades.where((e) => e.type == GradeType.midYear && e.subject == widget.subject).toList();
                  grades.sort((a, b) => -a.writeDate.compareTo(b.writeDate));
                  date = grades.first.date;
                }

                calculatorProvider.addGhost(Grade(
                  id: randomId(),
                  date: date,
                  writeDate: date,
                  description: "Ghost Grade".i18n,
                  value: GradeValue(newValue.toInt(), "", "", newWeight.toInt()),
                  teacher: "Ghost",
                  type: GradeType.ghost,
                  form: "",
                  subject: widget.subject,
                  mode: Category.fromJson({}),
                  seenDate: DateTime(0),
                  groupId: "",
                ));
              },
            ),
          ),
        ],
      ),
    );
  }

  String randomId() {
    var rng = Random();
    return rng.nextInt(1000000000).toString();
  }
}
