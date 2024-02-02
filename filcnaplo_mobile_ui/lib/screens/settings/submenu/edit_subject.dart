// ignore_for_file: use_build_context_synchronously

import 'package:filcnaplo/api/providers/database_provider.dart';
import 'package:filcnaplo/api/providers/user_provider.dart';
import 'package:filcnaplo/models/settings.dart';
import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:filcnaplo_kreta_api/models/subject.dart';
import 'package:filcnaplo_kreta_api/models/teacher.dart';
import 'package:filcnaplo_kreta_api/providers/absence_provider.dart';
import 'package:filcnaplo_kreta_api/providers/grade_provider.dart';
import 'package:filcnaplo_kreta_api/providers/timetable_provider.dart';
import 'package:filcnaplo_mobile_ui/common/panel/panel_button.dart';
import 'package:filcnaplo_mobile_ui/common/splitted_panel/splitted_panel.dart';
// import 'package:filcnaplo_mobile_ui/screens/settings/settings_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';

import 'edit_subject.i18n.dart';

class EditSubjectScreen extends StatefulWidget {
  const EditSubjectScreen({
    super.key,
    required this.subject,
    required this.teacher,
  });

  final GradeSubject subject;
  final Teacher teacher;

  @override
  EditSubjectScreenState createState() => EditSubjectScreenState();
}

class EditSubjectScreenState extends State<EditSubjectScreen> {
  late SettingsProvider settingsProvider;
  late DatabaseProvider databaseProvider;
  late UserProvider user;

  final _subjectName = TextEditingController();
  final _teacherName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    settingsProvider = Provider.of<SettingsProvider>(context);
    databaseProvider = Provider.of<DatabaseProvider>(context);
    user = Provider.of<UserProvider>(context);

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
        actions: [
          IconButton(
            onPressed: () async {
              Map<String, String> subs = await databaseProvider.userQuery
                  .renamedSubjects(userId: user.id!);
              subs.remove(widget.subject.id);
              databaseProvider.userStore
                  .storeRenamedSubjects(subs, userId: user.id!);

              Map<String, String> teach = await databaseProvider.userQuery
                  .renamedTeachers(userId: user.id!);
              teach.remove(widget.teacher.id);
              databaseProvider.userStore
                  .storeRenamedTeachers(teach, userId: user.id!);

              updateProviders();

              setState(() {});
              Navigator.of(context).pop();
            },
            icon: const Icon(FeatherIcons.trash2),
          ),
          const SizedBox(
            width: 8.0,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          child: Column(
            children: [
              // rename subject
              SplittedPanel(
                padding: const EdgeInsets.only(top: 8.0),
                cardPadding: const EdgeInsets.all(4.0),
                isSeparated: true,
                children: [
                  PanelButton(
                    onPressed: () {
                      showSubjectRenameDialog();
                    },
                    title: Text("rename_it".i18n),
                    leading: Icon(
                      FeatherIcons.penTool,
                      size: 22.0,
                      color: AppColors.of(context).text.withOpacity(0.95),
                    ),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12.0),
                      bottom: Radius.circular(12.0),
                    ),
                  ),
                ],
              ),
              // rename teacher
              SplittedPanel(
                padding: const EdgeInsets.only(top: 9.0),
                cardPadding: const EdgeInsets.all(4.0),
                isSeparated: true,
                children: [
                  PanelButton(
                    onPressed: () {
                      showTeacherRenameDialog();
                    },
                    title: Text("rename_te".i18n),
                    leading: Icon(
                      FeatherIcons.user,
                      size: 22.0,
                      color: AppColors.of(context).text.withOpacity(0.95),
                    ),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12.0),
                      bottom: Radius.circular(12.0),
                    ),
                  ),
                ],
              ),
              // edit rounding
              // SplittedPanel(
              //   padding: const EdgeInsets.only(top: 9.0),
              //   cardPadding: const EdgeInsets.all(4.0),
              //   isSeparated: true,
              //   children: [
              //     PanelButton(
              //       onPressed: () {
              //         SettingsHelper.newRoundings(context, widget.subject);
              //         setState(() {});
              //       },
              //       title: Text(
              //         "rounding".i18n,
              //         style: TextStyle(
              //           color: AppColors.of(context).text.withOpacity(.95),
              //         ),
              //       ),
              //       leading: Icon(
              //         FeatherIcons.gitCommit,
              //         size: 22.0,
              //         color: AppColors.of(context).text.withOpacity(.95),
              //       ),
              //       trailing: Text(
              //         ((widget.subject.customRounding ??
              //                     settingsProvider.rounding) /
              //                 10)
              //             .toStringAsFixed(1),
              //         style: const TextStyle(fontSize: 14.0),
              //       ),
              //       borderRadius: const BorderRadius.vertical(
              //         top: Radius.circular(12.0),
              //         bottom: Radius.circular(12.0),
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }

  // rename dialogs
  void showSubjectRenameDialog() {
    _subjectName.text = widget.subject.renamedTo ?? '';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setS) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(14.0))),
          title: Text("rename_subject".i18n),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius:
                        const BorderRadius.all(Radius.circular(12.0))),
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Center(
                  child: Text(
                    widget.subject.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 16.0),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Icon(FeatherIcons.arrowDown, size: 32),
              ),
              TextField(
                controller: _subjectName,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 1.5),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 1.5),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
                  hintText: "modified_name".i18n,
                  suffixIcon: IconButton(
                    icon: const Icon(
                      FeatherIcons.x,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _subjectName.text = "";
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text(
                "cancel".i18n,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              onPressed: () {
                Navigator.of(context).maybePop();
              },
            ),
            TextButton(
              child: Text(
                "done".i18n,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              onPressed: () async {
                Map<String, String> renamedSubjs = await databaseProvider
                    .userQuery
                    .renamedSubjects(userId: user.id!);

                renamedSubjs[widget.subject.id] = _subjectName.text;

                await databaseProvider.userStore
                    .storeRenamedSubjects(renamedSubjs, userId: user.id!);

                updateProviders();

                Navigator.of(context).pop();
                setState(() {});
              },
            ),
          ],
        );
      }),
    ).then((val) {
      _subjectName.text = "";
    });
  }

  void showTeacherRenameDialog() {
    _teacherName.text = widget.teacher.renamedTo ?? '';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setS) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(14.0))),
          title: Text("rename_teacher".i18n),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius:
                        const BorderRadius.all(Radius.circular(12.0))),
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Center(
                  child: Text(
                    widget.teacher.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 16.0),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Icon(FeatherIcons.arrowDown, size: 32),
              ),
              TextField(
                controller: _teacherName,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 1.5),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 1.5),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
                  hintText: "modified_name".i18n,
                  suffixIcon: IconButton(
                    icon: const Icon(
                      FeatherIcons.x,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _teacherName.text = "";
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text(
                "cancel".i18n,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              onPressed: () {
                Navigator.of(context).maybePop();
              },
            ),
            TextButton(
              child: Text(
                "done".i18n,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              onPressed: () async {
                Map<String, String> renamedTeach = await databaseProvider
                    .userQuery
                    .renamedTeachers(userId: user.id!);

                renamedTeach[widget.teacher.id] = _teacherName.text;

                await databaseProvider.userStore
                    .storeRenamedTeachers(renamedTeach, userId: user.id!);

                updateProviders();

                Navigator.of(context).pop();
                setState(() {});
              },
            ),
          ],
        );
      }),
    ).then((val) {
      _teacherName.text = "";
    });
  }

  void updateProviders() async {
    await Provider.of<GradeProvider>(context, listen: false)
        .convertBySettings();
    await Provider.of<TimetableProvider>(context, listen: false)
        .convertBySettings();
    await Provider.of<AbsenceProvider>(context, listen: false)
        .convertBySettings();
  }
}
