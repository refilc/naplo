import 'package:filcnaplo/ui/date_widget.dart';
import 'package:filcnaplo/ui/filter/widgets/notes.dart' as note_filter;
import 'package:filcnaplo/ui/filter/widgets/events.dart' as event_filter;
import 'package:filcnaplo_kreta_api/models/event.dart';
import 'package:filcnaplo_kreta_api/models/message.dart';
import 'package:filcnaplo_kreta_api/models/note.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/message/message_viewable.dart' as mobile;

List<DateWidget> getWidgets(List<Message> providerMessages, List<Note> providerNotes, List<Event> providerEvents) {
  List<DateWidget> items = [];
  for (var message in providerMessages) {
    if (message.type == MessageType.inbox) {
      items.add(DateWidget(
        key: "${message.id}",
        date: message.date,
        widget: mobile.MessageViewable(message),
      ));
    }
  }
  items.addAll(note_filter.getWidgets(providerNotes));
  items.addAll(event_filter.getWidgets(providerEvents));
  return items;
}
