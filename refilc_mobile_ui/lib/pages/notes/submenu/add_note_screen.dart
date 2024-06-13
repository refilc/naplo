// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:google_fonts/google_fonts.dart';
import 'package:refilc/api/providers/database_provider.dart';
import 'package:refilc/api/providers/self_note_provider.dart';
import 'package:refilc/api/providers/user_provider.dart';
import 'package:refilc/models/self_note.dart';
import 'package:refilc/theme/colors/colors.dart';
import 'package:refilc_kreta_api/providers/homework_provider.dart';
import 'package:refilc_mobile_ui/common/outlined_round_button.dart';
import 'package:refilc_mobile_ui/pages/notes/submenu/notes_screen.i18n.dart';
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
      bottomNavigationBar: Transform.translate(
        offset: Offset(0.0, -1 * MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          height: 60.0,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                width: 1.1,
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 10.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              OutlinedRoundButton(
                size: 35.0,
                onTap: () {
                  insertTextAtCur('**;c;**');
                },
                child: Text(
                  'B',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.robotoMono(
                    textStyle: const TextStyle(
                      height: 1.0,
                      fontWeight: FontWeight.w900,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10.0,
              ),
              OutlinedRoundButton(
                size: 35.0,
                onTap: () {
                  insertTextAtCur('*;c;*');
                },
                child: Text(
                  'I',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.robotoMono(
                    textStyle: const TextStyle(
                      height: 1.0,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10.0,
              ),
              OutlinedRoundButton(
                size: 35.0,
                onTap: () {
                  insertTextAtCur('`;c;`');
                },
                child: Transform.translate(
                  offset: const Offset(-0.6, -0.5),
                  child: const Icon(Icons.code_rounded),
                ),
              ),
            ],
          ),
        ),
      ),
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
                    'content': _contentController.text,
                    'note_type': 'text',
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
                    'note_type': 'text',
                  });
                }

                await selfNoteProvider.store(notes);

                Navigator.of(context).pop();
                if (widget.initialNote != null) {
                  Navigator.of(context).pop();
                }
              },
              child: Container(
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
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
              if (MediaQuery.of(context).viewInsets.bottom != 0)
                const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  void insertTextAtCur(String text) {
    var selStartPos = _contentController.selection.start;
    var selEndPost = _contentController.selection.end;
    var cursorPos = _contentController.selection.base.offset;

    String textToBefore = text.split(';c;')[0];
    String textToAfter = text.split(';c;')[1];

    if (selStartPos == selEndPost) {
      setState(() {
        _contentController.value = _contentController.value.copyWith(
          text: _contentController.text.replaceRange(
            max(cursorPos, 0),
            max(cursorPos, 0),
            textToBefore + textToAfter,
          ),
          selection: TextSelection.fromPosition(
            TextPosition(offset: max(cursorPos, 0) + textToBefore.length),
          ),
        );
      });
    } else {
      setState(() {
        _contentController.value = _contentController.value.copyWith(
          text: _contentController.text.replaceRange(
            max(selStartPos, 0),
            max(selEndPost, 0),
            textToBefore +
                _contentController.text.substring(
                  max(selStartPos, 0),
                  max(selEndPost, 0),
                ) +
                textToAfter,
          ),
          selection: TextSelection.fromPosition(
            TextPosition(
              offset: max(selEndPost, 0) + textToBefore.length,
            ),
          ),
        );
      });
    }
  }
}
