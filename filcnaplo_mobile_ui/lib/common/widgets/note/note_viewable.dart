import 'package:filcnaplo_kreta_api/models/note.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/note/note_tile.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/note/note_view.dart';
import 'package:flutter/material.dart';

class NoteViewable extends StatelessWidget {
  const NoteViewable(this.note, {Key? key}) : super(key: key);

  final Note note;

  @override
  Widget build(BuildContext context) {
    return NoteTile(
      note,
      onTap: () => NoteView.show(note, context: context),
    );
  }
}
