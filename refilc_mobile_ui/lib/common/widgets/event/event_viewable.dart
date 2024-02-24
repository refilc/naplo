import 'package:refilc_kreta_api/models/event.dart';
import 'package:refilc_mobile_ui/common/widgets/event/event_tile.dart';
import 'package:refilc_mobile_ui/common/widgets/event/event_view.dart';
import 'package:flutter/material.dart';

class EventViewable extends StatelessWidget {
  const EventViewable(this.event, {super.key});

  final Event event;

  @override
  Widget build(BuildContext context) {
    return EventTile(
      event,
      onTap: () => EventView.show(event, context: context),
    );
  }
}
