import 'package:filcnaplo/models/settings.dart';
import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:filcnaplo_kreta_api/models/subject.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditSubjectScreen extends StatefulWidget {
  const EditSubjectScreen({super.key, required this.subject});

  final GradeSubject subject;

  @override
  EditSubjectScreenState createState() => EditSubjectScreenState();
}

class EditSubjectScreenState extends State<EditSubjectScreen> {
  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
        leading: BackButton(color: AppColors.of(context).text),
        title: Text(
          (widget.subject.isRenamed && settingsProvider.renamedSubjectsEnabled
                  ? widget.subject.renamedTo
                  : widget.subject.name.capital()) ??
              '',
          style: TextStyle(
            color: AppColors.of(context).text,
            fontStyle: settingsProvider.renamedSubjectsItalics
                ? FontStyle.italic
                : FontStyle.normal,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          child: Column(
            children: [
              
            ],
          ),
        ),
      ),
    );
  }
}
