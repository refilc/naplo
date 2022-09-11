import 'package:filcnaplo/ui/date_widget.dart';
import 'package:filcnaplo_kreta_api/models/note.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/note/note_viewable.dart' as mobile;

List<DateWidget> getWidgets(List<Note> providerNotes) {
  List<DateWidget> items = [];
  for (var note in providerNotes) {
    items.add(DateWidget(
      key: note.id,
      date: note.date,
      widget: mobile.NoteViewable(note),
    ));
  }
  return items;
}
