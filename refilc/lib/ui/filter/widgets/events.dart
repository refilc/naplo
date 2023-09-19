import 'package:refilc/ui/date_widget.dart';
import 'package:refilc_kreta_api/models/event.dart';
import 'package:refilc_mobile_ui/common/widgets/event/event_viewable.dart'
    as mobile;

List<DateWidget> getWidgets(List<Event> providerEvents) {
  List<DateWidget> items = [];
  for (var event in providerEvents) {
    items.add(DateWidget(
      key: event.id,
      date: event.start,
      widget: mobile.EventViewable(event),
    ));
  }
  return items;
}
