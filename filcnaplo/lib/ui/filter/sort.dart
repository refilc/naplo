import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:filcnaplo/ui/date_widget.dart';
import 'package:filcnaplo/ui/filter/widgets.dart';
import 'package:filcnaplo/ui/widgets/message/message_tile.dart';
import 'package:filcnaplo_kreta_api/models/message.dart';
import 'package:filcnaplo_mobile_ui/common/panel/panel.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/absence/absence_viewable.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/absence_group/absence_group_tile.dart';
import 'package:flutter/material.dart';
import 'package:implicitly_animated_reorderable_list_2/implicitly_animated_reorderable_list_2.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/lesson/changed_lesson_tile.dart';
import 'package:filcnaplo/utils/format.dart';

// difference.inDays is not reliable
bool _sameDate(DateTime a, DateTime b) => (a.year == b.year && a.month == b.month && a.day == b.day);

List<Widget> sortDateWidgets(
  BuildContext context, {
  required List<DateWidget> dateWidgets,
  bool showTitle = true,
  bool showDivider = false,
  bool hasShadow = false,
  EdgeInsetsGeometry? padding,
}) {
  dateWidgets.sort((a, b) => -a.date.compareTo(b.date));

  List<Conversation> conversations = [];
  List<DateWidget> convMessages = [];

  // Group messages into conversations
  for (var w in dateWidgets) {
    if (w.widget.runtimeType == MessageTile) {
      Message message = (w.widget as MessageTile).message;

      if (message.conversationId != null) {
        convMessages.add(w);

        Conversation conv = conversations.firstWhere((e) => e.id == message.conversationId, orElse: () => Conversation(id: message.conversationId!));
        conv.add(message);
        if (conv.messages.length == 1) conversations.add(conv);
      }

      if (conversations.any((c) => c.id == message.messageId)) {
        Conversation conv = conversations.firstWhere((e) => e.id == message.messageId);
        convMessages.add(w);
        conv.add(message);
      }
    }
  }

  // remove individual messages
  for (var e in convMessages) {
    dateWidgets.remove(e);
  }

  // Add conversations
  for (var conv in conversations) {
    conv.sort();

    dateWidgets.add(DateWidget(
      key: "${conv.newest.date.millisecondsSinceEpoch}-msg",
      date: conv.newest.date,
      widget: MessageTile(
        conv.newest,
      ),
    ));
  }

  dateWidgets.sort((a, b) => -a.date.compareTo(b.date));

  List<List<DateWidget>> groupedDateWidgets = [[]];
  for (var element in dateWidgets) {
    if (groupedDateWidgets.last.isNotEmpty) {
      if (!_sameDate(element.date, groupedDateWidgets.last.last.date)) {
        groupedDateWidgets.add([element]);
        continue;
      }
    }
    groupedDateWidgets.last.add(element);
  }

  List<DateWidget> items = [];

  if (groupedDateWidgets.first.isNotEmpty) {
    for (var elements in groupedDateWidgets) {
      bool cst = showTitle;

      // Group Absence Tiles
      List<DateWidget> absenceTileWidgets = elements.where((element) {
        return element.widget is AbsenceViewable && (element.widget as AbsenceViewable).absence.delay == 0;
      }).toList();
      List<AbsenceViewable> absenceTiles = absenceTileWidgets.map((e) => e.widget as AbsenceViewable).toList();
      if (absenceTiles.length > 1) {
        elements.removeWhere((element) => element.widget.runtimeType == AbsenceViewable && (element.widget as AbsenceViewable).absence.delay == 0);
        if (elements.isEmpty) {
          cst = false;
        }
        elements.add(DateWidget(
            widget: AbsenceGroupTile(absenceTiles, showDate: !cst),
            date: absenceTileWidgets.first.date,
            key: "${absenceTileWidgets.first.date.millisecondsSinceEpoch}-absence-group"));
      }

      // Bring Lesson Tiles to front & sort by index asc
      List<DateWidget> lessonTiles = elements.where((element) {
        return element.widget.runtimeType == ChangedLessonTile;
      }).toList();
      lessonTiles.sort((a, b) => (a.widget as ChangedLessonTile).lesson.lessonIndex.compareTo((b.widget as ChangedLessonTile).lesson.lessonIndex));
      elements.removeWhere((element) => element.widget.runtimeType == ChangedLessonTile);
      elements.insertAll(0, lessonTiles);

      final date = (elements + absenceTileWidgets).first.date;
      items.add(DateWidget(
        date: date,
        widget: Panel(
          key: ValueKey(date),
          padding: padding ?? const EdgeInsets.symmetric(vertical: 6.0),
          title: cst ? Text(date.format(context, forceToday: true)) : null,
          hasShadow: hasShadow,
          child: ImplicitlyAnimatedList<DateWidget>(
            areItemsTheSame: (a, b) => a.key == b.key,
            spawnIsolate: false,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, animation, item, index) => filterItemBuilder(context, animation, item.widget, index),
            items: elements,
          ),
        ),
      ));
    }
  }

  final nh = DateTime.now();
  final now = DateTime(nh.year, nh.month, nh.day).subtract(const Duration(seconds: 1));

  if (showDivider && items.any((i) => i.date.isBefore(now)) && items.any((i) => i.date.isAfter(now))) {
    items.add(
      DateWidget(
        date: now,
        widget: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 12.0),
            height: 3.0,
            width: 150.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: AppColors.of(context).text.withOpacity(.25),
            ),
          ),
        ),
      ),
    );
  }

  // Sort future dates asc, past dates desc
  items.sort((a, b) => (a.date.isAfter(now) && b.date.isAfter(now) ? 1 : -1) * a.date.compareTo(b.date));

  return items.map((e) => e.widget).toList();
}
