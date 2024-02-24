// ignore_for_file: use_build_context_synchronously

import 'package:refilc/api/providers/database_provider.dart';
import 'package:refilc/api/providers/self_note_provider.dart';
import 'package:refilc/api/providers/user_provider.dart';
import 'package:refilc/models/self_note.dart';
import 'package:refilc/theme/colors/colors.dart';
import 'package:refilc_kreta_api/providers/homework_provider.dart';
import 'package:refilc_mobile_ui/screens/notes/notes_screen.i18n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key, this.initialNote});

  final SelfNote? initialNote;

  @override
  AddNoteScreenState createState() => AddNoteScreenState();
}

class AddNoteScreenState extends State<AddNoteScreen> {
  late UserProvider user;
  late HomeworkProvider homeworkProvider;
  late DatabaseProvider databaseProvider;
  late SelfNoteProvider selfNoteProvider;

  final _contentController = TextEditingController();
  final _titleController = TextEditingController();

  @override
  void initState() {
    _contentController.text = widget.initialNote?.content ?? '';
    _titleController.text = widget.initialNote?.title ?? '';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context);
    homeworkProvider = Provider.of<HomeworkProvider>(context);
    databaseProvider = Provider.of<DatabaseProvider>(context);
    selfNoteProvider = Provider.of<SelfNoteProvider>(context);

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
        leading: BackButton(color: AppColors.of(context).text),
        title: Text(
          widget.initialNote == null ? 'new_note'.i18n : 'edit_note'.i18n,
          style: TextStyle(
            color: AppColors.of(context).text,
            fontSize: 26.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.1),
            child: GestureDetector(
              onTap: () async {
                // handle tap
                if (_contentController.text.replaceAll(' ', '') == '') {
                  return;
                }

                var notes = selfNoteProvider.notes;

                if (widget.initialNote == null) {
                  notes.add(SelfNote.fromJson({
                    'id': const Uuid().v4(),
                    'title': _titleController.text.replaceAll(' ', '') == ''
                        ? null
                        : _titleController.text,
                    'content': _contentController.text
                  }));
                } else {
                  var i =
                      notes.indexWhere((e) => e.id == widget.initialNote!.id);

                  notes[i] = SelfNote.fromJson({
                    'id': notes[i].id,
                    'title': _titleController.text.replaceAll(' ', '') == ''
                        ? null
                        : _titleController.text,
                    'content': _contentController.text,
                  });
                }

                await selfNoteProvider.store(notes);

                Navigator.of(context).pop();
                if (widget.initialNote != null) {
                  Navigator.of(context).pop();
                }
              },
              child: Container(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      IconTheme(
                        data: IconThemeData(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        child: const Icon(
                          FeatherIcons.check,
                          size: 20.0,
                        ),
                      ),
                      IconTheme(
                        data: IconThemeData(
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.black.withOpacity(.5)
                                  : Colors.white.withOpacity(.3),
                        ),
                        child: const Icon(
                          FeatherIcons.check,
                          size: 20.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.0),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                expands: false,
                maxLines: 1,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintText: "hint_t".i18n,
                  hintStyle: const TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _contentController,
                  expands: true,
                  minLines: null,
                  maxLines: null,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: "hint".i18n,
                    hintStyle: const TextStyle(fontSize: 16.0),
                  ),
                  textAlign: TextAlign.start,
                  style: const TextStyle(fontSize: 16.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
